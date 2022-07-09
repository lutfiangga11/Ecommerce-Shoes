import 'dart:convert';

import 'package:ecommerce_shoes/config/api.dart';
import 'package:ecommerce_shoes/config/asset.dart';
import 'package:ecommerce_shoes/model/shoes.dart';
import 'package:ecommerce_shoes/page/detail_shoes.dart';
import 'package:ecommerce_shoes/page/list_cart.dart';

import 'package:ecommerce_shoes/page/search_shoes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class FragmentHome extends StatelessWidget {
  var _controllerSearch = TextEditingController();

  Future<List<Shoes>> getPopular() async {
    List<Shoes> listShoesPopular = [];
    try {
      var response = await http.get(Uri.parse(Api.getPopularShoes));
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['success']) {
          (responseBody['data'] as List).forEach((element) {
            listShoesPopular.add(Shoes.fromJson(element));
          });
        }
      }
    } catch (e) {
      print(e);
    }
    return listShoesPopular;
  }

  Future<List<Shoes>> getAll() async {
    List<Shoes> listShoesPopular = [];
    try {
      var response = await http.get(Uri.parse(Api.getAllShoes));
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['success']) {
          (responseBody['data'] as List).forEach((element) {
            listShoesPopular.add(Shoes.fromJson(element));
          });
        }
      }
    } catch (e) {
      print(e);
    }
    return listShoesPopular;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16, 24, 8, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Find your style',
                  style: TextStyle(
                    color: Asset.colorTextTitle,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Get.to(ListCart()),
                  icon: Icon(Icons.shopping_cart, color: Asset.colorTextTitle),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Get the best of the best shoes',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          SizedBox(height: 24),
          buildSearch(),
          SizedBox(height: 24),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Popular',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Asset.colorTextTitle,
              ),
            ),
          ),
          SizedBox(height: 8),
          buildPopular(),
          SizedBox(height: 24),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'All',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Asset.colorTextTitle,
              ),
            ),
          ),
          SizedBox(height: 8),
          buildAll(),
        ],
      ),
    );
  }

  Widget buildPopular() {
    return FutureBuilder(
      future: getPopular(),
      builder: (context, AsyncSnapshot<List<Shoes>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.data == null) {
          return Center(child: Text('Empty'));
        }
        if (snapshot.data!.length > 0) {
          return Container(
            height: 280,
            child: ListView.builder(
              itemCount: snapshot.data!.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                Shoes shoes = snapshot.data![index];
                return GestureDetector(
                  onTap: () => Get.to(DetailShoes(shoes: shoes)),
                  child: Container(
                    width: 200,
                    margin: EdgeInsets.fromLTRB(
                      index == 0 ? 16 : 8,
                      10,
                      index == snapshot.data!.length - 1 ? 16 : 8,
                      10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 3),
                          blurRadius: 6,
                          color: Colors.black26,
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          child: FadeInImage(
                            height: 150,
                            width: 200,
                            fit: BoxFit.cover,
                            placeholder: AssetImage(Asset.imageBox),
                            image: NetworkImage(shoes.image),
                            imageErrorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Icon(Icons.broken_image),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                shoes.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  RatingBar.builder(
                                    initialRating: shoes.rating,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemPadding:
                                        EdgeInsets.symmetric(horizontal: 0),
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
                                  Text('(${shoes.rating})')
                                ],
                              ),
                              SizedBox(height: 8),
                              Text(
                                '\$ ${shoes.price}',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Asset.colorPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return Center(child: Text('Empty'));
        }
      },
    );
  }

  Widget buildAll() {
    return FutureBuilder(
      future: getAll(),
      builder: (context, AsyncSnapshot<List<Shoes>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.data == null) {
          return Center(child: Text('Empty'));
        }
        if (snapshot.data!.length > 0) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              Shoes shoes = snapshot.data![index];
              return GestureDetector(
                onTap: () => Get.to(DetailShoes(shoes: shoes)),
                child: Container(
                  margin: EdgeInsets.fromLTRB(
                    16,
                    index == 0 ? 16 : 8,
                    16,
                    index == snapshot.data!.length - 1 ? 16 : 8,
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
                          height: 90,
                          width: 90,
                          fit: BoxFit.cover,
                          placeholder: AssetImage(Asset.imageBox),
                          image: NetworkImage(shoes.image),
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Icon(Icons.broken_image),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                shoes.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '${shoes.tags!.join(', ')}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '\$ ${shoes.price}',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Asset.colorPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Icon(Icons.navigate_next, size: 30),
                      SizedBox(width: 16),
                    ],
                  ),
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

  Widget buildSearch() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: _controllerSearch,
        decoration: InputDecoration(
          prefixIcon: IconButton(
            onPressed: () => Get.to(
              SearchShoes(
                searchQuery: _controllerSearch.text,
              ),
            ),
            icon: Icon(
              Icons.search,
              color: Asset.colorPrimary,
            ),
          ),
          hintText: 'Search...',
          suffixIcon: IconButton(
            onPressed: () {
              _controllerSearch.clear();
            },
            icon: Icon(
              Icons.clear,
              color: Asset.colorPrimary,
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
    );
  }

  InputBorder styleBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide(
        width: 2,
        color: Asset.colorTextTitle,
      ),
    );
  }
}
