import 'dart:convert';

import 'package:ecommerce_shoes/config/api.dart';
import 'package:ecommerce_shoes/config/asset.dart';
import 'package:ecommerce_shoes/event/event_pref.dart';
import 'package:ecommerce_shoes/model/user.dart';
import 'package:ecommerce_shoes/page/auth/register.dart';
import 'package:ecommerce_shoes/page/dashboard/dashboard.dart';
import 'package:ecommerce_shoes/widget/info_message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class Login extends StatelessWidget {
  var _controllerEmail = TextEditingController();
  var _controllerPassword = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  var _obsecure = true.obs;

  void login() async {
    try {
      var response = await http.post(
        Uri.parse(Api.login),
        body: {
          'email': _controllerEmail.text,
          'password': _controllerPassword.text,
        },
      );

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['success']) {
          InfoMessage.snackbar(Get.context!, 'Login Success');
          User user = User.fromJson(responseBody['data']);
          await EventPref.saveUser(user);
          Future.delayed(Duration(milliseconds: 1500), () {
            Get.off(Dashboard());
          });
        } else {
          InfoMessage.snackbar(Get.context!, 'Login Failed');
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  buildHeader(),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - 300,
                    ),
                    child: buildForm(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildHeader() {
    return Container(
      width: MediaQuery.of(Get.context!).size.width,
      height: 300,
      padding: EdgeInsets.fromLTRB(30, 0, 30, 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
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
          Text(
            'LOGIN',
            style: TextStyle(
              fontSize: 24,
              color: Asset.colorAccent,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildForm() {
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
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(30, 30, 30, 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _controllerEmail,
                    validator: (value) => value == '' ? "Don't Empty" : null,
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
                        horizontal: 16,
                        vertical: 8,
                      ),
                      fillColor: Asset.colorAccent,
                      filled: true,
                    ),
                  ),
                  SizedBox(height: 16),
                  Obx(
                    () => TextFormField(
                      controller: _controllerPassword,
                      validator: (value) => value == '' ? "Don't Empty" : null,
                      obscureText: _obsecure.value,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.vpn_key,
                          color: Asset.colorPrimary,
                        ),
                        hintText: 'akjshkaskas',
                        suffixIcon: Obx(
                          () => GestureDetector(
                            onTap: () {
                              _obsecure.value = !_obsecure.value;
                            },
                            child: Icon(
                              _obsecure.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Asset.colorPrimary,
                            ),
                          ),
                        ),
                        border: styleBorder(),
                        enabledBorder: styleBorder(),
                        focusedBorder: styleBorder(),
                        disabledBorder: styleBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        fillColor: Asset.colorAccent,
                        filled: true,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Material(
                    color: Asset.colorPrimary,
                    borderRadius: BorderRadius.circular(30),
                    child: InkWell(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          print('login');
                          login();
                        }
                      },
                      borderRadius: BorderRadius.circular(30),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 12,
                        ),
                        child: Text(
                          'LOGIN',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Not have account?'),
                TextButton(
                  onPressed: () {
                    Get.to(Register());
                  },
                  child: Text(
                    'Register',
                    style: TextStyle(
                      color: Asset.colorPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  InputBorder styleBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide(
        width: 0,
        color: Asset.colorAccent,
      ),
    );
  }
}
