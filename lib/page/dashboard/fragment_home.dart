import 'dart:convert';

import 'package:ecommerce_app/config/asset.dart';
import 'package:ecommerce_app/page/detail_apparel.dart';
import 'package:ecommerce_app/page/search_apparel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../config/api.dart';
import '../../model/apparel.dart';

class FragmentHome extends StatelessWidget {
  var _controllerSearch = TextEditingController();

  Future<List<Apparel>> getPopular() async {
    List<Apparel> listApparelPopular = [];
    try {
      var response = await http.get(Uri.parse(Api.getPopularApparel));
      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        if (responseBody['success']) {
          (responseBody['data'] as List).forEach((element) {
            listApparelPopular.add(Apparel.fromJson(element));
          });
        }
      }
    } catch (e) {
      print(e);
    }
    return listApparelPopular;
  }

  Future<List<Apparel>> getAll() async {
    List<Apparel> listApparelPopular = [];
    try {
      var response = await http.get(Uri.parse(Api.getAllApparel));
      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        if (responseBody['success']) {
          (responseBody['data'] as List).forEach((element) {
            listApparelPopular.add(Apparel.fromJson(element));
          });
        }
      }
    } catch (e) {
      print(e);
    }
    return listApparelPopular;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 8, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Find Your Style',
                  style: TextStyle(
                      color: Asset.colorTextTile,
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                ),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.shopping_cart,
                      color: Asset.colorTextTile,
                    )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Get The Best of The Best Shoes',
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
            ),
          ),
          SizedBox(
            height: 24,
          ),
          buildSearch(),
          SizedBox(
            height: 24,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Popular',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Asset.colorTextTile),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          buildPopular(),
          SizedBox(
            height: 24,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'All',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Asset.colorTextTile),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          buildAll(),
        ],
      ),
    );
  }

  Widget buildSearch() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          controller: _controllerSearch,
          decoration: InputDecoration(
              prefixIcon: IconButton(
                onPressed: () => Get.to(SearchApparel(
                  searchQuery: _controllerSearch.text,
                )),
                icon: Icon(
                  Icons.search,
                  color: Asset.colorPrimary,
                ),
              ),
              hintText: 'Search....',
              suffixIcon: IconButton(
                onPressed: () {
                  _controllerSearch.clear();
                },
                icon: Icon(
                  Icons.clear,
                  color: Asset.colorPrimary,
                ),
              ),
              border: styleBorder(),
              enabledBorder: styleBorder(),
              focusedBorder: styleBorder(),
              disabledBorder: styleBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              fillColor: Asset.colorAccent,
              filled: true),
        ));
  }

  Widget buildPopular() {
    return FutureBuilder(
        future: getPopular(),
        builder: (context, AsyncSnapshot<List<Apparel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data == null) {
            return Center(
              child: Text('Empty'),
            );
          }
          if (snapshot.data!.length > 0) {
            return Container(
                height: 290,
                child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      Apparel apparel = snapshot.data![index];
                      return GestureDetector(
                        onTap: () => Get.to(DetaiApparel(
                          apparel: apparel,
                        )),
                        child: Container(
                          width: 200,
                          margin: EdgeInsets.fromLTRB(
                            index == 0 ? 16 : 8,
                            10,
                            index == snapshot.data!.length - 1 ? 16 : 8,
                            10,
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(0, 3),
                                    blurRadius: 6,
                                    color: Colors.black26)
                              ]),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                                child: FadeInImage(
                                  height: 150,
                                  width: 200,
                                  fit: BoxFit.cover,
                                  placeholder: AssetImage(Asset.imageBox),
                                  image: NetworkImage(apparel.image),
                                  imageErrorBuilder:
                                      (context, error, stackTrace) {
                                    return Center(
                                      child: Icon(Icons.broken_image),
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      apparel.name,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      children: [
                                        RatingBar.builder(
                                          initialRating: apparel.rating,
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemPadding: EdgeInsets.symmetric(
                                              horizontal: 0),
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
                                        Text('(${apparel.rating})')
                                      ],
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      'Rp ${apparel.price}',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Asset.colorPrimary,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }));
          } else {
            return Center(child: Text('Empty'));
          }
        });
  }

  Widget buildAll() {
    return FutureBuilder(
        future: getAll(),
        builder: (context, AsyncSnapshot<List<Apparel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data == null) {
            return Center(
              child: Text('Empty'),
            );
          }
          if (snapshot.data!.length > 0) {
            return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  Apparel apparel = snapshot.data![index];
                  return GestureDetector(
                    onTap: () => Get.to(DetaiApparel(
                      apparel: apparel,
                    )),
                    child: Container(
                      margin: EdgeInsets.fromLTRB(
                        16,
                        index == 0 ? 16 : 8,
                        16,
                        index == snapshot.data!.length - 1 ? 16 : 8,
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 0),
                                blurRadius: 6,
                                color: Colors.black26),
                          ]),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            ),
                            child: FadeInImage(
                              height: 90,
                              width: 80,
                              fit: BoxFit.cover,
                              placeholder: AssetImage(Asset.imageBox),
                              image: NetworkImage(apparel.image),
                              imageErrorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Icon(Icons.broken_image),
                                );
                              },
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Sepatu',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    '${apparel.tags!.join(', ')}',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Asset.colorPrimary,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    'Rp ${apparel.price}',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Asset.colorPrimary,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Icon(
                            Icons.navigate_next,
                          ),
                          SizedBox(
                            width: 16,
                          )
                        ],
                      ),
                    ),
                  );
                });
          } else {
            return Center(child: Text('Empty'));
          }
        });
  }

  InputBorder styleBorder() {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(width: 2, color: Asset.colorTextTile));
  }
}
