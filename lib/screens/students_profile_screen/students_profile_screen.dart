// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_management/components/profile_details.dart';
import 'package:student_management/components/profile_header.dart';
import 'package:student_management/constants.dart';
import 'package:student_management/screens/main_screen/main_screen.dart';
import 'package:student_management/services/api_services.dart';
import 'package:student_management/services/jwt_token_parser.dart';
import '../../components/profile_header_file_image.dart';
import 'package:image/image.dart' as img;

class StudentsProfileScreen extends StatefulWidget {
  final String? studentCode;
  const StudentsProfileScreen({required this.studentCode, super.key});

  @override
  State<StudentsProfileScreen> createState() => _StudentsProfileScreenState();
}

const double targetWidth = 150.0;
const double targetHeight = 200.0;
const int targetSizeKB = 30;
const int quality = 100;
const int maxFileSizeB = 30 * 1024;
const int minFileSizeB = 20 * 1024;

class _StudentsProfileScreenState extends State<StudentsProfileScreen> {
  final GlobalKey<ScaffoldState> key = GlobalKey();

  dynamic base64Image;
  dynamic studentDetail;
  Uint8List? _selectedFile;
  bool _inProcess = false;
  File? tempFile;
  @override
  void initState() {
    // TODO: implement initState
    getStudentDetails();
    super.initState();
  }

