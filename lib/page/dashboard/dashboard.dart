import 'package:ecommerce_shoes/config/asset.dart';
import 'package:ecommerce_shoes/controller/c_user.dart';
import 'package:ecommerce_shoes/page/dashboard/fragment_home.dart';
import 'package:ecommerce_shoes/page/dashboard/fragment_order.dart';
import 'package:ecommerce_shoes/page/dashboard/fragment_profile.dart';
import 'package:ecommerce_shoes/page/dashboard/fragment_whislist.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class Dashboard extends StatelessWidget {
  RxInt _index = 0.obs;
  List<Widget> _fragments = [
    FragmentHome(),
    FragmentWhislist(),
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
      'icon_off': Icons.bookmark_border,
      'label': 'Wishlist',
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

  CUser _cUser = Get.put(CUser());

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: CUser(),
      initState: (state) {
        _cUser.getUser();
      },
      builder: (controller) {
        return Scaffold(
          body: SafeArea(child: Obx(() => _fragments[_index.value])),
          bottomNavigationBar: Obx(
            () => BottomNavigationBar(
              currentIndex: _index.value,
              onTap: (value) => _index.value = value,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              selectedItemColor: Asset.colorTextTitle,
              unselectedItemColor: Asset.colorTextTitle,
              items: List.generate(4, (index) {
                var nav = _navs[index];
                return BottomNavigationBarItem(
                  icon: Icon(nav['icon_off']),
                  label: nav['label'],
                  activeIcon: Icon(nav['icon_on']),
                );
              }),
            ),
          ),
        );
      },
    );
  }
}
