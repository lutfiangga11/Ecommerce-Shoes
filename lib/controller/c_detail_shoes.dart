import 'package:get/get.dart';

class CDetailShoes extends GetxController {
  RxBool _isWhislit = false.obs;
  RxInt _quantity = 1.obs;
  RxInt _size = 0.obs;
  RxInt _color = 0.obs;

  bool get isWhislit => _isWhislit.value;
  int get quantity => _quantity.value;
  int get size => _size.value;
  int get color => _color.value;

  setIsWhislist(bool newIsWhislist) => _isWhislit.value = newIsWhislist;
  setQuantity(int newQuantity) => _quantity.value = newQuantity;
  setSize(int newSize) => _size.value = newSize;
  setColor(int newColor) => _color.value = newColor;
}
