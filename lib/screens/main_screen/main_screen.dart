import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:student_management/components/sidebar.dart';
import 'package:student_management/constants.dart';
import 'package:student_management/screens/attendance_screen/attendance_screen.dart';
import 'package:student_management/screens/home_screen/home_screen.dart';
import 'package:student_management/screens/nothing_screen/nothing_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final List<Widget> screens = [
      const HomeScreen(),
      const Nothing(),
      const Nothing(),
    ];
    List<IconData> listOfIcons = [
      Icons.home_rounded,
      Icons.location_pin,
      Icons.info_rounded,
    ];
    List labels = [
      "Home",
      "Contact",
      "About Us",
    ];

    void onTabTapped(int index) {
      setState(() {
        currentIndex = index;
      });
    }

    Future<bool> kickOut() async {
      SystemNavigator.pop();
      return true;
    }

    var bottomBar = Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      height: size.width * .175,
      decoration: BoxDecoration(
        color: const Color.fromARGB(213, 255, 255, 255),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(0, 147, 12, 12).withOpacity(.15),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
        borderRadius: BorderRadius.circular(50),
      ),
      child: Center(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: 3, //Count of icons in bottom bar
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: size.width * .029),
          itemBuilder: (context, index) => InkWell(
            onTap: () => onTabTapped(index),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 1500),
                  curve: Curves.fastLinearToSlowEaseIn,
                  margin: EdgeInsets.only(
                    bottom: index == currentIndex ? 0 : size.width * .029,
                    right: size.width * .0422,
                    left: size.width * .0422,
                  ),
                  width: size.width * .128,
                  height: index == currentIndex ? size.width * .014 : 0,
                  decoration: const BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(10),
                    ),
                  ),
                ),
                Icon(
                  listOfIcons[index],
                  size: size.width * .066,
                  color: index == currentIndex
                      ? primaryColor
                      : const Color.fromARGB(255, 101, 100, 100),
                ),
                Text(
                  labels[index],
                  style: TextStyle(
                      color:
                          index == currentIndex ? primaryColor : Colors.black54,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return WillPopScope(
      onWillPop: () => kickOut(),
      child: SafeArea(
        top: true,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(size.height * 0.060),
            child: AppBar(
              elevation: 0,
            ),
          ),
          drawer: const SideBar(),
          extendBody: true,
         // bottomNavigationBar: bottomBar,
          body: screens[currentIndex],
        ),
      ),
    );
  }
}
