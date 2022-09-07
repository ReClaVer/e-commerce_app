import 'package:ecommerce_app/event/event_pref.dart';
import 'package:ecommerce_app/page/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'page/dashboard/dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Dashboard(),
      // home: FutureBuilder(
      //     future: EventPref.getUser(),
      //     builder: (context, snapshot) {
      //       if (snapshot.data == null) return Login();
      //       return Dashboard();
      //     })
    );
  }
}
