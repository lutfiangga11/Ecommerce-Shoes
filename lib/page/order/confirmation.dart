import 'dart:convert';
import 'dart:typed_data';

import 'package:ecommerce_shoes/config/api.dart';
import 'package:ecommerce_shoes/config/asset.dart';
import 'package:ecommerce_shoes/controller/c_user.dart';
import 'package:ecommerce_shoes/model/order.dart';
import 'package:ecommerce_shoes/page/order/transaction_success.dart';
import 'package:ecommerce_shoes/widget/info_message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class Confirmation extends StatelessWidget {
  final List<Map<String, dynamic>> listShop;
  final double total;
  final List<int> listIdCart;
  final String delivery;
  final String payment;
  final String note;
  Confirmation({
    required this.listShop,
    required this.total,
    required this.listIdCart,
    required this.delivery,
    required this.payment,
    required this.note,
  });

  RxList<int> _imageByte = <int>[].obs;
  RxString _imageName = ''.obs;
  void setImage(Uint8List newImage) => _imageByte.value = newImage;
  Uint8List get imageByte => Uint8List.fromList(_imageByte);
  void setImageName(String newName) => _imageName.value = newName;
  String get imageName => _imageName.value;

  CUser _cUser = Get.put(CUser());

  void pickImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setImage(bytes);
      setImageName(path.basename(pickedFile.path));
    }
  }

  void addOrder() async {
    String stringListShop =
        listShop.map((e) => jsonEncode(e)).toList().join('||');
    Order order = Order(
      idOrder: 1,
      arrived: '',
      delivery: delivery,
      idUser: _cUser.user.idUser,
      image: imageName,
      listShop: stringListShop,
      payment: payment,
      total: total,
      dateTime: DateTime.now(),
      note: note,
    );
    try {
      var response = await http.post(
        Uri.parse(Api.addOrder),
        body: order.toJson(base64Encode(imageByte)),
      );
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['success']) {
          Get.to(TransactionSuccess());
          listIdCart.forEach((idCart) => deleteCart(idCart));
        } else {
          InfoMessage.snackbar(Get.context!, 'Failed add order');
        }
      }
    } catch (e) {
      print(e);
    }
  }

  void deleteCart(int idCart) async {
    try {
      var response = await http.post(Uri.parse(Api.deleteCart), body: {
        'id_cart': idCart.toString(),
      });
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        print(responseBody['success']);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Add Transfer Photo',
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
                onTap: () => pickImage(),
                borderRadius: BorderRadius.circular(30),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 12,
                  ),
                  child: Text(
                    'PICK IMAGE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Obx(() => ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                    maxHeight: MediaQuery.of(context).size.width * 0.5,
                  ),
                  child: imageByte.length > 0
                      ? Image.memory(
                          imageByte,
                          fit: BoxFit.contain,
                        )
                      : Placeholder(),
                )),
            SizedBox(height: 16),
            Obx(() => Material(
                  elevation: 8,
                  color:
                      imageByte.length > 0 ? Asset.colorPrimary : Colors.grey,
                  borderRadius: BorderRadius.circular(30),
                  child: InkWell(
                    onTap: imageByte.length > 0
                        ? () {
                            addOrder();
                          }
                        : null,
                    borderRadius: BorderRadius.circular(30),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ),
                      child: Text(
                        'CONFIRMATION',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
