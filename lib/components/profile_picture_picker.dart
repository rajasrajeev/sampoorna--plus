import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image/image.dart' as img;

class ProfilePicturePicker extends StatefulWidget {
  final ImageSource source;
 // final ImageSource gallery;
  const ProfilePicturePicker(
      {super.key,
      required this.source,
      });
  @override
  _ProfilePicturePickerState createState() => _ProfilePicturePickerState();
}

const double targetWidth = 150.0;
const double targetHeight = 200.0;
const int targetSizeKB = 30;
const int quality = 70;

class _ProfilePicturePickerState extends State<ProfilePicturePicker> {
   File? _selectedFile;
  bool _inProcess = false;

  Widget getImageWidget() {
    if (_selectedFile != null) {
      return Image.file(
        _selectedFile!,
        width: 250,
        height: 250,
        fit: BoxFit.cover,
      );
    } else {
      return Image.asset(
        "assets/images/studentProfile.png",
        width: 250,
        height: 250,
        fit: BoxFit.cover,
      );
    }
  }
void _handleError(dynamic error) {
  setState(() {
    _inProcess = false;
  });
  print(error);
}
void _handleLostFiles(List<XFile> files) {
  for (XFile file in files) {
    print(file.path);
  }
}
  Future<void> getLostData() async {
    final ImagePicker picker = ImagePicker();
    final LostDataResponse response = await picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    final List<XFile>? files = response.files;
    if (files != null) {
      _handleLostFiles(files);
    } else {
      _handleError(response.exception);
    }
  }
  getImage(ImageSource source) async {
       debugPrint("**********************");
  // ignore: unnecessary_this
  this.setState(() {
    _inProcess = true;
  });
  XFile? image = await ImagePicker().pickImage(source: source);
  if (image == null) {
    setState(() {
      _inProcess = false;
    });
    return;
  }
  try {
     debugPrint("**********************");
    CroppedFile? cropped = await ImageCropper().cropImage(
      sourcePath: image.path,
      aspectRatio: const CropAspectRatio(ratioX: 3, ratioY: 4),
      compressQuality: quality,
      maxWidth: targetWidth.toInt()*3,
      maxHeight: targetHeight.toInt()*3,
      compressFormat: ImageCompressFormat.jpg,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.ratio3x2,
          lockAspectRatio: false,
        ),
        IOSUiSettings(title: 'Cropper'),
        // ignore: use_build_context_synchronously
        WebUiSettings(context: context),
      ],
    );
      debugPrint("****$cropped****");
    if (cropped != null) {
      final File newFile = File(cropped.path);
      final bytes = await newFile.readAsBytes();
      final compressedImage = await compressImage(bytes, targetSizeKB);
      final compressedSize =compressedImage.length;
             debugPrint("********");
        debugPrint('Compressed image size: $compressedSize bytes');
      setState(() {
        
        _selectedFile = compressedImage as File?;
        

        //base64Encode
         //base64Encode(_selectedFile as List<int>);
        _inProcess = false;
      });
      final compressedSizes = _selectedFile!.lengthSync();
              debugPrint("********");
        debugPrint('Compressed image size: $compressedSizes bytes');
    } else {
      setState(() {
        _inProcess = false;
      });
    }
  } catch (e) {
    // Handle error
    setState(() {
      _inProcess = false;
    });
   // await getLostData();
  }
}

getImageNoCrop() async {
  XFile? image = await ImagePicker().pickImage(
    source: ImageSource.camera,
    imageQuality: 50,
  );
  if (image == null) {
    setState(() {
      _inProcess = false;
    });
    return;
  }
  try {
    setState(() {
      _selectedFile = File(image.path);
      _inProcess = false;
    });
  } catch (e) {
    // Handle error
    setState(() {
      _inProcess = false;
    });
    await getLostData();
  }
}

  Future<List<int>> compressImage(List<int> imageData, int maxFileSizeKB) async {
    var image = img.decodeImage(imageData.toList())!;
    var compressedImageData = img.encodeJpg(image, quality: quality);
    while (compressedImageData.length > maxFileSizeKB * 1024) {
      image = img.copyResize(image, width: image.width ~/ 2, height: image.height ~/ 2);
      compressedImageData = img.encodeJpg(image, quality: quality);
    }
    return compressedImageData;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Column(
            children: [
               getImageWidget(),
              MaterialButton(
                  color: Colors.blue,
                  child: const Text("Pick Image from Gallery",
                      style: TextStyle(
                          color: Colors.white70, fontWeight: FontWeight.bold)),
                  onPressed: () {
                    getImage(ImageSource.gallery);
                  }),
              MaterialButton(
                  color: Colors.blue,
                  child: const Text("Pick Image from Camera",
                      style: TextStyle(
                          color: Colors.white70, fontWeight: FontWeight.bold)),
                  onPressed: () {
                    getImage(ImageSource.camera);
                  }),

              //To Display image without crop
                            MaterialButton(
                  color: Color.fromARGB(255, 27, 74, 113),
                  child: const Text("Pick Image from Camera without crop",
                      style: TextStyle(
                          color: Colors.white70, fontWeight: FontWeight.bold)),
                  onPressed: () {
                    getImageNoCrop();
                  }),
             
            ],
          ),
        ),
      ],
    );
  }
}
