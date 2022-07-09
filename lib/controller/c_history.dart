import 'package:ecommerce_shoes/model/order.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class CHistory extends GetxController {
  RxList<Order> _list = <Order>[].obs;
  RxList<int> _selected = <int>[].obs;

  List<Order> get list => _list.value;
  List<int> get selected => _selected.value;

  setList(List<Order> newList) => _list.value = newList;
  addSelected(int newIdOrder) {
    _selected.value.add(newIdOrder);
    update();
  }

  deleteSelected(int idOrder) {
    _selected.value.remove(idOrder);
    update();
  }

  selectedClear() {
    _selected.value.clear();
    update();
  }
}
