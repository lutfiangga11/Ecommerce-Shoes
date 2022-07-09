import 'package:ecommerce_shoes/config/asset.dart';
import 'package:ecommerce_shoes/controller/c_user.dart';
import 'package:ecommerce_shoes/event/event_pref.dart';
import 'package:ecommerce_shoes/page/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FragmentProfile extends StatelessWidget {
  final _cUser = Get.put(CUser());

  void logout() async {
    var response = await Get.dialog(
      AlertDialog(
        title: Text('Logout'),
        content: Text('You sure to logout?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('No')),
          TextButton(
              onPressed: () => Get.back(result: 'yes'), child: Text('Yes')),
        ],
      ),
    );
    if (response == 'yes') {
      EventPref.deleteUser().then((value) {
        Get.off(Login());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(30),
      children: [
        SizedBox(height: 30),
        Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(width: 3, color: Asset.colorAccent),
            ),
            child: Icon(
              Icons.account_circle,
              size: 150,
              color: Asset.colorAccent,
            ),
          ),
        ),
        SizedBox(height: 30),
        buildItemProfile(Icons.person, _cUser.user.name),
        SizedBox(height: 16),
        buildItemProfile(Icons.email, _cUser.user.email),
        SizedBox(height: 16),
        Center(
          child: Material(
            color: Asset.colorPrimary,
            borderRadius: BorderRadius.circular(30),
            child: InkWell(
              onTap: () => logout(),
              borderRadius: BorderRadius.circular(30),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12,
                ),
                child: Text(
                  'LOGOUT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildItemProfile(IconData icon, String data) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Asset.colorAccent,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 30,
            color: Asset.colorPrimary,
          ),
          SizedBox(
            width: 16,
          ),
          Text(
            data,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
