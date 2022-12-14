import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;

import '../config/api.dart';
import '../config/asset.dart';
import '../model/apparel.dart';
import 'detail_apparel.dart';

class SearchApparel extends StatefulWidget {
  final String? searchQuery;
  SearchApparel({this.searchQuery});

  @override
  State<SearchApparel> createState() => _SearchApparelState();
}

class _SearchApparelState extends State<SearchApparel> {
  var _controllerSearch = TextEditingController();

  Future<List<Apparel>> getAll() async {
    List<Apparel> listSearch = [];
    if (_controllerSearch.text != '') {
      try {
        var response = await http.post(Uri.parse(Api.searchApparel), body: {
          'search': _controllerSearch.text,
        });
        if (response.statusCode == 200) {
          var responseBody = json.decode(response.body);
          if (responseBody['success']) {
            (responseBody['data'] as List).forEach((element) {
              listSearch.add(Apparel.fromJson(element));
            });
          }
        }
      } catch (e) {
        print(e);
      }
    }
    return listSearch;
  }

  @override
  void initState() {
    _controllerSearch.text = widget.searchQuery!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Asset.colorPrimary,
        // leading: ,
        titleSpacing: 0,
        title: buildSearch(),
      ),
      body: buildAll(),
    );
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

  Widget buildSearch() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 16, 0),
      child: TextField(
        controller: _controllerSearch,
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.search,
              color: Asset.colorPrimary,
            ),
            hintText: 'Search....',
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {});
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
      ),
    );
  }

  InputBorder styleBorder() {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(width: 0, color: Asset.colorTextTile));
  }
}
