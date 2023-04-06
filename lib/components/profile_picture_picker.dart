import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:permission_handler/permission_handler.dart';

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
  this.setState(() {
    _inProcess = true;
  });
  XFile? image = await ImagePicker().pickImage(source: source);
  if (image == null) {
    this.setState(() {
      _inProcess = false;
    });
    return;
  }
  try {
    CroppedFile? cropped = await ImageCropper().cropImage(
      sourcePath: image.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 100,
      maxWidth: 700,
      maxHeight: 700,
      compressFormat: ImageCompressFormat.jpg,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(title: 'Cropper'),
        WebUiSettings(context: context),
      ],
    );
    if (cropped != null) {
      final File newFile = File(cropped.path);
      this.setState(() {
        _selectedFile = newFile;
        _inProcess = false;
      });
    } else {
      this.setState(() {
        _inProcess = false;
      });
    }
  } catch (e) {
    // Handle error
    this.setState(() {
      _inProcess = false;
    });
    await getLostData();
  }
}

getImageNoCrop() async {
  XFile? image = await ImagePicker().pickImage(
    source: ImageSource.camera,
    imageQuality: 50,
  );
  if (image == null) {
    this.setState(() {
      _inProcess = false;
    });
    return;
  }
  try {
    this.setState(() {
      _selectedFile = File(image.path);
      _inProcess = false;
    });
  } catch (e) {
    // Handle error
    this.setState(() {
      _inProcess = false;
    });
    await getLostData();
  }
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
