import 'package:tiburon_mobile/Models/CartItem.dart';

class Cart {
  List<CartItem> _items = new List();

  List<CartItem> get items => _items;

  void addItem(CartItem item) {
    _items.add(item);
  }

  void removeItem(CartItem item) {
    int index = _items.indexWhere((cartItem) => cartItem.product == item.product);
    _items.removeAt(index);
  }

  List<Map> getItemsAsMap() {
    List<Map> list = List();
    list = _items.map((item) => item.getCartAsMap()).toList();
    return list;
  }

  void setIVA(bool state) {
    _items.forEach((item) => item.iva = state ? 1 : 0);
  }

  void emptyCart() {
    _items.clear();
  }
}