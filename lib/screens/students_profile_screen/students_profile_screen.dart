// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_management/components/profile_details.dart';
import 'package:student_management/components/profile_header.dart';
import 'package:student_management/constants.dart';
import 'package:student_management/screens/main_screen/main_screen.dart';
import 'package:student_management/services/api_services.dart';
import 'package:student_management/services/jwt_token_parser.dart';

import '../../components/profile_header_file_image.dart';

class StudentsProfileScreen extends StatefulWidget {
  final String? studentCode;
  const StudentsProfileScreen({required this.studentCode, super.key});

  @override
  State<StudentsProfileScreen> createState() => _StudentsProfileScreenState();
}

class _StudentsProfileScreenState extends State<StudentsProfileScreen> {
  final GlobalKey<ScaffoldState> key = GlobalKey();
  dynamic? studentDetail;
  File? _selectedFile;
  bool _inProcess = false;

  @override
  void initState() {
    // TODO: implement initState
    getStudentDetails();
    super.initState();
  }

  getStudentDetails() async {
    final prefs = await SharedPreferences.getInstance();

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
      });
      print("==================> ${studentDetail}");
    } else {
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

  // Widget getImageWidget() {
  //   if (_selectedFile != null) {
  //     return Image.file(
  //       _selectedFile!,
  //       width: 250,
  //       height: 250,
  //       fit: BoxFit.cover,
  //     );
  //   } else {
  //     return Image.asset(
  //       "assets/images/studentProfile.png",
  //       width: 250,
  //       height: 250,
  //       fit: BoxFit.cover,
  //     );
  //   }
  // }

  void _handleError(dynamic error) {
    setState(() {
      _inProcess = false;
    });
    // print(error);
  }

  void _handleLostFiles(List<XFile> files) {
    // for (XFile file in files) {
    //   print(file.path);
    // }
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
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 100,
        maxWidth: 700,
        maxHeight: 700,
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
            SingleChildScrollView(
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
                                  imageUrl: (studentDetail['personal_details']
                                              ['gender'] ==
                                          "Male")
                                      ? "assets/images/boy.png"
                                      : "assets/images/girl.png",
                                  name: studentDetail['personal_details']
                                      ['full_name'],
                                  grade: studentDetail['current_details']
                                          ['class'] +
                                      studentDetail['current_details']
                                          ['division'])
                              : ProfileHeaderImageFile(
                                  imageUrl: _selectedFile!,
                                  name: studentDetail['personal_details']
                                      ['full_name'],
                                  grade: studentDetail['current_details']
                                          ['class'] +
                                      studentDetail['current_details']
                                          ['division']),
                        ),
                      ),
                      Positioned(
                          bottom: 20,
                          right: 20,
                          child: IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: ((builder) => bottosmheet(context)));
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
                                ['full_name'].toString()),
                        ProfileDetails(
                            title: "Admission No",
                            value: studentDetail['personal_details']
                                ['admission_no'].toString()),
                        ProfileDetails(
                            title: "Gender",
                            value: studentDetail['personal_details']['gender'].toString()),
                        ProfileDetails(
                            title: "School Name",
                            value: studentDetail['personal_details']
                                ['school_name'].toString()),
                        ProfileDetails(
                            title: "Student Code",
                            value: studentDetail['personal_details']
                                ['student_code'].toString()),
                        ProfileDetails(
                            title: "Nationality",
                            value: studentDetail['personal_details']
                                ['nationality'].toString()),
                        ProfileDetails(
                            title: ("Hostelite"), //.toUpperCase(),
                            value: studentDetail['personal_details']
                                ['hostelite'].toString()),
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
                                ['mother_full_name'].toString()),
                        ProfileDetails(
                            title: ("Fathers Name"), //.toUpperCase(),
                            value: studentDetail['parent_details']
                                ['father_full_name'].toString()),
                        ProfileDetails(
                            title: ("Guardian Name"), //.toUpperCase(),
                            value: studentDetail['parent_details']
                                ['guardian_name'].toString()),
                        ProfileDetails(
                            title: ("Guardian Relation"), //.toUpperCase(),
                            value: studentDetail['parent_details']
                                ['guardian_relation']??"No Data Available"),
                        ProfileDetails(
                            title: ("Guardian Occupation"), //.toUpperCase(),
                            value: studentDetail['parent_details']
                                ['guardian_occupation']??"No Data Available"),
                        ProfileDetails(
                            title: ("Guardian Income"), //.toUpperCase(),
                            value:studentDetail['parent_details']
                                    ['guardian_income']??"No Data Available"),
                        ProfileDetails(
                            title: ("APL/BPL").toUpperCase(),
                            value: studentDetail['parent_details']['apl']),
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
                            value: studentDetail['current_details']['class'].toString()),
                        ProfileDetails(
                            title: ("Division"), //.toUpperCase(),
                            value: studentDetail['current_details']
                                ['division'].toString()),
                        ProfileDetails(
                            title: ("Physically Challenged"), //.toUpperCase(),
                            value: studentDetail['current_details']
                                ['physical_challenge'].toString()),
                        ProfileDetails(
                            title: ("Medium Name"), //.toUpperCase(),
                            value: studentDetail['current_details']
                                ['medium_name'].toString()),
                        ProfileDetails(
                            title: ("First Language "), //.toUpperCase(),
                            value: studentDetail['current_details']
                                ['first_language'].toString()),
                        ProfileDetails(
                            title: ("Second Language"), //.toUpperCase(),
                            value: studentDetail['current_details']
                                    ['second_language']
                                .toString()),
                        ProfileDetails(
                            title: ("Third Language"), //.toUpperCase(),
                            value: studentDetail['current_details']
                                ['third_language'].toString()),
                        ProfileDetails(
                            title: ("Additional Language"), //.toUpperCase(),
                            value: studentDetail['current_details']
                                ['additional_language'].toString()),
                        ProfileDetails(
                            title: ("Midday Meal"), //.toUpperCase(),
                            value: studentDetail['current_details']
                                ['middaymeal'].toString()),
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
                                ['vaccinated'].toString()),
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
                                ['mother_tongue'].toString()),
                        ProfileDetails(
                            title: ("Homeless"), //.toUpperCase(),
                            value: studentDetail['additional_details']
                                ['homeless'].toString()),
                        ProfileDetails(
                            title: ("Habitation"), //.toUpperCase(),
                            value: studentDetail['additional_details']
                                ['habitation'].toString()),
                        ProfileDetails(
                            title: ("Uniform Sets"), //.toUpperCase(),
                            value: studentDetail['additional_details']
                                ['uniform_sets'].toString()),
                        ProfileDetails(
                            title: ("free texts").toUpperCase(),
                            value: studentDetail['additional_details']
                                    ['free_texts']
                                .toString()),
                        ProfileDetails(
                            title: ("Transport"), //.toUpperCase(),
                            value: studentDetail['additional_details']
                                ['transport'].toString()),
                        ProfileDetails(
                            title: ("Escort"), //.toUpperCase(),
                            value: studentDetail['additional_details']
                                ['escort'].toString()),
                        ProfileDetails(
                            title: ("Hostel Facility"), //.toUpperCase(),
                            value: studentDetail['additional_details']
                                ['hostel_facility'].toString()),
                        ProfileDetails(
                            title: ("Special Facility"), //.toUpperCase(),
                            value: studentDetail['additional_details']
                                ['special_facility'].toString()),
                        ProfileDetails(
                            title: ("Identification Mark 1"), //.toUpperCase(),
                            value: studentDetail['additional_details']
                                ['identification_mark_1']??"No Data Available"),
                        ProfileDetails(
                            title: ("Identification Mark 2"), //.toUpperCase(),
                            value: studentDetail['additional_details']
                                ['identification_mark_2']??"No Data Available"),
                        SizedBox(height: size.height * 0.05),
                        // const Divider(
                        //   height: 10,
                        //   thickness: 1,
                        //   indent: 20,
                        //   endIndent: 20,
                        //   color: Colors.black45,
                        // ),
                        SizedBox(height: size.height * 0.05),
                      ],
                    ),
                  ),
                  const Center()
                ],
              ),
            ),
            (_inProcess)
                ? Container(
                    height: MediaQuery.of(context).size.height * 0.95,
                    child: const Center(
                      child: CircularProgressIndicator(color: primaryColor),
                    ),
                  )
                : Container()
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
