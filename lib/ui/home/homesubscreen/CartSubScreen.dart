import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:insuvaicustomer/apiservice/EndPoints.dart';
import 'package:insuvaicustomer/models/CartDataModel.dart';
import 'package:insuvaicustomer/res/ResColor.dart';
import 'package:insuvaicustomer/ui/order/OrderSummaryScreen.dart';
import 'package:insuvaicustomer/utils/LocalStorageName.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/DashBoardDataModell.dart';
import '../../../animationlist/src/animation_configuration.dart';
import '../../../animationlist/src/animation_limiter.dart';
import '../../../animationlist/src/fade_in_animation.dart';
import '../../../animationlist/src/scale_animation.dart';
import '../../../animationlist/src/slide_animation.dart';
import '../../../apiservice/ApiService.dart';
import '../../../apiservice/EndPoints.dart';
import '../../../imageslider/carousel_slider.dart';
import '../../../res/ResString.dart';
import '../../../uicomponents/MyProgressBar.dart';
import '../../../uicomponents/progress_button.dart';
import '../../../uicomponents/rounded_input_field.dart';
import '../../../utils/Utils.dart';
import '../../address/SelectAddressScreen.dart';
import '../HomeScreen.dart';

class CartSubScreen extends StatefulWidget {
  final bool IstitleShow;
  final bool IsComeFromHome;
  final VoidCallback ContinueShopingClick;

  CartSubScreen(
      this.IstitleShow, this.IsComeFromHome, this.ContinueShopingClick);

  @override
  CartSubScreenState createState() => CartSubScreenState();
}

class CartSubScreenState extends State<CartSubScreen> {
  bool DataVisible = false;
  CartDataModel cartDataModel = CartDataModel();
  ButtonState buttonState = ButtonState.normal;
  String Instrucvalue = "";
  String CouponValue = "";

