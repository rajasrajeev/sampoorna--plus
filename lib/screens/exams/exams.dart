import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_management/screens/parents/dashboard/parents_dashboard_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io';

import '../../services/api_services.dart';
import '../../services/jwt_token_parser.dart';

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

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
    getToken();
  }

  getToken() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    final res = await getWebViewURL();
    if (res.statusCode == 200) {
      setState(() {
        _loading = false;
      });
      final responseData = jsonDecode(res.body);

      setState(() {
         url = responseData['url'];
      });
      debugPrint("*******URL responseData**********");
      debugPrint("$url");
      debugPrint("*******responseData End**********");
      final res2 = await getWebView(url);
    debugPrint("*******response2 Data status code**********");
    debugPrint(res2.statusCode.toString());
    debugPrint("*******end response2 Data status code**********");
    if (res2.statusCode == 200) {
       setState(() {
        _loading = false;
      });
     final response2Data = jsonDecode(res2.body);

    setState(() {
        link = response2Data['link'];
      });
           debugPrint("******* response2 Data Link **********");
    debugPrint(Uri.decodeComponent(link).toString());
    debugPrint("******* end response2 Data Link **********");
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
                      builder: (context) => const ParentsDashboardScreen(),
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
                    WebView(
                      javascriptMode: JavascriptMode.unrestricted,
                      onWebViewCreated: (WebViewController webViewController) {
                       var headers = {"Authorization": "Bearer $token"};
                      var decodedlink = Uri.decodeComponent(link);
                        webViewController.loadUrl(
                          decodedlink,
                            headers: headers
                            );
                      },
                      onPageFinished: (finish) {
                        setState(() {
                          _loading = false;
                        });
                      },
                    ),
                    _loading
                        ? const Center(child: CircularProgressIndicator())
                        : Stack(),
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
