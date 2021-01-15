

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:virtual_approval_flutter/InfosPage.dart';
import 'package:virtual_approval_flutter/RequestPage.dart';
import 'package:virtual_approval_flutter/SignIn.dart';
import 'package:virtual_approval_flutter/SignUp.dart';

BuildContext testContext;

class MainPage extends StatefulWidget {
  final BuildContext menuScreenContext;
  MainPage({Key key, this.menuScreenContext}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  PersistentTabController _controller;
  bool _hideNavBar;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
    _hideNavBar = false;
  }

  List<Widget> _buildScreens() {
    return [
      RequestPage(),
      InfosPage(),
      SignIn(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.paperplane),
        title: ("Help"),
        activeColor: CupertinoColors.activeBlue,
        inactiveColor: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.book),
        title: ("Info"),
        activeColor: CupertinoColors.activeBlue,
        inactiveColor: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.person),
        title: ("TA"),
        activeColor: CupertinoColors.activeBlue,
        inactiveColor: CupertinoColors.systemGrey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
      appBar: AppBar(
        title: const Text('BYUH Tutoring'),
        automaticallyImplyLeading: true,
        leading: BackButton(),
        actions: [
          IconButton(icon: Icon(Icons.wb_sunny), onPressed: () {
            AwesomeDialog(
              context: context,
              headerAnimationLoop: false,
              dialogType: DialogType.NO_HEADER,
              title: 'About',
              desc:
              'Something about the app.',
              btnOkOnPress: () {
                debugPrint('OnClcik');
              },
              btnOkIcon: Icons.check_circle,
            )..show();
          }),
          Text("     ")
        ],
      ),
      //
      // appBar: AppBar(
      //   title:
      //   new Center(child: new Text(
      //     "BYUH Tutoring",
      //     textAlign: TextAlign.center,
      //     // style: TextStyle(fontSize: 30),
      //   )),
      //   // toolbarHeight: 50,
      //   leading:
      //   BackButton(),
      //   actions: [
      //     Icon(Icons.add),
      //   ],
      // ),

      body: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: Colors.white,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        navBarHeight: MediaQuery.of(context).viewInsets.bottom > 0
            ? 0.0
            : kBottomNavigationBarHeight,
        hideNavigationBarWhenKeyboardShows: true,
        margin: EdgeInsets.all(10.0),
        popActionScreens: PopActionScreensType.once,
        bottomScreenMargin: 0.0,
        onWillPop: () async {
          AwesomeDialog(
            context: context,
            borderSide: BorderSide(color: Colors.green, width: 2),
            width: 500,
            // dialogType: DialogType.SUCCES,
            buttonsBorderRadius: BorderRadius.all(Radius.circular(2)),
            headerAnimationLoop: false,
            animType: AnimType.BOTTOMSLIDE,
            title: 'Aloha!',
            desc: 'Are you sure to leave?',
            // showCloseIcon: true,
            btnCancelOnPress: () {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.SUCCES,
                headerAnimationLoop: true,
                animType: AnimType.BOTTOMSLIDE,
                title: 'Mahalo!',
                desc: 'See you next time.',
              )..show();
              // exit app
              Future.delayed(const Duration(milliseconds: 3000), () {
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              });
            },
            btnOkOnPress: () {},
            btnOkText: "Stay",
            btnCancelText: "Exit",
          )..show();
          return true;
        },
        selectedTabScreenContext: (context) {
          testContext = context;
        },
        hideNavigationBar: _hideNavBar,
        decoration: NavBarDecoration(
            colorBehindNavBar: Colors.indigo,
            borderRadius: BorderRadius.circular(20.0)),
        popAllScreensOnTapOfSelectedTab: true,
        itemAnimationProperties: ItemAnimationProperties(
          duration: Duration(milliseconds: 400),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimation(
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle:
        NavBarStyle.style6, // Choose the nav bar style with this property
      ),
    );
  }
}