  @override
  void initState() {
    super.initState();
    GetCartList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WhiteColor,
      body: CartMainview(),
    );
  }

  Future<void> GetCartList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var header = <String, dynamic>{};
    String? token = prefs.getString(TOKEN);
    header[Authorization] = Bearer + token.toString();
    print("HEADERSSS${header.toString()}");

    var Params = <String, dynamic>{};
    Params[device_id] = prefs.getString(DEVICE_ID);
    Params[address_id] = prefs.getString(SELECTED_ADDRESS_ID);

    print("ParamsParamsParams${Params.toString()}");
    var ApiCalling = GetApiInstanceWithHeaders(header);

    Response response;
    response = await ApiCalling.post(CARTDATA, data: Params);

    setState(() {
      DataVisible = true;
      cartDataModel = CartDataModel.fromJson(response.data);
      if (response.data[status] != true) {
        cartDataModel.status = false;
        ShowToast(response.data[message].toString(), context);
      }
      if (cartDataModel.products == null || cartDataModel.products!.isEmpty) {
        cartDataModel.status = false;
      }
      print("responseresponseresponse${response.toString().toString()}");
      print("cartDataModel.products!.length${cartDataModel.status}");
    });
  }

  Widget CartProductList() {
    return ListView.builder(
        itemCount: cartDataModel.products!.length,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
              padding: EdgeInsets.only(top: 20),
              child: Row(
                children: [
                  Expanded(
                      child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 15,
                        height: 15,
                        child: Image.asset(
                          cartDataModel.products![index].variety == 1
                              ? "${IMAGE_PATH}veg.png"
                              : "${IMAGE_PATH}nonveg.png",
                        ),
                      ),
                      SizedBox(width: 10),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cartDataModel.products![index].productName
                                  .toString(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: Segoe_ui_semibold,
                                fontSize: 14,
                                height: 1.0,
                                color: GreyColor,
                              ),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Text(
                              cartDataModel.products![index].size.toString(),
                              style: TextStyle(
                                fontFamily: Segoe_ui_semibold,
                                fontSize: 11,
                                height: 1.0,
                                color: GreyColor,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )),

                  Row(
                    children: [
                      Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(color: MainColor, width: 1),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 3, top: 5, bottom: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                InkWell(
                                  splashColor: GreyColor,
                                  onTap: () {
                                    AddOrRemoveProduct(
                                        cartDataModel
                                            .products![index].cartProductId
                                            .toString(),
                                        "-1");
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: const Icon(
                                      Icons.remove_rounded,
                                      color: MainColor,
                                      size: 20,
                                    ),
                                    width: 30,
                                  ),
                                ),
                                Text(
                                  cartDataModel.products![index].quantity
                                      .toString(),
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: Poppinsmedium,
                                      color: BlackColor),
                                ),
                                InkWell(
                                  splashColor: GreyColor2,
                                  onTap: () {
                                    AddOrRemoveProduct(
                                        cartDataModel
                                            .products![index].cartProductId
                                            .toString(),
                                        "1");
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.add_rounded,
                                      color: MainColor,
                                      size: 20,
                                    ),
                                    width: 30,
                                  ),
                                ),
                              ],
                            ),
                          )),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "₹${cartDataModel.products![index].amount.toString()}",
                        style: TextStyle(
                            fontSize: 13,
                            fontFamily: Segoe_ui_semibold,
                            color: GreyColor),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  )
                  //Farzi
                ],
              ));
        });
  }

  Widget BillDetailsView() {
    return Padding(
      padding: EdgeInsets.only(left: 0, right: 0, top: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            BillDetails,
            style: TextStyle(
              fontFamily: Inter_bold,
              fontSize: 15,
              height: 1.0,
              color: BlackColor,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                SubTotal,
                style: TextStyle(
                  fontFamily: Poppinsmedium,
                  fontSize: 12,
                  height: 1.0,
                  color: GreyColor,
                ),
              ),
              Text(
                "₹${cartDataModel.subTotal}",
                style: TextStyle(
                  fontFamily: Poppinsmedium,
                  fontSize: 13,
                  height: 1.0,
                  color: GreyColor,
                ),
              )
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                CouponDiscount,
                style: TextStyle(
                  fontFamily: Poppinsmedium,
                  fontSize: 12,
                  height: 1.0,
                  color: GreyColor,
                ),
              ),
              Text(
                "₹${cartDataModel.couponDiscount}",
                style: TextStyle(
                  fontFamily: Poppinsmedium,
                  fontSize: 13,
                  height: 1.0,
                  color: GreyColor,
                ),
              )
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                GST + " ${cartDataModel.gstPer}%",
                style: TextStyle(
                  fontFamily: Poppinsmedium,
                  fontSize: 12,
                  height: 1.0,
                  color: GreyColor,
                ),
              ),
              Text(
                "₹${cartDataModel.gstPrice}",
                style: TextStyle(
                  fontFamily: Poppinsmedium,
                  fontSize: 13,
                  height: 1.0,
                  color: GreyColor,
                ),
              )
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                PackingCharges,
                style: TextStyle(
                  fontFamily: Poppinsmedium,
                  fontSize: 12,
                  height: 1.0,
                  color: GreyColor,
                ),
              ),
              Text(
                "₹${cartDataModel.packingCharge}",
                style: TextStyle(
                  fontFamily: Poppinsmedium,
                  fontSize: 13,
                  height: 1.0,
                  color: GreyColor,
                ),
              )
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                TotalFoodCost,
                style: TextStyle(
                  fontFamily: Segoe_ui_bold,
                  fontSize: 18,
                  height: 1.0,
                  color: BlackColor,
                ),
              ),
              Text(
                "₹${cartDataModel.total}",
                style: TextStyle(
                  fontFamily: Segoe_ui_bold,
                  fontSize: 18,
                  height: 1.0,
                  color: BlackColor,
                ),
              )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            DeliveryChargesmaybeApplicable,
            style: TextStyle(
              fontFamily: Poppinsmedium,
              fontSize: 10,
              height: 1.0,
              color: GreyColor,
            ),
          ),
          SizedBox(
            height: 45,
          ),
          ProgressButton(
            child: Text(
              CONTINUE,
              style: TextStyle(
                color: WhiteColor,
                fontFamily: Segoe_ui_semibold,
                height: 1.1,
              ),
            ),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                    builder: (context) => SelectAddressScreen(
                        true, cartDataModel.gstPer.toString(), true)),
              );
            },
            buttonState: buttonState,
            backgroundColor: MainColor,
            progressColor: WhiteColor,
            border_radius: Rounded_Button_Corner,
          ),
          SizedBox(
            height: 35,
          ),
        ],
      ),
    );
  }

  Future<void> AddOrRemoveProduct(String cartProductId, String qnty) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var header = <String, dynamic>{};
    String? token = prefs.getString(TOKEN);
    header[Authorization] = Bearer + token.toString();
    print("HEADERSSS${header.toString()}");
    var Params = <String, dynamic>{};
    Params[cart_product_id] = cartProductId;
    Params[quantity] = qnty;
    print("ParamsParamsParams${Params.toString()}");
    var ApiCalling = GetApiInstanceWithHeaders(header);
    Response response;
    response = await ApiCalling.post(MANAGECARTPRODUCT, data: Params);
    ShowToast(cartDataModel.message.toString(), context);
    GetCartList();
    print("responseresponseresponse${response.data.toString()}");
  }

  Widget EmptyDataView() {
    return Stack(
      children: [
        Positioned.fill(
          top: 100,
          child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: [
                    Image.asset(
                      IMAGE_PATH + "ic_emptycart_man.png",
                      color: MainColor,
                      height: 300,
                      width: 300,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Opps!",
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: Segoe_ui_bold,
                          color: GreyColor),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      YourCartEmpty,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: Segoe_ui_semibold,
                          color: GreyColor),
                    )
                  ],
                ),
              )),
        ),
        Positioned(
            bottom: 30,
            child: Container(
              height: 50,
              width: 300,
              margin: EdgeInsets.only(left: 45),
              child: ProgressButton(
                child: Text(
                  CONTINUESHOPPING,
                  style: TextStyle(
                    color: WhiteColor,
                    fontFamily: Segoe_ui_semibold,
                    height: 1.1,
                  ),
                ),
                onPressed: () {
                  widget.ContinueShopingClick();
                  if (widget.IsComeFromHome) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                        (Route<dynamic> route) => false);
                  } else {
                    Navigator.pop(context);
                  }
                },
                buttonState: buttonState,
                backgroundColor: MainColor,
                progressColor: WhiteColor,
                border_radius: Rounded_Button_Corner,
              ),
            ))
      ],
    );
  }

  Widget CartMainview() {
    print("cartDataModel.status${cartDataModel.status}");
    if (cartDataModel.status != null) {
      if (cartDataModel.status != false) {
        return CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: false,
              backgroundColor: WhiteColor,
              floating: true,
              snap: false,
              flexibleSpace: FlexibleSpaceBar(),
              elevation: 2,
              forceElevated: true,
              centerTitle: false,
              automaticallyImplyLeading: false,
              leading: null,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  if (widget.IstitleShow)
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Image.asset(IMAGE_PATH + "back_arrow.png",
                          height: 25, width: 25),
                    )
                  else
                    SizedBox(),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    Cart,
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: Inter_bold,
                        color: BlackColor),
                  ),
                ],
              ),
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10.0)),
                          child: Stack(
                            children: [
                              Image.network(
                                cartDataModel.shopDetails!.shopImage.toString(),
                                fit: BoxFit.cover,
                                height: 80,
                                width: 80,
                              ),
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  bottomRight: Radius.circular(5),
                                  topRight: Radius.circular(5),
                                ),
                                child: Container(
                                  color: MainColor,
                                  child: Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Text(
                                      cartDataModel.shopDetails!.isOpened ==
                                              true
                                          ? "Open"
                                          : "Close",
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: Segoeui,
                                          color: WhiteColor),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              cartDataModel.shopDetails!.shopName.toString(),
                              softWrap: true,
                              style: TextStyle(
                                  fontSize: 17,
                                  fontFamily: Inter_bold,
                                  color: BlackColor),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              cartDataModel.shopDetails!.shopStreet.toString(),
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: Poppinsmedium,
                                  color: GreyColor),
                            )
                          ],
                        ))
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CartProductList(),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Container(
                          padding: const EdgeInsets.all(3.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: GreyColor2),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                  child: RoundedInputField(
                                hintText: instructions,
                                onChanged: (value) {
                                  Instrucvalue = value.toString();
                                },
                                inputType: TextInputType.name,
                                icon: Icons.note_alt_outlined,
                                Corner_radius: 0,
                                horizontal_margin: 0,
                                elevations: 0,
                              )),
                              Container(
                                width: 80,
                                height: 45,
                                child: ProgressButton(
                                  child: Text(
                                    ADD,
                                    style: TextStyle(
                                      color: WhiteColor,
                                      fontFamily: Segoe_ui_semibold,
                                      height: 1.1,
                                    ),
                                  ),
                                  onPressed: () {
                                    if (Instrucvalue.isNotEmpty) {
                                      AddInstruction();
                                    } else {
                                      ShowToast(
                                          "Please enter instruction", context);
                                    }
                                  },
                                  buttonState: buttonState,
                                  backgroundColor: MainColor,
                                  progressColor: WhiteColor,
                                  border_radius: Rounded_Button_Corner,
                                ),
                              ),
                              SizedBox(
                                width: 3,
                              )
                            ],
                          ),
                        )),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Container(
                          padding: const EdgeInsets.all(3.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: GreyColor2),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                  child: RoundedInputField(
                                hintText: CouponCode,
                                onChanged: (value) {
                                  CouponValue = value;
                                },
                                inputType: TextInputType.name,
                                icon: Icons.airplane_ticket_outlined,
                                Corner_radius: 0,
                                horizontal_margin: 0,
                                elevations: 0,
                              )),
                              Container(
                                width: 80,
                                height: 45,
                                child: ProgressButton(
                                  child: Text(
                                    APPLY,
                                    style: TextStyle(
                                      color: WhiteColor,
                                      fontFamily: Segoe_ui_semibold,
                                      height: 1.1,
                                    ),
                                  ),
                                  onPressed: () {
                                    if (CouponValue.isNotEmpty) {
                                      AddCouponCode();
                                    } else {
                                      ShowToast(
                                          "Please enter coupon code", context);
                                    }
                                  },
                                  buttonState: buttonState,
                                  backgroundColor: MainColor,
                                  progressColor: WhiteColor,
                                  border_radius: Rounded_Button_Corner,
                                ),
                              ),
                              SizedBox(
                                width: 3,
                              )
                            ],
                          ),
                        )),
                    BillDetailsView()
                  ],
                ),
              )
            ]))
          ],
        );
      } else {
        return EmptyDataView();
      }
    } else {
      return MyProgressBar();
    }
  }

  Future<void> AddInstruction() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var header = <String, dynamic>{};
    String? token = prefs.getString(TOKEN);
    header[Authorization] = Bearer + token.toString();
    print("HEADERSSS${header.toString()}");
    var Params = <String, dynamic>{};
    Params[cart_id] = cartDataModel.shopDetails!.cartId.toString();
    Params[instructions_param] = Instrucvalue;
    print("ParamsParamsParams${Params.toString()}");
    var ApiCalling = GetApiInstanceWithHeaders(header);
    Response response;
    response = await ApiCalling.post(ADD_INSTRUCTION, data: Params);
    ShowToast(response.data[message].toString(), context);
    print("responseresponseresponse${response.data.toString()}");
  }

  Future<void> AddCouponCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var header = <String, dynamic>{};
    String? token = prefs.getString(TOKEN);
    header[Authorization] = Bearer + token.toString();
    print("HEADERSSS${header.toString()}");
    var Params = <String, dynamic>{};
    Params[device_id] = cartDataModel.shopDetails!.cartId.toString();
    Params[coupon_code] = CouponValue;
    print("ParamsParamsParams${Params.toString()}");
    var ApiCalling = GetApiInstanceWithHeaders(header);
    Response response;
    response = await ApiCalling.post(APPLY_COUPON, data: Params);
    ShowToast(response.data[message].toString(), context);
    if (response.data[status]) {
      GetCartList();
    }
    print("responseresponseresponse${response.data.toString()}");
  }
}
