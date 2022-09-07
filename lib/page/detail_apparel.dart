import 'dart:convert';

import 'package:ecommerce_app/config/api.dart';
import 'package:ecommerce_app/controller/c_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import '../config/asset.dart';
import '../controller/c_user.dart';
import '../model/apparel.dart';

class DetaiApparel extends StatefulWidget {
  final Apparel? apparel;
  DetaiApparel({this.apparel});

  @override
  State<DetaiApparel> createState() => _DetaiApparelState();
}

class _DetaiApparelState extends State<DetaiApparel> {
  final _CDetailApparel = Get.put(CDetailApparel());

  final _CUser = Get.put(CUser());

  void checkWishlist() async {
    try {
      var response = await http.post(Uri.parse(Api.checkWishlist), body: {
        'id_user': _CUser.user.idUser.toString(),
        'id_apparel': widget.apparel!.idApparel.toString()
      });

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        _CDetailApparel.setIsWishlist(responseBody['exist']);
      }
    } catch (e) {
      print(e);
    }
  }

  void addWishlist() async {
    try {
      var response = await http.post(Uri.parse(Api.addWishlist), body: {
        'id_user': _CUser.user.idUser.toString(),
        'id_apparel': widget.apparel!.idApparel.toString()
      });

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['success']) {
          checkWishlist();
        }
      }
    } catch (e) {
      print(e);
    }
  }

  void deleteWishlist() async {
    try {
      var response = await http.post(Uri.parse(Api.deleteWishlist), body: {
        'id_user': _CUser.user.idUser.toString(),
        'id_apparel': widget.apparel!.idApparel.toString()
      });

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['success']) {
          checkWishlist();
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    checkWishlist();
    _CDetailApparel.setQuantity(1);
    _CDetailApparel.setSize(0);
    _CDetailApparel.setColor(0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        FadeInImage(
          height: MediaQuery.of(context).size.height * 0.4,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
          placeholder: AssetImage(Asset.imageBox),
          image: NetworkImage(widget.apparel!.image),
          imageErrorBuilder: (context, error, stackTrace) {
            return Center(
              child: Icon(Icons.broken_image),
            );
          },
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: buildInfo(),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top,
          left: 0,
          right: 0,
          child: Container(
            // color: Colors.black.withOpacity(0.1),
            child: Row(
              children: [
                IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Asset.colorPrimary,
                    )),
                Spacer(),
                Obx(
                  () => IconButton(
                      onPressed: () {
                        if (_CDetailApparel.isWishlist) {
                          deleteWishlist();
                        } else {
                          addWishlist();
                        }
                        // _CDetailApparel.setIsWishlist(
                        //     !_CDetailApparel.isWishlist);
                      },
                      icon: Icon(
                          _CDetailApparel.isWishlist
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          color: Asset.colorPrimary)),
                ),
                IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.shopping_cart, color: Asset.colorPrimary)),
              ],
            ),
          ),
        )
      ]),
    );
  }

  Widget buildInfo() {
    return Container(
      height: MediaQuery.of(Get.context!).size.height * 0.6,
      width: MediaQuery.of(Get.context!).size.width,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, -3),
              blurRadius: 6,
              color: Colors.black12,
            )
          ]),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 16,
            ),
            Center(
              child: Container(
                height: 5,
                width: 120,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(30)),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              widget.apparel!.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        RatingBar.builder(
                          initialRating: widget.apparel!.rating,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {},
                          ignoreGestures: true,
                          itemSize: 20,
                          unratedColor: Colors.grey,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text('(${widget.apparel!.rating})')
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      widget.apparel!.tags!.join(', '),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      'Rp ${widget.apparel!.price}',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 20,
                        color: Asset.colorPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )),
                Obx((() => Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {
                              _CDetailApparel.setQuantity(
                                  _CDetailApparel.quantity + 1);
                            },
                            icon: Icon(Icons.add_circle_outline_rounded)),
                        Text(
                          _CDetailApparel.quantity.toString(),
                          style: TextStyle(
                            fontSize: 12,
                            color: Asset.colorPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              if (_CDetailApparel.quantity - 1 >= 1) {
                                _CDetailApparel.setQuantity(
                                    _CDetailApparel.quantity - 1);
                              }
                            },
                            icon: Icon(Icons.remove_circle_outline_outlined))
                      ],
                    ))),
              ],
            ),
            Text(
              'Size',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Wrap(
              spacing: 8,
              children: List.generate(widget.apparel!.sizes.length, (index) {
                return Obx(() => GestureDetector(
                      onTap: () => _CDetailApparel.setSize(index),
                      child: Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              width: 2,
                              color: _CDetailApparel.size == index
                                  ? Asset.colorPrimary
                                  : Colors.grey),
                          color: _CDetailApparel.size == index
                              ? Asset.colorAccent
                              : Colors.white,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          widget.apparel!.sizes[index],
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ));
              }),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Color',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Wrap(
              spacing: 8,
              children: List.generate(widget.apparel!.colors.length, (index) {
                return Obx(() => GestureDetector(
                      onTap: () => _CDetailApparel.setColor(index),
                      child: FittedBox(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              width: 2,
                              color: _CDetailApparel.color == index
                                  ? Asset.colorPrimary
                                  : Colors.grey,
                            ),
                            color: _CDetailApparel.color == index
                                ? Asset.colorAccent
                                : Colors.white,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            widget.apparel!.colors[index],
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ));
              }),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Description',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              widget.apparel!.description!,
            ),
            SizedBox(
              height: 30,
            ),
            Material(
              elevation: 2,
              color: Asset.colorPrimary,
              borderRadius: BorderRadius.circular(30),
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  child: Text(
                    'ADD TO CART',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}
