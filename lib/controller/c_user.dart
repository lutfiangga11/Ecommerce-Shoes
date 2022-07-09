import 'package:ecommerce_shoes/event/event_pref.dart';
import 'package:ecommerce_shoes/model/user.dart';
import 'package:get/get.dart';

class CUser extends GetxController {
  Rx<User> _user = User(0, '', '', '').obs;

  User get user => _user.value;

  void getUser() async {
    User? user = await EventPref.getUser();
    _user.value = user!;
  }
}
