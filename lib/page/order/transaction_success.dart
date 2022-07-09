import 'package:ecommerce_shoes/config/asset.dart';
import 'package:ecommerce_shoes/page/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionSuccess extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Transaction\nSuccess',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Asset.colorTextTitle,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              SizedBox(height: 30),
              Material(
                elevation: 8,
                color: Asset.colorPrimary,
                borderRadius: BorderRadius.circular(30),
                child: InkWell(
                  onTap: () => Get.offAll(Dashboard()),
                  borderRadius: BorderRadius.circular(30),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 12,
                    ),
                    child: Text(
                      'HOME',
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
      ),
    );
  }
}
