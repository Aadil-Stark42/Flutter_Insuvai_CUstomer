import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:insuvaicustomer/apiservice/EndPoints.dart';
import 'package:insuvaicustomer/models/OrderDetailsDataModel.dart';
import 'package:insuvaicustomer/res/ResColor.dart';
import 'package:insuvaicustomer/ui/order/OrderConfirmationScreen.dart';
import 'package:insuvaicustomer/utils/LocalStorageName.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../apiservice/ApiService.dart';
import '../../../apiservice/EndPoints.dart';
import '../../../res/ResString.dart';
import '../../../uicomponents/MyProgressBar.dart';
import '../../models/OrderConfirmDataModel.dart';
import '../../models/OrderSummaryDataModel.dart';
import '../../uicomponents/RoundedBorderButton.dart';
import '../../uicomponents/progress_button.dart';
import '../../uicomponents/rounded_button.dart';
import '../../utils/Utils.dart';
import 'package:package_info_plus/package_info_plus.dart';

class OrderSummaryScreen extends StatefulWidget {
  final String GstPer, Temp_Address_id, Temp_address_name;

  OrderSummaryScreen(this.GstPer, this.Temp_Address_id, this.Temp_address_name);

  @override
  OrderSummaryScreenState createState() => OrderSummaryScreenState();
}

class OrderSummaryScreenState extends State<OrderSummaryScreen> {
  OrderSummaryDataModel _orderSummaryDataModel = OrderSummaryDataModel();
  bool IsCashOnDeliveryCLick = false;
  bool IsOnlineCLick = false;
  String Payment_Method = "";
  String razor_signature = "";
  String razor_payment_id = "";
  String razor_order_id = "";
  final Razorpay _razorpay = Razorpay();
  bool IsLoadingPayment = false;
  @override
  void initState() {
    super.initState();
    GetOrderSummaryDetails();
  }

