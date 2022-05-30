import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:insuvaicustomer/main.dart';

import 'package:insuvaicustomer/res/ResColor.dart';
import 'package:insuvaicustomer/ui/information/CantactUsScreen.dart';
import 'package:insuvaicustomer/ui/information/TermsAndConditionScreen.dart';
import 'package:insuvaicustomer/ui/order/MyOrdersScreen.dart';
import 'package:insuvaicustomer/utils/Utils.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../apiservice/ApiService.dart';
import '../../../apiservice/EndPoints.dart';
import '../../../res/ResString.dart';
import '../../../uicomponents/progress_button.dart';
import '../../../utils/LocalStorageName.dart';
import '../../address/SelectAddressScreen.dart';
import '../AppMaintainanceScreen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    PackageInfoo();
    UserDetails();
  }

  ButtonState buttonState = ButtonState.normal;
  String VersionName = "", User_Name = "", User_Mobile = "", Package_Name = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WhiteColor,
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: WhiteColor,
        title: Text(
          Profile,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
          style: TextStyle(
              fontSize: 16, fontFamily: Segoe_ui_bold, color: BlackColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          User_Name,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: Segoe_ui_bold,
                              color: BlackColor),
                        ),
                        SizedBox(height: 2),
                        Text(
                          User_Mobile,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: Segoe_ui_bold,
                              color: GreyColor),
                        )
                      ],
                    )),
                    InkWell(
                      onTap: () {
                        ChangeProfileDialog();
                      },
                      child: Text(
                        "Change",
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: Segoe_ui_semibold,
                            color: MainColor),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  height: 0.5,
                  color: GreyColor2,
                ),
                SizedBox(
                  height: 40,
                ),
                InkWell(
                  onTap: () {
                    if (CHECKAPPSTATUS == STATUSNUMBER) {
                      Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                            builder: (context) => AppMaintainanceScreen(true)),
                      );
                    } else {
                      Navigator.of(context, rootNavigator: true)
                          .push(MaterialPageRoute(
                        builder: (context) =>
                            SelectAddressScreen(true, "", false),
                      ));
                    }
                  },
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        Address,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: Segoeui,
                            color: BlackColor),
                      )),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 18,
                        color: MainColor,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: () {
                    if (CHECKAPPSTATUS == STATUSNUMBER) {
                      Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                            builder: (context) => AppMaintainanceScreen(true)),
                      );
                    } else {
                      Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                            builder: (context) => MyOrdersScreen()),
                      );
                    }
                  },
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        Orders,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: Segoeui,
                            color: BlackColor),
                      )),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 18,
                        color: MainColor,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context, rootNavigator: true)
                        .push(MaterialPageRoute(
                      builder: (context) =>
                          TermsAndConditionScreen(TERMS_CONDITION),
                    ));
                  },
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        TermsandConditions,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: Segoeui,
                            color: BlackColor),
                      )),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 18,
                        color: MainColor,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context, rootNavigator: true)
                        .push(MaterialPageRoute(
                      builder: (context) =>
                          TermsAndConditionScreen(PRIVACY_POLICY),
                    ));
                  },
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        PrivacyPolicy,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: Segoeui,
                            color: BlackColor),
                      )),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 18,
                        color: MainColor,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: () {
                    StoreRedirect.redirect();
                  },
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        Rateus,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: Segoeui,
                            color: BlackColor),
                      )),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 18,
                        color: MainColor,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context, rootNavigator: true)
                        .push(MaterialPageRoute(
                      builder: (context) => CantactUsScreen(),
                    ));
                  },
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        ContactUs,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: Segoeui,
                            color: BlackColor),
                      )),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 18,
                        color: MainColor,
                      )
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ProgressButton(
                    child: Text(
                      Logout,
                      style: TextStyle(
                        color: WhiteColor,
                        fontFamily: Segoe_ui_semibold,
                        height: 1.1,
                      ),
                    ),
                    onPressed: () {
                      LogoutDialogShow(context);
                    },
                    buttonState: buttonState,
                    backgroundColor: MainColor,
                    progressColor: WhiteColor,
                    border_radius: Rounded_Button_Corner,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "V." + VersionName,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: Segoeui,
                        color: TransBlackColor),
                  ),
                  SizedBox(
                    height: 3,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future PackageInfoo() async {
    print("VersionName" + VersionName);
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      VersionName = packageInfo.version;
      Package_Name = packageInfo.packageName;
      print("VersionName" + VersionName);
    });
  }

  void UserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      User_Name = prefs.getString(USER_NAME)!;
      User_Mobile = prefs.getString(USER_MOBILE)!;
    });
  }

  void ChangeProfileDialog() {
    String Name = User_Name;
    ButtonState buttonState = ButtonState.normal;
    var textEditingController = TextEditingController();
    textEditingController.text = Name;
    textEditingController.selection =
        TextSelection(baseOffset: Name.length, extentOffset: Name.length);
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        ),
        builder: (builder) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return Padding(
              padding: EdgeInsets.only(top: 20, left: 15, right: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Text(
                        ChangeProfile,
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: Inter_bold,
                            color: BlackColor),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Container(
                        height: 52,
                        child: TextField(
                          onChanged: (value) {
                            Name = value;
                          },
                          controller: textEditingController,
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide(color: MainColor)),
                              hintText: HintName,
                              labelText: HintName,
                              prefixIcon: Icon(Icons.person_outlined,
                                  color: GreyColor)),
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: Segoe_ui_semibold,
                            color: GreyColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Container(
                        height: 52,
                        child: TextField(
                          onChanged: (value) {
                            Name = value;
                          },
                          enabled: false,
                          keyboardType: TextInputType.number,
                          controller: TextEditingController()
                            ..text = User_Mobile,
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide(color: MainColor)),
                              hintText: MobileNumber,
                              labelText: MobileNumber,
                              prefixIcon:
                                  Icon(Icons.phone_android, color: GreyColor)),
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: Segoe_ui_semibold,
                            color: GreyColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: ProgressButton(
                      child: Text(
                        SaveDetails,
                        style: TextStyle(
                          color: WhiteColor,
                          fontFamily: Segoe_ui_semibold,
                          height: 1.1,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          buttonState = ButtonState.inProgress;
                        });
                        SaveUserProfile(Name);
                      },
                      buttonState: buttonState,
                      backgroundColor: MainColor,
                      progressColor: WhiteColor,
                      border_radius: Full_Rounded_Button_Corner,
                    ),
                  )
                ],
              ),
            );
          });
        });
  }

  Future<void> SaveUserProfile(String namee) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var header = <String, dynamic>{};
    String? token = prefs.getString(TOKEN);
    header[Authorization] = Bearer + token.toString();
    print("HEADERSSS${header.toString()}");
    var ApiCalling = GetApiInstanceWithHeaders(header);
    var Params = <String, dynamic>{};
    Params[mobile] = User_Mobile;
    Params[Email_param] = "";
    Params[name] = namee;
    Response response;
    response = await ApiCalling.post(USER_UPDATE, data: Params);
    print("SaveUserProfileRESPONSE${response.data.toString()}");
    ShowToast("User updated successfully", context);

    buttonState = ButtonState.normal;
    setState(() {
      User_Name = namee;
      prefs.setString(USER_NAME, namee);
      Navigator.pop(context);
    });
  }

  LogoutDialogShow(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("No", style: TextStyle(color: MainColor)),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        "Yes",
        style: TextStyle(color: MainColor),
      ),
      onPressed: () {
        ClearLocalData();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Logout"),
      content: Text("Are you sure,want to logout?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void ClearLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.of(context, rootNavigator: true).pop('dialog');
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MyApp()),
        (Route<dynamic> route) => false);
  }
}
