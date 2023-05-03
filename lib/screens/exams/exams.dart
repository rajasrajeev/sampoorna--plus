import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_management/screens/main_screen/main_screen.dart';
import 'package:student_management/screens/parents/dashboard/parents_dashboard_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io';

import '../../services/api_services.dart';

class ExamsScreen extends StatefulWidget {
  const ExamsScreen({Key? key}) : super(key: key);

  @override
  State<ExamsScreen> createState() => _ExamsScreenState();
}

class _ExamsScreenState extends State<ExamsScreen> {
  bool _loading = true;
  String? token;
  dynamic url;
  dynamic link;
  String? userType = "";

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
    getToken();
  }

  getToken() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    userType = prefs.getString('user_type');
    final res = await getWebViewURL();
    if (res.statusCode == 200) {
      final responseData = jsonDecode(res.body);

      setState(() {
        url = responseData['url'];
      });

      final res2 = await getWebView(url);

      if (res2.statusCode == 200) {
        setState(() {
          _loading = false;
        });
        final response2Data = jsonDecode(res2.body);

        setState(() {
          link = Uri.decodeComponent(response2Data['link']);
        });
      }
    } else {
      setState(() {
        _loading = false;
      });

      Fluttertoast.showToast(
        msg: "Unable to Load Now",
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Exams"),
        elevation: 0,
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => userType == "PARENT"
                          ? const ParentsDashboardScreen()
                          : const MainScreen(),
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
      body: OrientationBuilder(
        builder: (context, orientation) {
          return orientation == Orientation.portrait
              ? Stack(
                  children: <Widget>[
                    _loading
                        ? const Center(child: CircularProgressIndicator())
                        : WebView(
                            initialUrl: link,
                            javascriptMode: JavascriptMode.unrestricted,
                            onPageFinished: (finish) {
                              setState(() {
                                _loading = false;
                              });
                            },
                          ),
                  ],
                )
              : const Center(
                  child: Text('Rotate Device!'),
                );
        },
      ),
    );
  }
}