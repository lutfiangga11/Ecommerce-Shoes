import 'dart:convert';

import 'package:ecommerce_shoes/config/api.dart';
import 'package:ecommerce_shoes/config/asset.dart';
import 'package:ecommerce_shoes/controller/c_detail_shoes.dart';
import 'package:ecommerce_shoes/controller/c_user.dart';
import 'package:ecommerce_shoes/model/shoes.dart';
import 'package:ecommerce_shoes/page/list_cart.dart';
import 'package:ecommerce_shoes/widget/info_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class DetailShoes extends StatefulWidget {
  final Shoes? shoes;
  DetailShoes({this.shoes});

  @override
  _DetailShoesState createState() => _DetailShoesState();
}

class _DetailShoesState extends State<DetailShoes> {
  final _cDetailShoes = Get.put(CDetailShoes());
  final _cUser = Get.put(CUser());

  void checkWishlist() async {
    try {
      var response = await http.post(
        Uri.parse(Api.checkWhislist),
        body: {
          'id_user': _cUser.user.idUser.toString(),
          'id_shoes': widget.shoes!.idShoes.toString(),
        },
      );
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        _cDetailShoes.setIsWhislist(responseBody['exist']);
      }
    } catch (e) {
      print(e);
    }
  }

  void addWishlist() async {
    try {
      var response = await http.post(
        Uri.parse(Api.addWhislist),
        body: {
          'id_user': _cUser.user.idUser.toString(),
          'id_shoes': widget.shoes!.idShoes.toString(),
        },
      );
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['success']) {
          checkWishlist();
        }
      }
    } catch (e) {
      print(e);
    }
  }

  void deleteWishlist() async {
    try {
      var response = await http.post(
        Uri.parse(Api.deleteWhislist),
        body: {
          'id_user': _cUser.user.idUser.toString(),
          'id_shoes': widget.shoes!.idShoes.toString(),
        },
      );
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['success']) {
          checkWishlist();
        }
      }
    } catch (e) {
      print(e);
    }
  }

  void addCart() async {
    try {
      var response = await http.post(
        Uri.parse(Api.addCart),
        body: {
          'id_user': _cUser.user.idUser.toString(),
          'id_shoes': widget.shoes!.idShoes.toString(),
          'quantity': _cDetailShoes.quantity.toString(),
          'size': widget.shoes!.sizes[_cDetailShoes.size],
          'color': widget.shoes!.colors[_cDetailShoes.color],
        },
      );
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['success']) {
          InfoMessage.snackbar(context, 'Shoes has added to cart');
        } else {
          InfoMessage.snackbar(context, 'Failed add shoes to cart');
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    checkWishlist();
    _cDetailShoes.setQuantity(1);
    _cDetailShoes.setSize(0);
    _cDetailShoes.setColor(0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FadeInImage(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
            placeholder: AssetImage(Asset.imageBox),
            image: NetworkImage(widget.shoes!.image),
            imageErrorBuilder: (context, error, stackTrace) {
              return Center(
                child: Icon(Icons.broken_image),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: buildInfo(),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.black.withOpacity(0.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(
                      Icons.arrow_back,
                      color: Asset.colorPrimary,
                    ),
                  ),
                  Spacer(),
                  Obx(() => IconButton(
                        onPressed: () {
                          if (_cDetailShoes.isWhislit) {
                            deleteWishlist();
                          } else {
                            addWishlist();
                          }
                        },
                        icon: Icon(
                          _cDetailShoes.isWhislit
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          color: Asset.colorPrimary,
                        ),
                      )),
                  IconButton(
                    onPressed: () => Get.to(ListCart()),
                    icon: Icon(
                      Icons.shopping_cart,
                      color: Asset.colorPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInfo() {
    return Container(
      height: MediaQuery.of(Get.context!).size.height * 0.6,
      width: MediaQuery.of(Get.context!).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -3),
            blurRadius: 6,
            color: Colors.black12,
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Center(
              child: Container(
                height: 8,
                width: 120,
                decoration: BoxDecoration(
                  color: Colors.grey[600],
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            SizedBox(height: 30),
            Text(
              widget.shoes!.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          RatingBar.builder(
                            initialRating: widget.shoes!.rating,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {},
                            ignoreGestures: true,
                            unratedColor: Colors.grey,
                            itemSize: 20,
                          ),
                          SizedBox(width: 8),
                          Text('(${widget.shoes!.rating})')
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        widget.shoes!.tags!.join(', '),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        '\$ ${widget.shoes!.price}',
                        style: TextStyle(
                          fontSize: 24,
                          color: Asset.colorPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          _cDetailShoes.setQuantity(_cDetailShoes.quantity + 1);
                        },
                        icon: Icon(Icons.add_circle_outline_rounded),
                      ),
                      Text(
                        _cDetailShoes.quantity.toString(),
                        style: TextStyle(
                          fontSize: 20,
                          color: Asset.colorPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (_cDetailShoes.quantity - 1 >= 1) {
                            _cDetailShoes
                                .setQuantity(_cDetailShoes.quantity - 1);
                          }
                        },
                        icon: Icon(Icons.remove_circle_outline_rounded),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Text(
              'Size',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Wrap(
              runSpacing: 8,
              spacing: 8,
              children: List.generate(widget.shoes!.sizes.length, (index) {
                return Obx(() => GestureDetector(
                      onTap: () => _cDetailShoes.setSize(index),
                      child: Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            width: 2,
                            color: _cDetailShoes.size == index
                                ? Asset.colorPrimary
                                : Colors.grey,
                          ),
                          color: _cDetailShoes.size == index
                              ? Asset.colorAccent
                              : Colors.white,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          widget.shoes!.sizes[index],
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ));
              }),
            ),
            SizedBox(height: 20),
            Text(
              'Color',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Wrap(
              runSpacing: 8,
              spacing: 8,
              children: List.generate(widget.shoes!.colors.length, (index) {
                return Obx(() => GestureDetector(
                      onTap: () => _cDetailShoes.setColor(index),
                      child: FittedBox(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              width: 2,
                              color: _cDetailShoes.color == index
                                  ? Asset.colorPrimary
                                  : Colors.grey,
                            ),
                            color: _cDetailShoes.color == index
                                ? Asset.colorAccent
                                : Colors.white,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            widget.shoes!.colors[index],
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ),
                    ));
              }),
            ),
            SizedBox(height: 20),
            Text(
              'Description',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(widget.shoes!.description!),
            SizedBox(height: 30),
            Material(
              elevation: 4,
              color: Asset.colorPrimary,
              borderRadius: BorderRadius.circular(30),
              child: InkWell(
                onTap: () => addCart(),
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  child: Text(
                    'ADD TO CART',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
