import 'dart:convert';

import 'package:ecommerce_app/controller/c_user.dart';
import 'package:ecommerce_app/model/apparel.dart';
import 'package:ecommerce_app/model/wishlist.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../config/api.dart';
import '../../config/asset.dart';
import '../detail_apparel.dart';

class FragmentWishlist extends StatefulWidget {
  @override
  State<FragmentWishlist> createState() => _FragmentWishlistState();
}

class _FragmentWishlistState extends State<FragmentWishlist> {
  final _cUser = Get.put(CUser());

  Future<List<Wishlist>> getAll() async {
    List<Wishlist> listWishlist = [];
    try {
      var response = await http.post(Uri.parse(Api.getWishlist), body: {
        'id_user': _cUser.user.idUser.toString(),
      });
      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        if (responseBody['success']) {
          (responseBody['data'] as List).forEach((element) {
            listWishlist.add(Wishlist.fromJson(element));
          });
        }
      }
    } catch (e) {
      print(e);
    }
    return listWishlist;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 8, 8),
          child: Text(
            'Wishlist',
            style: TextStyle(
                color: Asset.colorTextTile,
                fontWeight: FontWeight.bold,
                fontSize: 30),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Hope all of this can purchased',
            style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
          ),
        ),
        SizedBox(
          height: 24,
        ),
        buildAll(),
      ]),
    );
  }

  Widget buildAll() {
    return FutureBuilder(
        future: getAll(),
        builder: (context, AsyncSnapshot<List<Wishlist>> snapshot) {
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
                  Wishlist wishlist = snapshot.data![index];
                  Apparel apparel = Apparel(
                      colors: wishlist.colors,
                      idApparel: wishlist.idApparel,
                      image: wishlist.image,
                      name: wishlist.name,
                      price: wishlist.price,
                      rating: wishlist.rating,
                      sizes: wishlist.sizes,
                      description: wishlist.description,
                      tags: wishlist.tags);
                  return GestureDetector(
                    onTap: () => Get.to(DetaiApparel(
                      apparel: apparel,
                    ))!
                        .then((value) => setState(
                              () {},
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
                                    apparel.name,
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
}
