import 'package:ecommerce_app/controller/c_user.dart';
import 'package:ecommerce_app/page/dashboard/fragment_home.dart';
import 'package:ecommerce_app/page/dashboard/fragment_order.dart';
import 'package:ecommerce_app/page/dashboard/fragment_profile.dart';
import 'package:ecommerce_app/page/dashboard/fragment_wishlist.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../config/asset.dart';

class Dashboard extends StatelessWidget {
  RxInt _index = 0.obs;
  List<Widget> _fragments = [
    FragmentHome(),
    FragmentWishlist(),
    FragmentOrder(),
    FragmentProfile(),
  ];

  List _navs = [
    {
      'icon_on': Icons.home,
      'icon_off': Icons.home_outlined,
      'label': 'Home',
    },
    {
      'icon_on': Icons.bookmark,
      'icon_off': Icons.bookmark_outline,
      'label': 'Whislist',
    },
    {
      'icon_on': FontAwesomeIcons.boxOpen,
      'icon_off': FontAwesomeIcons.box,
      'label': 'Order',
    },
    {
      'icon_on': Icons.account_circle,
      'icon_off': Icons.account_circle_outlined,
      'label': 'Profile',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: CUser(),
        builder: (controller) {
          return Scaffold(
              body: SafeArea(child: Obx(() => _fragments[_index.value])),
              bottomNavigationBar: Obx(
                (() => BottomNavigationBar(
                      currentIndex: _index.value,
                      onTap: (value) => _index.value = value,
                      selectedLabelStyle: TextStyle(
                        color: Asset.colorTextTile,
                      ),
                      showSelectedLabels: true,
                      showUnselectedLabels: true,
                      selectedItemColor: Asset.colorTextTile,
                      unselectedItemColor: Asset.colorTextTile,
                      items: List.generate(
                        4,
                        (index) {
                          var nav = _navs[index];
                          return BottomNavigationBarItem(
                              icon: Icon(nav['icon_off']),
                              label: nav['label'],
                              activeIcon: Icon(nav['icon_on']));
                        },
                      ),
                    )),
              ));
        });
  }
}