  @override
  Widget build(BuildContext context) {
    _razorpay.clear();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    return Scaffold(
      backgroundColor: WhiteColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            pinned: false,
            backgroundColor: WhiteColor,
            floating: true,
            snap: false,
            flexibleSpace: FlexibleSpaceBar(),
            elevation: 2,
            forceElevated: true,
            centerTitle: false,
            leading: null,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Image.asset(IMAGE_PATH + "back_arrow.png",
                      height: 25, width: 25),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  OrderSummary,
                  style: TextStyle(
                      fontSize: 16, fontFamily: Inter_bold, color: BlackColor),
                ),
              ],
            ),
          ),
          SliverList(delegate: SliverChildListDelegate([OrderDetailsView()]))
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: RoundedButton(
        color: MainColor,
        text: IsLoadingPayment == true ? Loadinggg : ConfirmedOrder,
        corner_radius: Rounded_Button_Corner,
        press: () {
          if (Payment_Method.isNotEmpty) {
            if (!IsLoadingPayment) {
              setState(() {
                IsLoadingPayment = true;
              });
              if (Payment_Method == CashOnDelivery) {
                OrderConfirmation();
              } else {
                GetTokenForPayment();
              }
            }
          } else {
            ShowToast(Selectpaymentmethod, context);
          }
        },
      ),
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    _razorpay.clear();
    razor_signature = response.signature.toString();
    razor_payment_id = response.paymentId.toString();
    razor_order_id = response.orderId.toString();
    OrderConfirmation();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    print("response.code${response.code}");
    if (response.code == 2) {
      ShowToast(PaymentCancelled, context);
    } else {
      ShowToast(response.message.toString(), context);
    }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
  }

  Future<void> GetOrderSummaryDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var header = <String, dynamic>{};
    String? token = prefs.getString(TOKEN);
    header[Authorization] = Bearer + token.toString();
    print("HEADERSSS${header.toString()}");
    var Params = <String, dynamic>{};
    Params[address_id] =widget.Temp_Address_id;
    var ApiCalling = GetApiInstanceWithHeaders(header);
    Response response;
    response = await ApiCalling.post(ORDER_SUMMARY, data: Params);
    print("GetOrderSummaryDetailsRESPONSEE${response.data.toString()}");
    setState(() {
      _orderSummaryDataModel = OrderSummaryDataModel.fromJson(response.data);
    });
  }

  Future<void> OrderConfirmation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var header = <String, dynamic>{};
    String? token = prefs.getString(TOKEN);
    header[Authorization] = Bearer + token.toString();
    print("HEADERSSS${header.toString()}");
    var Params = <String, dynamic>{};
    Params[order_id] = _orderSummaryDataModel.orderDetails!.orderId.toString();
    if (Payment_Method == CashOnDelivery) {
      Params[payment_type] = "0";
    } else {
      Params[payment_type] = "1";
      Params[razorpay_signature] = razor_signature;
      Params[razorpay_payment_id] = razor_payment_id;
      Params[razorpay_order_id] = razor_order_id;
    }

    var ApiCalling = GetApiInstanceWithHeaders(header);
    Response response;
    response = await ApiCalling.post(ORDER_CONFIRM, data: Params);
    print("OrderConfirmationresponse${response.data.toString()}");
    setState(() {
      IsLoadingPayment = false;
    });
    ShowToast(response.data[message], context);
    if (response.data[status]) {
      OrderConfirmDataModel orderConfirmDataModel =
          OrderConfirmDataModel.fromJson(response.data);
      orderConfirmDataModel.priceDetails!.gstPrice =
          _orderSummaryDataModel.priceDetails!.gstPrice.toString();
      orderConfirmDataModel.priceDetails!.packingCharge =
          _orderSummaryDataModel.priceDetails!.packingCharge.toString();

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => OrderConfirmationScreen(
                  orderConfirmDataModel, widget.GstPer)),
          (Route<dynamic> route) => false);
    }
  }

  Widget OrderDetailsView() {
    Size size = MediaQuery.of(context).size;
    if (_orderSummaryDataModel.status != null) {
      return Padding(
        padding: EdgeInsets.only(bottom: 60, left: 10, right: 10, top: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  YourOrders,
                  style: TextStyle(
                      fontSize: 17, fontFamily: Inter_bold, color: BlackColor),
                ),
                SizedBox(
                  height: 15,
                ),
                ListView.builder(
                  padding: EdgeInsets.zero,
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _orderSummaryDataModel.items!.length,
                  itemBuilder: (context, index) {
                    final itemdata = _orderSummaryDataModel.items![index];
                    return Padding(
                      padding: const EdgeInsets.only(top: 6),
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
                                  itemdata.variety == 1
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
                                      itemdata.productName.toString() +
                                          " x " +
                                          itemdata.quantity.toString(),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: Segoe_ui_semibold,
                                        fontSize: 14,
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
                              Text(
                                "₹${itemdata.amount.toString()}",
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
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  OrderDetailss,
                  style: TextStyle(
                      fontSize: 17, fontFamily: Inter_bold, color: BlackColor),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        OrderConfirmed,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: Segoe_ui_semibold,
                            color: BlackColor2),
                      ),
                      SizedBox(
                        height: 1,
                      ),
                      Text(
                        _orderSummaryDataModel.orderDetails!.orderNumber
                            .toString(),
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: Segoe_ui_semibold,
                            color: GreyColor),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        Address,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: Segoe_ui_semibold,
                            color: BlackColor2),
                      ),
                      SizedBox(
                        height: 1,
                      ),
                      Text(
                        widget.Temp_address_name,
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: Segoe_ui_semibold,
                            color: GreyColor),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        DeliveryWithin,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: Segoe_ui_semibold,
                            color: BlackColor2),
                      ),
                      SizedBox(
                        height: 1,
                      ),
                      Text(
                        _orderSummaryDataModel.orderDetails!.isScheduled == 1
                            ? _orderSummaryDataModel.orderDetails!.estimatedTime
                                    .toString() +
                                " Min"
                            : EstimateTime,
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: Segoe_ui_semibold,
                            color: GreyColor),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Text(
                  Payment,
                  style: TextStyle(
                      fontSize: 17, fontFamily: Inter_bold, color: BlackColor),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                        child: RoundedBorderButton(
                      txt: CashOnDelivery,
                      txtSize: 13,
                      CornerReduis: 7,
                      BorderWidth: 0.8,
                      BackgroundColor: IsCashOnDeliveryCLick == true
                          ? MainColor
                          : WhiteColor,
                      ForgroundColor: IsCashOnDeliveryCLick == true
                          ? WhiteColor
                          : MainColor,
                      PaddingLeft: 15,
                      PaddingRight: 15,
                      PaddingTop: 15,
                      PaddingBottom: 15,
                      press: () {
                        Payment_Method = CashOnDelivery;
                        setState(() {
                          IsCashOnDeliveryCLick = true;
                          IsOnlineCLick = false;
                        });
                      },
                    )),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                        child: RoundedBorderButton(
                      txt: OnlinePayment,
                      txtSize: 13,
                      CornerReduis: 7,
                      BorderWidth: 0.8,
                      BackgroundColor:
                          IsOnlineCLick == true ? MainColor : WhiteColor,
                      ForgroundColor:
                          IsOnlineCLick == true ? WhiteColor : MainColor,
                      PaddingLeft: 15,
                      PaddingRight: 15,
                      PaddingTop: 15,
                      PaddingBottom: 15,
                      press: () {
                        Payment_Method = OnlinePayment;
                        setState(() {
                          IsCashOnDeliveryCLick = false;
                          IsOnlineCLick = true;
                        });
                      },
                    ))
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          TotalFoodCost,
                          style: TextStyle(
                            fontFamily: Poppinsmedium,
                            fontSize: 12,
                            height: 1.0,
                            color: GreyColor,
                          ),
                        ),
                        Text(
                          "₹${_orderSummaryDataModel.priceDetails!.subTotal}",
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
                          DeliveryChargesTag,
                          style: TextStyle(
                            fontFamily: Poppinsmedium,
                            fontSize: 12,
                            height: 1.0,
                            color: GreyColor,
                          ),
                        ),
                        Text(
                          "₹${_orderSummaryDataModel.priceDetails!.deliveryCharge}",
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
                          "GST " + widget.GstPer + "%",
                          style: TextStyle(
                            fontFamily: Poppinsmedium,
                            fontSize: 12,
                            height: 1.0,
                            color: GreyColor,
                          ),
                        ),
                        Text(
                          "₹${_orderSummaryDataModel.priceDetails!.gstPrice}",
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
                          "₹${_orderSummaryDataModel.priceDetails!.packingCharge}",
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
                          "₹${_orderSummaryDataModel.priceDetails!.couponDiscount}",
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
                          GrandTotal,
                          style: TextStyle(
                            fontFamily: Segoe_ui_bold,
                            fontSize: 18,
                            height: 1.0,
                            color: BlackColor,
                          ),
                        ),
                        Text(
                          "₹${_orderSummaryDataModel.priceDetails!.total}",
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
                      Inclusivecharges,
                      style: TextStyle(
                        fontFamily: Poppinsmedium,
                        fontSize: 10,
                        height: 1.0,
                        color: GreyColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            )
          ],
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(top: size.height / 2.7),
        child: MyProgressBar(),
      );
    }
  }

  Future<void> OnlinePaymentStart(String api_key, String Res_Order_Id) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    var RetryOPtion = {
      'enabled': true,
      'max_count': 10,
    };
    var options = {
      'key': api_key,
      'amount': _orderSummaryDataModel.priceDetails!.total.toString(),
      'name': packageInfo.appName,
      'order_id': Res_Order_Id,
      'theme.color': '#41B649FF',
      'currency': 'INR',
      'image': 'https://s3.amazonaws.com/rzp-mobile/images/rzp.png',
      'retry': RetryOPtion,
    };
    _razorpay.open(options);
  }

  Future<void> GetTokenForPayment() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var header = <String, dynamic>{};
    String? token = prefs.getString(TOKEN);
    header[Authorization] = Bearer + token.toString();
    print("HEADERSSS${header.toString()}");
    var Params = <String, dynamic>{};
    Params[order_id] = _orderSummaryDataModel.orderDetails!.orderId.toString();
    var ApiCalling = GetApiInstanceWithHeaders(header);
    Response response;
    response = await ApiCalling.post(PAYMENT_INITIATE, data: Params);
    print("GetTokenForPaymentRESPONSEE${response.data.toString()}");
    setState(() {
      IsLoadingPayment = false;
    });
    if (response.data[status]) {
      OnlinePaymentStart(response.data[RAZOR_API_KEY].toString(),
          response.data[order_id].toString());
    } else {
      ShowToast(response.data[message], context);
    }
  }
}
