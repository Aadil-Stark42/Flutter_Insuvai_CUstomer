import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:insuvaicustomer/res/ResColor.dart';
import 'package:insuvaicustomer/utils/Utils.dart';

import '../../apiservice/ApiService.dart';
import '../../apiservice/EndPoints.dart';
import '../../models/CityDataModel.dart';
import '../../res/ResString.dart';

import '../../uicomponents/progress_button.dart';
import '../../uicomponents/rounded_input_field.dart';
import '../../utils/LowerCaseTextFormatter.dart';
import 'OtpScreen.dart';
import 'components/background.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyLoginUi(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyLoginUi extends StatefulWidget {
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<MyLoginUi> {
  String UserName = "", MobileNumber = "";
  ButtonState buttonState = ButtonState.normal;
  CityDataModel cityDataModel = CityDataModel();
  Citiess initcity = Citiess(
      id: 000, name: selectYourLocation, isActive: 000, createdDate: "115555");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCities();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Background(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                LOGIN,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: Inter_medium,
                    fontSize: 17),
              ),
              SizedBox(height: size.height * 0.06),
              Image.asset(
                "${IMAGE_PATH}step-one.png",
                height: size.height * 0.35,
              ),
              SizedBox(height: 50),
              RoundedInputField(
                  hintText: EnterNameHint,
                  onChanged: (value) {
                    UserName = value;
                  },
                  inputType: TextInputType.name,
                  icon: Icons.account_circle,
                  Corner_radius: Full_Rounded_Button_Corner,
                  horizontal_margin: 20,
                  elevations: 1,
                  formatter: LowerCaseTextFormatter()),
              SizedBox(height: 10),
              RoundedInputField(
                  hintText: EnterMobileHint,
                  onChanged: (value) {
                    MobileNumber = value;
                  },
                  inputType: TextInputType.number,
                  icon: Icons.phone,
                  Corner_radius: Full_Rounded_Button_Corner,
                  horizontal_margin: 20,
                  elevations: 1,
                  formatter: LowerCaseTextFormatter()),
              SizedBox(height: 10),
              Card(
                margin: EdgeInsets.all(1),
                elevation: 1,
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(Full_Rounded_Button_Corner)),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 0),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  width: size.width * 0.8,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: cityDataModel.cities != null
                            ? DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  // Initial Value
                                  value: initcity,
                                  // Array list of items
                                  icon: Container(),
                                  items: cityDataModel.cities!.citiess!
                                      .map((Citiess items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: Text(
                                        items.name.toString(),
                                        style: TextStyle(
                                            color: items.name.toString() ==
                                                    selectYourLocation
                                                ? GreyColor
                                                : BlackColor,
                                            height: 1.0,
                                            fontFamily: Segoe_ui_semibold,
                                            fontSize: 15),
                                      ),
                                    );
                                  }).toList(),
                                  // After selecting the desired option,it will
                                  // change button value to selected value
                                  onChanged: (Citiess? newValue) {
                                    setState(() {
                                      initcity = newValue!;
                                    });
                                  },
                                ),
                              )
                            : Container(
                                width: 0,
                                height: 0,
                              ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 30,
                        color: BlackColor,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: ProgressButton(
                  child: Text(
                    LOGIN,
                    style: TextStyle(
                      color: WhiteColor,
                      fontFamily: Segoe_ui_semibold,
                      height: 1.1,
                    ),
                  ),
                  onPressed: () {
                    LoginApiCalling();
                  },
                  buttonState: buttonState,
                  backgroundColor: MainColor,
                  progressColor: WhiteColor,
                  border_radius: Full_Rounded_Button_Corner,
                ),
              ),
              SizedBox(height: size.height * 0.03),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> LoginApiCalling() async {
    if (UserName.isEmpty) {
      ShowToast(EnterNameHint, context);
    } else if (MobileNumber.length != 10) {
      ShowToast(EnterValidmobile, context);
    } else if (initcity.id == 000) {
      ShowToast(selectYourLocation, context);
    } else {
      HideKeyBoard();
      setState(() {
        buttonState = ButtonState.inProgress;
      });
      var dio = GetApiInstance();
      Response response;
      response = await dio.post(LOGIN_API,
          data: {mobile: MobileNumber, name: UserName, city: initcity.id});
      print("response.data${response.data}");
      if (response.data[STATUS]) {
        Future.delayed(const Duration(milliseconds: 1000), () {
          setState(() {
            buttonState = ButtonState.normal;
          });
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (_) => OtpScreen(
                      mobileNumber: MobileNumber,
                      UserName: UserName,
                    )),
          );
        });
      }
    }
  }

  Future<Response> getCities() async {
    var ApiCalling = GetApiInstance();
    Response response;
    response = await ApiCalling.post(GET_CITIES);
    setState(() {
      cityDataModel = CityDataModel.fromJson(response.data);
      cityDataModel.cities!.citiess!.insert(0, initcity);
    });
    if (response.data[status] != true) {
      ShowToast(response.data[message].toString(), context);
    }
    return response;
  }
}
