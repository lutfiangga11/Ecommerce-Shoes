import 'package:ecommerce_shoes/event/event_pref.dart';
import 'package:ecommerce_shoes/page/auth/login.dart';
import 'package:ecommerce_shoes/page/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: EventPref.getUser(),
        builder: (context, snapshot) {
          if (snapshot.data == null) return Login();
          return Dashboard();
        },
      ),
    );
  }
}