  getStudentDetails() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _inProcess = true;
    });

    showDialog(
        // The user CANNOT close this dialog  by pressing outsite it
        barrierDismissible: true,
        context: context,
        builder: (_) {
          return Dialog(
            // The background color
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  // The loading indicator
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 15,
                  ),
                  // Some text
                  Text('Loading...')
                ],
              ),
            ),
          );
        });
    final res = await studentDetails(widget.studentCode);
    final responseData = jsonDecode(res.body);

    if (res.statusCode == 200) {
      //await Future.delayed(const Duration(seconds: 3));
      Navigator.of(context).pop();

      // print("-=-===-=-=-=-=-=-=---=> ${responseData['data']}");
      var data = parseJwtAndSave(responseData['data']);
      // print(data);
      setState(() {
        studentDetail = data;

        if (studentDetail['personal_details'] == null) {
          _inProcess = true;
        }
        _inProcess = false;
      });
      debugPrint("==================> $studentDetail");
    } else {
      setState(() {
        _inProcess = false;
      });
      Navigator.of(context).pop();
      Fluttertoast.showToast(
        msg: "Unable to Sync Students List Now",
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 15.0,
      );
    }
  }

  void _handleError(dynamic error) {
    setState(() {
      _inProcess = false;
    });
  }

  void _handleLostFiles(List<XFile> files) {
    setState(() {
      _inProcess = false;
    });
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
    setState(() {
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
      CroppedFile? cropped = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: quality,
        // maxWidth: 800,
        // maxHeight: 800,
        compressFormat: ImageCompressFormat.jpg,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: primaryColor,
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
        final bytes = await newFile.readAsBytes();
        // final compressedImage = await compressImage(bytes, targetSizeKB);
        // final compressedImage = await compressImage(bytes, 30, 150, 200);
        final compressedImage = await compressImage(bytes, 30);
        final compressedSize = compressedImage.length;
        debugPrint("********");
        debugPrint('Compressed image size: $compressedSize bytes');
        final image = img.decodeImage(compressedImage)!;
        final width = image.width;
        final height = image.height;
        debugPrint('Image width: $width');
        debugPrint('Image height: $height');

        // final tempDir = await getTemporaryDirectory();
        //  tempFile = await File('${tempDir.path}/temp.jpg').create();
        // await tempFile!.writeAsBytes(compressedImage);

        // Resize the image to 150x200 pixels

        //   final resizedImage = img.copyResize(image, width: 150, height: 200);
        // final resizedWidth = resizedImage.width;
        // final resizedHeight = resizedImage.height;
        // debugPrint('Resized image width: $resizedWidth');
        // debugPrint('Resized image height: $resizedHeight');
        // var compressedImageData = img.encodeJpg(resizedImage, quality: 100);
        // var size = compressedImageData.length;
        // debugPrint('Resized image size: $size bytes');

        base64Image = base64.encode(compressedImage);
        setState(() {
          _selectedFile = base64Decode(base64Image);
          //  _selectedFile =File.fromRawPath(Uint8List.fromList(compressedImage));
          // _selectedFile = tempFile;
          // _selectedFile = newFile ;
          _inProcess = false;
        });
        imageupload();
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
      await getLostData();
    }
  }

  // Future<Uint8List> compressImage(List<int> imageData, int maxFileSizeKB) async {
  //      bool imagevalid=true;
  //   var image = img.decodeImage(imageData.toList())!;
  //   var quality = 90;
  //   var compressedImageData = img.encodeJpg(image, quality: quality);
  //   // if(compressedImageData.length < minFileSizeB){
  //   //    imagevalid=false;
  //   //   Fluttertoast.showToast(
  //   //     msg: " lessthan 20 kb!!!",
  //   //     gravity: ToastGravity.TOP,
  //   //     timeInSecForIosWeb: 1,
  //   //     backgroundColor: Colors.red,
  //   //     textColor: Colors.white,
  //   //     fontSize: 15.0,
  //   //   );

  //   // }
  //   // while ((compressedImageData.length > maxFileSizeB) ) {
  //   //   // if(compressedImageData.length < minFileSizeB){
  //   //   //   break;
  //   //   // }
  //   //   // image = img.copyResize(image,
  //   //   //     width: image.width ~/ 2, height: image.height ~/ 2);
  //   //   compressedImageData = img.encodeJpg(image, quality: quality);

  //   // }
  //     while (compressedImageData.length > 30000) {
  //   quality -= 10;
  //   compressedImageData = img.encodeJpg(image, quality: quality);
  // }
  // while (compressedImageData.length < 20000) {
  //   quality += 5;
  //   compressedImageData = img.encodeJpg(image, quality: quality);
  // }
  //   return Uint8List.fromList(compressedImageData);
  // }

  // Future<Uint8List> compressImage(
  //     List<int> imageData, int maxFileSizeKB) async {
  //   // converted to list
  //   var image = img.decodeImage(imageData.toList())!;

  //   // encode to jpg with 100% quality
  //   var quality = 100;
  //   var compressedImageData = img.encodeJpg(image, quality: quality);

  //   // find current image size
  //   int size = await compressedImageData.length;

  //   debugPrint("***** ***** $size ******");
  //   while (size > maxFileSizeB && quality > 10) {
  //     image = img.copyResize(image, width: 150, height: 200);
  //     quality = (quality - (quality * 0.1)).toInt();
  //     compressedImageData = img.encodeJpg(image, quality: quality);
  //   }

  //   return Uint8List.fromList(compressedImageData);
  // }

//   Future<Uint8List> compressImage(
//   List<int> imageData, int targetSizeKB, int targetWidth, int targetHeight) async {

//   // decode the image
//   var image = img.decodeImage(imageData.toList())!;

//   // resize the image to the target width and height
//   image = img.copyResize(image, width: targetWidth, height: targetHeight);

//   // encode to jpg with 100% quality
//   var quality = 100;
//   var compressedImageData = img.encodeJpg(image, quality: quality);

//   // find current image size
//   int size = await compressedImageData.length;

//   debugPrint("***** ***** $size ******");

//   // reduce the quality until the target size is reached
//   while (size > targetSizeKB * 1024 && quality > 10) {
//     quality = (quality - (quality * 0.1)).toInt();
//     compressedImageData = img.encodeJpg(image, quality: quality);
//     size = compressedImageData.length;
//   }

//   return Uint8List.fromList(compressedImageData);
// }

// Future<Uint8List> compressImage(
//   List<int> imageData, int targetSizeKB) async {
//     var image = img.decodeImage(imageData.toList())!;
//     var quality = 100;
//     var compressedImageData = img.encodeJpg(image, quality: quality);
//     int size = compressedImageData.length;

//     debugPrint("***** ***** $size ******");
//     while (size > targetSizeKB * 1024 && quality > 10) {
//       image = img.copyResize(image, width: 150, height: 200);
//       quality = (quality - (quality * 0.1)).toInt();
//       compressedImageData = img.encodeJpg(image, quality: quality);
//       size = compressedImageData.length;
//     }
//     while (size < targetSizeKB * 1024 && quality <= 100) {
//       quality = (quality + (quality * 0.1)).toInt();
//       compressedImageData = img.encodeJpg(image, quality: quality);
//       size = compressedImageData.length;
//     }

//     return Uint8List.fromList(compressedImageData);
// }

//*******Don't Delete this code *******//

// Future<Uint8List> compressImage(List<int> imageData, int targetSizeKB) async {
//   // converted to list
//   var image = img.decodeImage(imageData.toList())!;

//   // encode to jpg with 100% quality
//   var quality = 100;
//   var compressedImageData = img.encodeJpg(image, quality: quality);

//   // find current image size
//   int size = compressedImageData.length;

//   debugPrint("***** ***** $size ******");
//   while (size > targetSizeKB * 1024 && quality > 10) {
//     // reduce image quality by 10%
//     quality -= 10;
//     compressedImageData = img.encodeJpg(image, quality: quality);

//     // find current image size
//     size = compressedImageData.length;
//   }

//   // resize image if it is still larger than target size
//   if (size > targetSizeKB * 1024) {
//     image = img.copyResize(image, width: 150, height: 200);
//     quality = 100;
//     compressedImageData = img.encodeJpg(image, quality: quality);

//     // find current image size
//     size = compressedImageData.length;

//     while (size > targetSizeKB * 1024 && quality > 10) {
//       // reduce image quality by 10%
//       quality -= 10;
//       compressedImageData = img.encodeJpg(image, quality: quality);

//       // find current image size
//       size = compressedImageData.length;
//     }
//   }

//   return Uint8List.fromList(compressedImageData);
// }

  Future<Uint8List> compressImage(List<int> imageData, int targetSizeKB) async {
    // converted to list
    var image = img.decodeImage(imageData.toList())!;

    // resize image to 150 x 200
    image = img.copyResize(image, width: 150, height: 200);

    // encode to jpg with 100% quality
    var quality = 100;
    var compressedImageData = img.encodeJpg(image, quality: quality);

    // find current image size
    int size = compressedImageData.length;

    while (size > (targetSizeKB * 1024) && quality > 10) {
      // reduce image quality by 10%
      quality -= 10;

      compressedImageData = img.encodeJpg(image, quality: quality);

      // find current image size
      int ts = compressedImageData.length;
      debugPrint("***** while ***** $ts ******");
    }

    return Uint8List.fromList(compressedImageData);
  }

  Future<File> base64ToFile(String base64Data, String filePath) async {
    List<int> bytes = base64Decode(base64Data);
    File file = File(filePath);
    await file.writeAsBytes(bytes);
    return file;
  }

  Future<dynamic> imageupload() async {
    String base64Data = base64Image;
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/temps.jpg';

    File file = await base64ToFile(base64Data, filePath);
    dynamic dataToSubmit = {
      "image_data": file,
      "student_code": widget.studentCode,
    };

    final res = await uploadPhoto(dataToSubmit);
    //var responsedata = parseJwtAndSave(res);
    debugPrint("***********responsedata");
    debugPrint((res).toString());
//res.statusCode=200;
    if (res.statusCode == 200) {
      // final responseData = jsonDecode(res.body);
      //  debugPrint("***********responsedata message********");
      //debugPrint(responseData["message"].toString());
      //Navigator.pop(context);
      Fluttertoast.showToast(
        //msg: "Image Uploaded Succesfully",
        msg: "Image Uploaded Succesfully",
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 10,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 15.0,
      );
    } else if (res.statusCode == 202) {
      final responseData = jsonDecode(res.body);
      // Navigator.pop(context);
      Fluttertoast.showToast(
        msg: responseData["message"],
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 10,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 15.0,
      );
    } else {
      // ignore: use_build_context_synchronously
      //Navigator.pop(context);
      Fluttertoast.showToast(
        msg: "Something went wrong!!!",
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 15.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // ignore: prefer_const_constructors
    return SafeArea(
      top: true,
      child: Scaffold(
        key: key,
        appBar: AppBar(
          title: const Text("Profile"),
          elevation: 0,
          actions: <Widget>[
            Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainScreen(),
                      ),
                    );
                  },
                  child: const Icon(
                    Icons.home_filled,
                    size: 26.0,
                  ),
                )),
          ],
        ),
        body: Stack(
          children: [
            (_inProcess || studentDetail == null)
                ? SizedBox(
                    height: MediaQuery.of(context).size.height * 0.95,
                    child: const Center(
                      child: CircularProgressIndicator(color: primaryColor),
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Stack(
                          children: [
                            ClipPath(
                              clipper: CurveImage(),
                              child: Container(
                                width: size.width,
                                decoration: const BoxDecoration(
                                    color: Color.fromARGB(214, 242, 242, 242)),
                                child: (_selectedFile == null)
                                    ? ProfileHeader(
                                        imageUrl: (studentDetail['personal_details']['photo_url'] == null ||
                                                studentDetail['personal_details']
                                                        ['photo_url'] ==
                                                    "")
                                            ? ((studentDetail['personal_details']['gender'] == "Male")
                                                ? "assets/images/boy.png"
                                                : "assets/images/girl.png")
                                            : (base64Decode(studentDetail['personal_details']['photo_url'])
                                                .toString()),
                                        name: studentDetail['personal_details']
                                            ['full_name'],
                                        grade: studentDetail['current_details']
                                                ['class'] +
                                            studentDetail['current_details']
                                                ['division'])
                                    : ProfileHeaderImageFile(
                                        imageUrl: _selectedFile!,
                                        name: studentDetail['personal_details']['full_name'].toString(),
                                        grade: studentDetail['current_details']['class'].toString() + studentDetail['current_details']['division'].toString()),
                                //   : Image.file(_selectedFile!, width: targetWidth, height: targetHeight, fit: BoxFit.cover),
                              ),
                            ),
                            Positioned(
                                bottom: 20,
                                right: 20,
                                child: IconButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: ((builder) =>
                                            bottosmheet(context)));
                                    //  Navigator.push(
                                    //             context,
                                    //             MaterialPageRoute(
                                    //                 builder: (context) =>
                                    //                    ProfilePicturePicker(source: ImageSource.gallery)
                                    //                             ),
                                    //           );
                                  },
                                  icon: const Icon(Icons.camera_alt),
                                )),
                          ],
                        ),
                        SizedBox(height: size.height * 0.05),
                        Center(
                          child: Column(
                            children: <Widget>[
                              ProfileDetails(
                                  title: "Full Name",
                                  value: studentDetail['personal_details']
                                          ['full_name']
                                      .toString()),
                              ProfileDetails(
                                  title: "Admission No",
                                  value: studentDetail['personal_details']
                                          ['admission_no']
                                      .toString()),
                              ProfileDetails(
                                  title: "Gender",
                                  value: studentDetail['personal_details']
                                          ['gender']
                                      .toString()),
                              ProfileDetails(
                                  title: "School Name",
                                  value: studentDetail['personal_details']
                                          ['school_name']
                                      .toString()),
                              ProfileDetails(
                                  title: "Student Code",
                                  value: studentDetail['personal_details']
                                          ['student_code']
                                      .toString()),
                              ProfileDetails(
                                  title: "Nationality",
                                  value: studentDetail['personal_details']
                                          ['nationality']
                                      .toString()),
                              ProfileDetails(
                                  title: ("Hostelite"), //.toUpperCase(),
                                  value: studentDetail['personal_details']
                                          ['hostelite']
                                      .toString()),
                              SizedBox(height: size.height * 0.05),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(size.height * 0.03),
                                    child: Text(
                                      ("parent details").toUpperCase(),
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(
                                height: 10,
                                thickness: 1,
                                indent: 20,
                                endIndent: 20,
                                color: Colors.grey,
                              ),
                              SizedBox(height: size.height * 0.05),
                              ProfileDetails(
                                  title: ("Mothers Name"), //.toUpperCase(),
                                  value: studentDetail['parent_details']
                                          ['mother_full_name']
                                      .toString()),
                              ProfileDetails(
                                  title: ("Fathers Name"), //.toUpperCase(),
                                  value: studentDetail['parent_details']
                                          ['father_full_name']
                                      .toString()),
                              ProfileDetails(
                                  title: ("Guardian Name"), //.toUpperCase(),
                                  value: studentDetail['parent_details']
                                          ['guardian_name']
                                      .toString()),
                              ProfileDetails(
                                  title:
                                      ("Guardian Relation"), //.toUpperCase(),
                                  value: studentDetail['parent_details']
                                          ['guardian_relation'] ??
                                      "No Data Available"),
                              ProfileDetails(
                                  title:
                                      ("Guardian Occupation"), //.toUpperCase(),
                                  value: studentDetail['parent_details']
                                          ['guardian_occupation'] ??
                                      "No Data Available"),
                              ProfileDetails(
                                  title: ("Guardian Income"), //.toUpperCase(),
                                  value: studentDetail['parent_details']
                                          ['guardian_income'] ??
                                      "No Data Available"),
                              ProfileDetails(
                                  title: ("APL/BPL").toUpperCase(),
                                  value: studentDetail['parent_details']
                                      ['apl']),
                              SizedBox(height: size.height * 0.05),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(size.height * 0.03),
                                    child: Text(
                                      ("current details").toUpperCase(),
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(
                                height: 10,
                                thickness: 1,
                                indent: 20,
                                endIndent: 20,
                                color: Colors.grey,
                              ),
                              SizedBox(height: size.height * 0.05),
                              ProfileDetails(
                                  title: ("Class"), //.toUpperCase(),
                                  value: studentDetail['current_details']
                                          ['class']
                                      .toString()),
                              ProfileDetails(
                                  title: ("Division"), //.toUpperCase(),
                                  value: studentDetail['current_details']
                                          ['division']
                                      .toString()),
                              ProfileDetails(
                                  title:
                                      ("Physically Challenged"), //.toUpperCase(),
                                  value: studentDetail['current_details']
                                          ['physical_challenge']
                                      .toString()),
                              ProfileDetails(
                                  title: ("Medium Name"), //.toUpperCase(),
                                  value: studentDetail['current_details']
                                          ['medium_name']
                                      .toString()),
                              ProfileDetails(
                                  title: ("First Language "), //.toUpperCase(),
                                  value: studentDetail['current_details']
                                          ['first_language']
                                      .toString()),
                              ProfileDetails(
                                  title: ("Second Language"), //.toUpperCase(),
                                  value: studentDetail['current_details']
                                          ['second_language']
                                      .toString()),
                              ProfileDetails(
                                  title: ("Third Language"), //.toUpperCase(),
                                  value: studentDetail['current_details']
                                          ['third_language']
                                      .toString()),
                              ProfileDetails(
                                  title:
                                      ("Additional Language"), //.toUpperCase(),
                                  value: studentDetail['current_details']
                                          ['additional_language']
                                      .toString()),
                              ProfileDetails(
                                  title: ("Midday Meal"), //.toUpperCase(),
                                  value: studentDetail['current_details']
                                          ['middaymeal']
                                      .toString()),
                              SizedBox(height: size.height * 0.05),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(size.height * 0.03),
                                    child: Text(
                                      ("vaccination details").toUpperCase(),
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(
                                height: 10,
                                thickness: 1,
                                indent: 20,
                                endIndent: 20,
                                color: Colors.grey,
                              ),
                              SizedBox(height: size.height * 0.05),
                              ProfileDetails(
                                  title: ("Vaccinated"), //.toUpperCase(),
                                  value: studentDetail['vaccination_details']
                                          ['vaccinated']
                                      .toString()),
                              SizedBox(height: size.height * 0.05),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(size.height * 0.03),
                                    child: Text(
                                      ("additional details").toUpperCase(),
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(
                                height: 10,
                                thickness: 1,
                                indent: 20,
                                endIndent: 20,
                                color: Colors.grey,
                              ),
                              SizedBox(height: size.height * 0.05),
                              ProfileDetails(
                                  title: ("Mother Tongue"), //.toUpperCase(),
                                  value: studentDetail['additional_details']
                                          ['mother_tongue']
                                      .toString()),
                              ProfileDetails(
                                  title: ("Homeless"), //.toUpperCase(),
                                  value: studentDetail['additional_details']
                                          ['homeless']
                                      .toString()),
                              ProfileDetails(
                                  title: ("Habitation"), //.toUpperCase(),
                                  value: studentDetail['additional_details']
                                          ['habitation']
                                      .toString()),
                              ProfileDetails(
                                  title: ("Uniform Sets"), //.toUpperCase(),
                                  value: studentDetail['additional_details']
                                          ['uniform_sets']
                                      .toString()),
                              ProfileDetails(
                                  title: ("free texts").toUpperCase(),
                                  value: studentDetail['additional_details']
                                          ['free_texts']
                                      .toString()),
                              ProfileDetails(
                                  title: ("Transport"), //.toUpperCase(),
                                  value: studentDetail['additional_details']
                                          ['transport']
                                      .toString()),
                              ProfileDetails(
                                  title: ("Escort"), //.toUpperCase(),
                                  value: studentDetail['additional_details']
                                          ['escort']
                                      .toString()),
                              ProfileDetails(
                                  title: ("Hostel Facility"), //.toUpperCase(),
                                  value: studentDetail['additional_details']
                                          ['hostel_facility']
                                      .toString()),
                              ProfileDetails(
                                  title: ("Special Facility"), //.toUpperCase(),
                                  value: studentDetail['additional_details']
                                          ['special_facility']
                                      .toString()),
                              ProfileDetails(
                                  title:
                                      ("Identification Mark 1"), //.toUpperCase(),
                                  value: studentDetail['additional_details']
                                          ['identification_mark_1'] ??
                                      "No Data Available"),
                              ProfileDetails(
                                  title:
                                      ("Identification Mark 2"), //.toUpperCase(),
                                  value: studentDetail['additional_details']
                                          ['identification_mark_2'] ??
                                      "No Data Available"),
                              SizedBox(height: size.height * 0.05),
                              SizedBox(height: size.height * 0.05),
                            ],
                          ),
                        ),
                        const Center()
                      ],
                    ),
                  )
          ],
        ),
        backgroundColor: Colors.white,
      ),
    );
  }

  Widget bottosmheet(BuildContext context1) {
    Size size = MediaQuery.of(context1).size;
    return Stack(
      children: [
        // if (_inProcess) SizedBox(
        //       height:MediaQuery.of(context).size.height*0.15,
        //       child: const Center(
        //         child: CircularProgressIndicator(color: primaryColor),
        //       ),
        //     ) else
        SizedBox(
          height: size.height * 0.15,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const Text("Choose Profile Picture"),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            getImage(ImageSource.gallery);
                            Navigator.of(context1).pop();
                          },
                          icon: const Icon(
                            // <-- Icon
                            Icons.image,
                            size: 24.0,
                          ),
                          label: const Text('Gallery'), // <-- Text
                        ),
                      ),
                      //const Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            getImage(ImageSource.camera);
                            Navigator.of(context1).pop();
                          },
                          icon: const Icon(
                            // <-- Icon
                            Icons.camera_alt,
                            size: 24.0,
                          ),
                          label: const Text('Camera'), // <-- Text
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CurveImage extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 30);
    path.quadraticBezierTo(
        size.width / 4, size.height, size.width / 2, size.height);
    path.quadraticBezierTo(size.width - (size.width / 4), size.height,
        size.width, size.height - 30);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
