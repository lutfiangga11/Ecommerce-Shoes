import 'dart:convert';

import 'package:ecommerce_shoes/config/api.dart';
import 'package:ecommerce_shoes/config/asset.dart';
import 'package:ecommerce_shoes/controller/c_user.dart';
import 'package:ecommerce_shoes/model/order.dart';
import 'package:ecommerce_shoes/page/order/detail_order.dart';

import 'package:ecommerce_shoes/page/order/history.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class FragmentOrder extends StatefulWidget {
  @override
  _FragmentOrderState createState() => _FragmentOrderState();
}

class _FragmentOrderState extends State<FragmentOrder> {
  final _cUser = Get.put(CUser());

  Future<List<Order>> getOrder() async {
    List<Order> listOrder = [];
    try {
      var response = await http.post(Uri.parse(Api.getOrder), body: {
        'id_user': _cUser.user.idUser.toString(),
      });
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['success']) {
          (responseBody['data'] as List).forEach((element) {
            listOrder.add(Order.fromJson(element));
          });
        }
      }
    } catch (e) {
      print(e);
    }
    return listOrder;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16, 24, 8, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order',
                style: TextStyle(
                  color: Asset.colorTextTitle,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () => Get.to(History()),
                icon: Icon(Icons.history, color: Asset.colorTextTitle),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Transaction you do',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        Expanded(
          child: buildListOrder(),
        ),
      ],
    );
  }

  Widget buildListOrder() {
    return FutureBuilder(
      future: getOrder(),
      builder: (context, AsyncSnapshot<List<Order>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.data == null) {
          return Center(child: Text('Empty'));
        }
        if (snapshot.data!.length > 0) {
          List<Order> listOrder = snapshot.data!;
          return ListView.separated(
            padding: EdgeInsets.all(16),
            separatorBuilder: (context, index) {
              return Divider(height: 1, thickness: 1);
            },
            itemCount: listOrder.length,
            itemBuilder: (context, index) {
              Order order = listOrder[index];
              return ListTile(
                onTap: () => Get.to(DetailOrder(order: order))!
                    .then((value) => setState(() {})),
                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                title: Text(
                  '\$ ${order.total}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Asset.colorPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(DateFormat('dd/MM/yyyy').format(order.dateTime)),
                        SizedBox(height: 4),
                        Text(DateFormat('HH:mm').format(order.dateTime)),
                      ],
                    ),
                    Icon(Icons.navigate_next, color: Asset.colorPrimary),
                  ],
                ),
              );
            },
          );
        } else {
          return Center(child: Text('Empty'));
        }
      },
    );
  }
}
