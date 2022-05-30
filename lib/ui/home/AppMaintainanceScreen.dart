import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:insuvaicustomer/apiservice/EndPoints.dart';
import 'package:insuvaicustomer/res/ResColor.dart';
import 'package:insuvaicustomer/utils/LocalStorageName.dart';
import 'package:permission_handler/permission_handler.dart' as permis;
import 'package:shared_preferences/shared_preferences.dart';

import '../../animationlist/src/animation_configuration.dart';
import '../../animationlist/src/animation_limiter.dart';
import '../../animationlist/src/fade_in_animation.dart';
import '../../animationlist/src/scale_animation.dart';
import '../../animationlist/src/slide_animation.dart';
import '../../apiservice/ApiService.dart';
import '../../apiservice/EndPoints.dart';
import '../../imageslider/carousel_slider.dart';
import '../../models/DashBoardDataModell.dart';
import '../../res/ResString.dart';
import '../../uicomponents/AlertDialogBox.dart';
import '../../uicomponents/progress_button.dart';
import '../../utils/Utils.dart';
import 'homesubscreen/CartSubScreen.dart';
import 'homesubscreen/CategorySearchScreen.dart';
import 'homesubscreen/HomeSubScreen.dart';
import 'homesubscreen/ProfileScreen.dart';

class AppMaintainanceScreen extends StatefulWidget {
  final bool IsBackAble;
  AppMaintainanceScreen(this.IsBackAble);
  @override
  AppMaintainanceScreenState createState() => AppMaintainanceScreenState();
}

class AppMaintainanceScreenState extends State<AppMaintainanceScreen> {
  ButtonState buttonState = ButtonState.normal;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: WhiteColor,
      body: Container(
        padding: EdgeInsets.only(top: 15, left: 15, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
            Image.asset(
              IMAGE_PATH + "maintanence.png",
              height: 250,
              width: 350,
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              "INSUVAI DELIVERY SERVICES",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18, fontFamily: Inter_bold, color: BlackColor),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "We are closed now, will be back online soon! Please stay connected!",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  fontFamily: Segoe_ui_semibold,
                  color: BlackColor2),
            ),
            SizedBox(
              height: 20,
            ),
            ProgressButton(
              child: Text(
                OKAY,
                style: TextStyle(
                  color: WhiteColor,
                  fontFamily: Segoe_ui_semibold,
                  height: 1.1,
                ),
              ),
              onPressed: () {
                if (widget.IsBackAble) {
                  Navigator.pop(context);
                }
              },
              buttonState: buttonState,
              backgroundColor: MainColor,
              progressColor: WhiteColor,
              border_radius: Rounded_Button_Corner,
            )
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: WhiteColor,
        flexibleSpace: FlexibleSpaceBar(),
        elevation: 2,
        centerTitle: false,
        automaticallyImplyLeading: false,
        leading: null,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              AppMaintenance,
              style: TextStyle(
                  fontSize: 16, fontFamily: Inter_bold, color: BlackColor),
            ),
          ],
        ),
      ),
    );
  }
}
