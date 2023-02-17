import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:student_management/components/sidebar.dart';
import 'package:student_management/constants.dart';
import 'package:student_management/screens/attendance_screen/attendance_screen.dart';
import 'package:student_management/screens/home_screen/home_screen.dart';


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
      const AttendanceScreen(),
      //const PhotosScreen(showAppbar: false),
      //const ShareHoldersScreen(),
    ];
        List<IconData> listOfIcons = [
      Icons.home_rounded,
      Icons.price_change_outlined,
      //Icons.panorama_outlined,
     // Icons.account_tree_outlined,
    ];
        List labels = [
      "Home",
      "Attendance",
     // "Photos",
      //"Partner",
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
      height: size.width * .160,
      decoration: BoxDecoration(
        color: primaryColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.15),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
        borderRadius: BorderRadius.circular(50),
      ),
      child: ListView.builder(
        itemCount: 4,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: size.width * .024),
        itemBuilder: (context, index) => InkWell(
          onTap: () => onTabTapped(index),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(10),
                  ),
                ),
              ),
              Icon(
                listOfIcons[index],
                size: size.width * .066,
                color: index == currentIndex ? Colors.white : Colors.black54,
              ),
              Text(
                labels[index],
                style: TextStyle(
                    color:
                        index == currentIndex ? Colors.white : Colors.black54,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: size.width * .02),
            ],
          ),
        ),
      ),
    );

    return WillPopScope(
      onWillPop: () => kickOut(),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(size.height * 0.060),
          child:  AppBar(),
        ),
        drawer: const SideBar(),
        extendBody: true,
        bottomNavigationBar: bottomBar,
        body: screens[currentIndex],
      ),
    );
  }
}