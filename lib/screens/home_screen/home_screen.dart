import 'package:flutter/material.dart';
import 'package:student_management/components/app_bar.dart';
import 'package:student_management/components/sidebar.dart';
import 'package:student_management/screens/home_screen/body.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> key = GlobalKey();
    Size size = MediaQuery.of(context).size;
    // ignore: prefer_const_constructors
    return Scaffold(
      key: key,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size.height * 0.065),
        child: Builder(
          builder: (context) => ApplicationBar(
            title: 'Sampoorna Plus',
            onClick: () => key.currentState!.openDrawer(),
          ),
        ),
      ),
      body: const Body(),
      drawer: const SideBar(),
      backgroundColor: Colors.white,
    );
  }
}
