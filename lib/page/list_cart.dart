import 'dart:convert';

import 'package:ecommerce_shoes/config/api.dart';
import 'package:ecommerce_shoes/config/asset.dart';
import 'package:ecommerce_shoes/controller/c_list_cart.dart';
import 'package:ecommerce_shoes/controller/c_user.dart';
import 'package:ecommerce_shoes/model/cart.dart';
import 'package:ecommerce_shoes/model/shoes.dart';
import 'package:ecommerce_shoes/page/detail_shoes.dart';
import 'package:ecommerce_shoes/page/order/order_now.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ListCart extends StatefulWidget {
  @override
  _ListCartState createState() => _ListCartState();
}

class _ListCartState extends State<ListCart> {
  final _cUser = Get.put(CUser());
  final _cListCart = Get.put(CListCart());

  List<Map<String, dynamic>> getListShop() {
    List<Map<String, dynamic>> listShop = [];
    if (_cListCart.selected.length > 0) {
      _cListCart.list.forEach((cart) {
        if (_cListCart.selected.contains(cart.idCart)) {
          Map<String, dynamic> item = {
            'id_shoes': cart.idShoes,
            'image': cart.image,
            'name': cart.name,
            'color': cart.color,
            'size': cart.size,
            'quantity': cart.quantity,
            'item_total': cart.price * cart.quantity,
          };
          listShop.add(item);
        }
      });
    }
    return listShop;
  }

  void countTotal() {
    _cListCart.setTotal(0.0);
    if (_cListCart.selected.length > 0) {
      _cListCart.list.forEach((cart) {
        if (_cListCart.selected.contains(cart.idCart)) {
          double itemTotal = cart.price * cart.quantity;
          _cListCart.setTotal(_cListCart.total + itemTotal);
        }
      });
    }
  }

  void getList() async {
    List<Cart> listCart = [];
    try {
      var response = await http.post(Uri.parse(Api.getCart), body: {
        'id_user': _cUser.user.idUser.toString(),
      });
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['success']) {
          (responseBody['data'] as List).forEach((element) {
            listCart.add(Cart.fromJson(element));
          });
        }
        _cListCart.setList(listCart);
      }
    } catch (e) {
      print(e);
    }
    countTotal();
  }

  void updateCart(int idCart, int newQuantity) async {
    try {
      var response = await http.post(Uri.parse(Api.updateCart), body: {
        'id_cart': idCart.toString(),
        'quantity': newQuantity.toString(),
      });
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['success']) {
          getList();
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
        if (responseBody['success']) {
          getList();
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Asset.colorPrimary,
        titleSpacing: 0,
        title: Text('Cart'),
        actions: [
          Obx(
            () => IconButton(
              onPressed: () {
                _cListCart.setIsSelectedAll();
                _cListCart.selectedClear();
                if (_cListCart.isSelectedAll) {
                  _cListCart.list.forEach((e) {
                    _cListCart.addSelected(e.idCart);
                  });
                }
                countTotal();
              },
              icon: Icon(
                _cListCart.isSelectedAll
                    ? Icons.check_box
                    : Icons.check_box_outline_blank_rounded,
              ),
            ),
          ),
          GetBuilder(
            init: CListCart(),
            builder: (_) => _cListCart.selected.length > 0
                ? IconButton(
                    onPressed: () async {
                      var response = await Get.dialog(AlertDialog(
                        title: Text('Delete'),
                        content: Text('You sure to delete selected cart?'),
                        actions: [
                          TextButton(
                              onPressed: () => Get.back(), child: Text('No')),
                          TextButton(
                              onPressed: () => Get.back(result: 'yes'),
                              child: Text('Yes')),
                        ],
                      ));
                      if (response == 'yes') {
                        _cListCart.selected.forEach((idCart) {
                          deleteCart(idCart);
                        });
                      }
                      countTotal();
                    },
                    icon: Icon(Icons.delete_forever),
                  )
                : SizedBox(),
          ),
        ],
      ),
      body: Obx(() => _cListCart.list.length > 0
          ? ListView.builder(
              itemCount: _cListCart.list.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                Cart cart = _cListCart.list[index];
                Shoes shoes = Shoes(
                  idShoes: cart.idShoes,
                  colors: cart.colors,
                  image: cart.image,
                  name: cart.name,
                  price: cart.price,
                  rating: cart.rating,
                  sizes: cart.sizes,
                  description: cart.description,
                  tags: cart.tags,
                );
                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      GetBuilder(
                        init: CListCart(),
                        builder: (_) {
                          return IconButton(
                            onPressed: () {
                              if (_cListCart.selected.contains(cart.idCart)) {
                                _cListCart.deleteSelected(cart.idCart);
                              } else {
                                _cListCart.addSelected(cart.idCart);
                              }
                              countTotal();
                            },
                            icon: Icon(
                              _cListCart.selected.contains(cart.idCart)
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                            ),
                          );
                        },
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Get.to(DetailShoes(
                            shoes: shoes,
                          ))!
                              .then((value) => getList()),
                          child: Container(
                            margin: EdgeInsets.fromLTRB(
                              0,
                              index == 0 ? 16 : 8,
                              16,
                              index == _cListCart.list.length - 1 ? 16 : 8,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0, 0),
                                  blurRadius: 6,
                                  color: Colors.black26,
                                )
                              ],
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    bottomLeft: Radius.circular(20),
                                  ),
                                  child: FadeInImage(
                                    height: 100,
                                    width: 90,
                                    fit: BoxFit.cover,
                                    placeholder: AssetImage(Asset.imageBox),
                                    image: NetworkImage(cart.image),
                                    imageErrorBuilder:
                                        (context, error, stackTrace) {
                                      return Container(
                                        height: 100,
                                        width: 90,
                                        alignment: Alignment.center,
                                        child: Icon(Icons.broken_image),
                                      );
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          cart.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          '${cart.color}, ${cart.size}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 8),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                if (cart.quantity - 1 >= 1) {
                                                  updateCart(
                                                    cart.idCart,
                                                    cart.quantity - 1,
                                                  );
                                                }
                                              },
                                              child: Icon(
                                                Icons
                                                    .remove_circle_outline_rounded,
                                                size: 30,
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              cart.quantity.toString(),
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Asset.colorPrimary,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            GestureDetector(
                                              onTap: () {
                                                updateCart(
                                                  cart.idCart,
                                                  cart.quantity + 1,
                                                );
                                              },
                                              child: Icon(
                                                Icons
                                                    .add_circle_outline_rounded,
                                                size: 30,
                                              ),
                                            ),
                                            Spacer(),
                                            Text(
                                              '\$ ${cart.price}',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Asset.colorPrimary,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(width: 16),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          : Center(
              child: Text('Empty'),
            )),
      bottomNavigationBar: GetBuilder(
          init: CListCart(),
          builder: (_) => Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, -3),
                      color: Colors.black26,
                      blurRadius: 6,
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Text(
                      'Total:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    Obx(() => Text(
                          '\$ ' + _cListCart.total.toStringAsFixed(2),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 20,
                            color: Asset.colorPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    Spacer(),
                    Material(
                      color: _cListCart.selected.length > 0
                          ? Asset.colorPrimary
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(30),
                      child: InkWell(
                        onTap: _cListCart.selected.length > 0
                            ? () => Get.to(
                                  OrderNow(
                                    listShop: getListShop(),
                                    total: _cListCart.total,
                                    listIdCart: _cListCart.selected,
                                  ),
                                )
                            : null,
                        borderRadius: BorderRadius.circular(30),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 10,
                          ),
                          child: Text(
                            'Order Now',
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
              )),
    );
  }
}
