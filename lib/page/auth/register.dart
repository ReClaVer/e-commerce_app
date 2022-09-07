import 'dart:convert';

import 'package:ecommerce_app/config/asset.dart';
import 'package:ecommerce_app/model/user.dart';
import 'package:ecommerce_app/widget/info_message.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/src/foundation/key.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import '../../config/api.dart';

class Register extends StatelessWidget {
  var _controllerName = TextEditingController();
  var _controllerEmail = TextEditingController();
  var _controllerPassword = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  var _obsecure = true.obs;

  void checkEmail() async {
    try {
      var response = await http.post(Uri.parse(Api.checkEmail), body: {
        'email': _controllerEmail.text,
      });
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['exist']) {
          infoMessage.snackbar(
              Get.context!, 'Email has exist, try another email');
        } else {
          register();
        }
      }
    } catch (e) {
      print(e);
    }
  }

  void register() async {
    User user = User(
      2,
      _controllerEmail.text,
      _controllerName.text,
      _controllerPassword.text,
    );
    try {
      var response =
          await http.post(Uri.parse(Api.register), body: user.toJson());
      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        if (responseBody['success']) {
          infoMessage.snackbar(Get.context!, 'Register Succes');
        } else {
          infoMessage.snackbar(Get.context!, 'Register Failed');
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Asset.colorBackground,
      body: Stack(
        children: [
          Align(
            alignment: Alignment(0, -0.6),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(width: 5, color: Asset.colorAccent)),
              child: Icon(
                Icons.account_circle,
                size: 150,
                color: Asset.colorAccent,
              ),
            ),
          ),
          Positioned(
              bottom: MediaQuery.of(context).size.height * 0.5 + 15,
              left: 30,
              child: Text(
                'Register',
                style: TextStyle(
                    fontSize: 24,
                    color: Asset.colorAccent,
                    fontWeight: FontWeight.w500),
              )),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.5,
            left: 0,
            bottom: 0,
            right: 0,
            child: LayoutBuilder(builder: (context, constraints) {
              return Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40),
                    ),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 6,
                        color: Colors.black26,
                        offset: Offset(0, -3),
                      )
                    ]),
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(30, 30, 30, 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                    validator: (value) =>
                                        value == '' ? "Dont Empty" : null,
                                    controller: _controllerName,
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.person,
                                          color: Asset.colorPrimary,
                                        ),
                                        hintText: 'Full Name',
                                        border: styleBorder(),
                                        enabledBorder: styleBorder(),
                                        focusedBorder: styleBorder(),
                                        disabledBorder: styleBorder(),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        fillColor: Asset.colorAccent,
                                        filled: true)),
                                SizedBox(
                                  height: 16,
                                ),
                                TextFormField(
                                    validator: (value) =>
                                        value == '' ? "Dont Empty" : null,
                                    controller: _controllerEmail,
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.email,
                                          color: Asset.colorPrimary,
                                        ),
                                        hintText: 'email@gmail.com',
                                        border: styleBorder(),
                                        enabledBorder: styleBorder(),
                                        focusedBorder: styleBorder(),
                                        disabledBorder: styleBorder(),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        fillColor: Asset.colorAccent,
                                        filled: true)),
                                SizedBox(
                                  height: 16,
                                ),
                                Obx(() => TextFormField(
                                    validator: (value) =>
                                        value == '' ? "Dont Empty" : null,
                                    obscureText: _obsecure.value,
                                    controller: _controllerPassword,
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.vpn_key,
                                          color: Asset.colorPrimary,
                                        ),
                                        hintText: 'password',
                                        suffixIcon: Obx(
                                          (() => GestureDetector(
                                                onTap: () {
                                                  _obsecure.value =
                                                      !_obsecure.value;
                                                },
                                                child: Icon(
                                                  _obsecure.value
                                                      ? Icons.visibility_off
                                                      : Icons.visibility,
                                                  color: Asset.colorPrimary,
                                                ),
                                              )),
                                        ),
                                        border: styleBorder(),
                                        enabledBorder: styleBorder(),
                                        focusedBorder: styleBorder(),
                                        disabledBorder: styleBorder(),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        fillColor: Asset.colorAccent,
                                        filled: true))),
                                SizedBox(
                                  height: 16,
                                ),
                                Material(
                                  color: Asset.colorPrimary,
                                  borderRadius: BorderRadius.circular(30),
                                  child: InkWell(
                                    onTap: () {
                                      if (_formKey.currentState!.validate()) {
                                        print('Register Execution');
                                        register();
                                      }
                                    },
                                    borderRadius: BorderRadius.circular(30),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 12),
                                      child: Text(
                                        'Register',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Already have account?'),
                              TextButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: Text(
                                    'Login',
                                    style: TextStyle(
                                        color: Asset.colorPrimary,
                                        fontWeight: FontWeight.bold),
                                  ))
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  InputBorder styleBorder() {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(width: 0, color: Asset.colorAccent));
  }
}
