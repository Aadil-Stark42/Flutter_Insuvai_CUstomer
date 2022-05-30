import 'package:flutter/material.dart';
import 'package:insuvaicustomer/pushnotifications/PushNotificationService.dart';
import 'package:insuvaicustomer/res/ResString.dart';
import 'package:insuvaicustomer/ui/home/HomeScreen.dart';
import 'package:insuvaicustomer/ui/intro/IntroScreen.dart';
import 'package:insuvaicustomer/ui/address/SelectAddressScreen.dart';
import 'package:insuvaicustomer/ui/login/LoginScreen.dart';
import 'package:insuvaicustomer/utils/LocalStorageName.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Insuvai Customer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MySplashScreenPage(),
    );
  }
}

class MySplashScreenPage extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<MySplashScreenPage> {
  Future checkFirstSeen() async {
    print("checkFirstSeen");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Future.delayed(const Duration(milliseconds: 200), () {
      // Do something
      print("delayed");
      bool _seen = (prefs.getBool(introscreen) ?? false);
      print("DEVICE_IDDEVICE_ID${prefs.getString(DEVICE_ID)}");
      print("SELECTED_ADDRESS_ID${prefs.getString(SELECTED_ADDRESS_ID)}");
      if (_seen) {
        if (prefs.getBool(ISLOGIN) == true) {
          //Go to Home
          if (prefs.getString(SELECTED_ADDRESS_ID) == null) {
            //Go to address Selection
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SelectAddressScreen(false, "", false)),
                (Route<dynamic> route) => false);
          } else {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
                (Route<dynamic> route) => false);
          }
        } else {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
              (Route<dynamic> route) => false);
        }
      } else {
        prefs.setBool(introscreen, true);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => IntroScreen()),
            (Route<dynamic> route) => false);
      }
      print("_seen_seen_seen$_seen");
      return _seen;
    });
  }

  @override
  void initState() {
    super.initState();
    checkFirstSeen();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Image(image: AssetImage('${IMAGE_PATH}insuvai_splash.png')));
  }
}
