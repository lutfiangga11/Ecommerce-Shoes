import 'dart:convert';
import 'package:ecommerce_shoes/config/api.dart';
import 'package:ecommerce_shoes/model/shoes.dart';
import 'package:ecommerce_shoes/page/detail_shoes.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ecommerce_shoes/config/asset.dart';
import 'package:flutter/material.dart';

class SearchShoes extends StatefulWidget {
  final String? searchQuery;
  SearchShoes({this.searchQuery});

  @override
  _SearchShoesState createState() => _SearchShoesState();
}

class _SearchShoesState extends State<SearchShoes> {
  var _controllerSearch = TextEditingController();

  Future<List<Shoes>> getAll() async {
    List<Shoes> listSearch = [];
    if (_controllerSearch.text != '') {
      try {
        var response = await http.post(Uri.parse(Api.searchShoes), body: {
          'search': _controllerSearch.text,
        });
        if (response.statusCode == 200) {
          var responseBody = jsonDecode(response.body);
          if (responseBody['success']) {
            (responseBody['data'] as List).forEach((element) {
              listSearch.add(Shoes.fromJson(element));
            });
          }
        }
      } catch (e) {
        print(e);
      }
    }
    return listSearch;
  }

  @override
  void initState() {
    _controllerSearch.text = widget.searchQuery!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Asset.colorPrimary,
        titleSpacing: 0,
        title: buildSearch(),
      ),
      body: buildAll(),
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
      padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
      child: TextField(
        controller: _controllerSearch,
        decoration: InputDecoration(
          prefixIcon: IconButton(
            onPressed: () {
              setState(() {});
            },
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
        width: 0,
        color: Asset.colorPrimary,
      ),
    );
  }
}
