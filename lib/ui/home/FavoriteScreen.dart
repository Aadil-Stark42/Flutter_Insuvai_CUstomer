import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:insuvaicustomer/apiservice/EndPoints.dart';
import 'package:insuvaicustomer/res/ResColor.dart';
import 'package:insuvaicustomer/uicomponents/MyProgressBar.dart';
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
import '../../models/WishListDataModel.dart';
import '../../res/ResString.dart';
import '../../uicomponents/progress_button.dart';
import '../../utils/Utils.dart';
import '../shop/ShopDetailsScreen.dart';
import 'homesubscreen/CartSubScreen.dart';
import 'homesubscreen/CategorySearchScreen.dart';
import 'homesubscreen/HomeSubScreen.dart';
import 'homesubscreen/ProfileScreen.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  FavoriteScreenState createState() => FavoriteScreenState();
}

class FavoriteScreenState extends State<FavoriteScreen> {
  WishListDataModel wishListDataModel = WishListDataModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetWishList();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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
                  Favorite,
                  style: TextStyle(
                      fontSize: 16, fontFamily: Inter_bold, color: BlackColor),
                ),
              ],
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([FevoriteListDataView()]))
        ],
      ),
    );
  }

  Widget FevoriteListDataView() {
    Size size = MediaQuery.of(context).size;
    if (wishListDataModel.shops != null) {
      if (wishListDataModel.shops!.isNotEmpty) {
        return Container(
          padding: EdgeInsets.only(top: 20),
          child: AnimationLimiter(
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: wishListDataModel.shops!.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: Duration(milliseconds: AnimationTime),
                  child: SlideAnimation(
                    horizontalOffset: 50.0,
                    child: FadeInAnimation(
                        child: Padding(
                      padding:
                          const EdgeInsets.only(top: 10, left: 15, right: 10),
                      child: GestureDetector(
                        onTap: () {},
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10.0)),
                              child: Stack(
                                children: [
                                  SizedBox(
                                    height: 90,
                                    width: 90,
                                    child: FadeInImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                        wishListDataModel
                                            .shops![index].shopImage
                                            .toString(),
                                      ),
                                      placeholder: AssetImage(
                                          "${IMAGE_PATH}ic_logo.png"),
                                    ),
                                  ),
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
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: Text(
                                            wishListDataModel
                                                .shops![index].shopName
                                                .toString(),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontFamily: Inter_bold,
                                                color: BlackColor),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          ManageWishList(
                                              wishListDataModel
                                                  .shops![index].shopId
                                                  .toString(),
                                              index);
                                        },
                                        child: Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 7, 0),
                                          child: Icon(
                                            wishListDataModel.shops![index]
                                                        .isWishlist ==
                                                    true
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: MainColor,
                                            size: 22,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        wishListDataModel.shops![index].shopArea
                                                .toString() +
                                            " " +
                                            wishListDataModel
                                                .shops![index].distance
                                                .toString(),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontFamily: Poppinsmedium,
                                            color: GreyColor),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Icon(
                                        Icons.watch_later_outlined,
                                        size: 15,
                                        color: GreyColor,
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Text(
                                        wishListDataModel.shops![index].time
                                            .toString(),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontFamily: Poppinsmedium,
                                            color: GreyColor),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    "Approx price for two person : " +
                                        wishListDataModel.shops![index].price
                                            .toString(),
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontFamily: Poppinsmedium,
                                        color: GreyColor),
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Row(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            wishListDataModel
                                                .shops![index].rating
                                                .toString(),
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: true,
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontFamily: Segoe_ui_semibold,
                                                color: MainColor),
                                          ),
                                          const SizedBox(
                                            width: 2,
                                          ),
                                          Icon(
                                            Icons.star_rounded,
                                            size: 15,
                                            color: MainColor,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Container(
                                        width: 1,
                                        height: 12,
                                        color: GreyColor2,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        wishListDataModel
                                            .shops![index].ratingCount
                                            .toString(),
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: true,
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontFamily: Segoe_ui_semibold,
                                            color: GreyColor2),
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        "Reviews",
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: true,
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontFamily: Segoe_ui_semibold,
                                            color: GreyColor2),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )),
                  ),
                );
              },
            ),
          ),
        );
      } else {
        return Container();
      }
    } else {
      return Padding(
        padding: EdgeInsets.only(top: size.height / 2.7),
        child: MyProgressBar(),
      );
    }
  }

  Future<Response> GetWishList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var header = <String, dynamic>{};
    String? token = prefs.getString(TOKEN);
    header[Authorization] = Bearer + token.toString();
    print("HEADERSSS${header.toString()}");

    var Params = <String, dynamic>{};
    Params[address_id] = prefs.getString(SELECTED_ADDRESS_ID);
    Params[latitude] = prefs.getString(SELECTED_LATITUDE);
    Params[longitude] = prefs.getString(SELECTED_LONGITUDE);

    print("GetShopListParamsParamsParams${Params.toString()}");
    var ApiCalling = GetApiInstanceWithHeaders(header);
    Response response;
    response = await ApiCalling.post(WISHLISTS, data: Params);
    print("responseresponseresponse${response.data.toString()}");
    setState(() {
      wishListDataModel = WishListDataModel.fromJson(response.data);
    });
    if (response.data[status] != true) {
      ShowToast(response.data[message].toString(), context);
    }
    return response;
  }

  Future<void> ManageWishList(String shopid, int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var header = <String, dynamic>{};
    String? token = prefs.getString(TOKEN);
    header[Authorization] = Bearer + token.toString();
    print("HEADERSSS${header.toString()}");

    var Params = <String, dynamic>{};
    Params[shop_id] = shopid;

    print("ParamsParamsParams${Params.toString()}");
    var ApiCalling = GetApiInstanceWithHeaders(header);
    Response response;
    response = await ApiCalling.post(MANAGE_WISHLIST, data: Params);
    setState(() {
      wishListDataModel.shops!.removeAt(index);
      print("responseresponseresponse${response.data.toString()}");
      if (response.data[status] != true) {
        ShowToast(response.data[message].toString(), context);
      }
    });
  }
}
