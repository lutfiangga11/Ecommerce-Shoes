import 'package:ecommerce_shoes/model/cart.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class CListCart extends GetxController {
  RxList<Cart> _list = <Cart>[].obs;
  RxList<int> _selected = <int>[].obs;
  RxBool _isSelectedAll = false.obs;
  RxDouble _total = 0.0.obs;

  List<Cart> get list => _list.value;
  List<int> get selected => _selected.value;
  bool get isSelectedAll => _isSelectedAll.value;
  double get total => _total.value;

  setList(List<Cart> newList) => _list.value = newList;
  addSelected(int newIdCart) {
    _selected.value.add(newIdCart);
    update();
  }

  deleteSelected(int newIdCart) {
    _selected.value.remove(newIdCart);
    update();
  }

  setIsSelectedAll() => _isSelectedAll.value = !_isSelectedAll.value;
  selectedClear() {
    _selected.value.clear();
    update();
  }

  setTotal(double newTotal) => _total.value = newTotal;
}
