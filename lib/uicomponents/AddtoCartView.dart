library progress_button;

import 'package:flutter/material.dart';
import 'package:insuvaicustomer/res/ResColor.dart';

import '../res/ResString.dart';
import '../ui/home/homesubscreen/CartSubScreen.dart';

class AddtoCartView extends StatefulWidget {
  final bool IsBottomCartShow;
  final VoidCallback ContinueShopingClick;
  AddtoCartView(this.IsBottomCartShow, this.ContinueShopingClick);

  @override
  _AddtoCartViewState createState() => _AddtoCartViewState();
}

class _AddtoCartViewState extends State<AddtoCartView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BottomView();
  }

  Widget BottomView() {
    if (widget.IsBottomCartShow) {
      return Container(
        color: Transperent,
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: Container(
              color: MainColor,
              padding:
                  EdgeInsets.only(left: 20, right: 20, top: 13, bottom: 13),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AddedtoCart,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: Segoe_ui_bold,
                        color: WhiteColor),
                  ),
                  InkWell(
                    onTap: () {
                      print(
                          "CartSubScreenStateCartSubScreenStateCartSubScreenState");
                      Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                            builder: (context) =>
                                CartSubScreen(true, false, () {
                                  widget.ContinueShopingClick();
                                })),
                      );
                    },
                    child: Row(
                      children: [
                        Text(
                          Viewcart,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: Segoe_ui_semibold,
                              color: WhiteColor),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 18,
                          color: WhiteColor,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return SizedBox();
    }
  }
}
