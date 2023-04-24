import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_management/screens/parents/dashboard/parents_dashboard_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io';

class ExamsScreen extends StatefulWidget {
  const ExamsScreen({Key? key}) : super(key: key);

  @override
  State<ExamsScreen> createState() => _ExamsScreenState();
}

class _ExamsScreenState extends State<ExamsScreen> {
  bool isLoading = true;
  String? token;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  getToken() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
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
                        webViewController.loadUrl(
                            'https://sampoorna.kite.kerala.gov.in:446/plus/loginApp',
                            headers: headers);
                      },
                      onPageFinished: (finish) {
                        setState(() {
                          isLoading = false;
                        });
                      },
                    ),
                    isLoading
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
