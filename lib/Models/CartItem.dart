import 'package:tiburon_mobile/Models/Product.dart';
import 'package:tiburon_mobile/Models/Customer.dart';

class CartItem {
  String movement_date;
  Customer customer;
  int person;
  Product product;
  double ammount;//how many items
  double selling_price;
  double cost_price;
  int iva;
  int movementType;
  String description;

  CartItem({this.movement_date, this.customer, this. person, this.product, this.ammount, this.selling_price, this.cost_price, this.iva, this.movementType, this.description});

  Map<String, dynamic> getCartAsMap() {
    return {
      "movement_date": this.movement_date,
      "customer": this.customer.customer_id,
      "person": this.person,
      "product": this.product.product_id,
      "amount": this.ammount,
      "selling_price": this.selling_price,
      "cost_price": this.cost_price,
      "iva": this.iva,
      "cash": 0,
      "movementType": this.movementType,
      "sale_type": 0,
      "description": this.description
      };
  }
}