import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiburon_mobile/Models/CartItem.dart';
import 'package:tiburon_mobile/Models/Product.dart';
import 'package:tiburon_mobile/Models/Customer.dart';
import 'package:provider/provider.dart';
import 'package:tiburon_mobile/Context/AppContext.dart';

class CartForm extends StatefulWidget {
  CartForm({Key key, this.product, this.customer}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final Product product;
  final Customer customer;
  @override
  _CartFormState createState() => _CartFormState(customer: customer, product: product);
}

class _CartFormState extends State<CartForm> {
  _CartFormState({this.customer, this.product});
  final _formKey = GlobalKey<FormState>();
  final Customer customer;
  final Product product;

  TextEditingController sellingPriceController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  
  void initState() {
    super.initState();
    sellingPriceController.text = product.selling_price.toString();
  }

  double _getTotal() {
    if(sellingPriceController.text != '' && amountController.text != '') {
      double amount = double.parse(amountController.text);
      double price = double.parse(sellingPriceController.text);
      double total = 0;
      total = amount * price;
      return total;
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appContext = Provider.of<AppContext>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        title: Text(product.product_name, style: TextStyle(color: Colors.black),),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Unidades'
                      ),
                      validator: (value) {
                        if(value.isEmpty) {
                          return 'Unidades a vender';
                        }
                        return null;
                      },
                      controller: amountController,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Precio de venta'
                      ),
                      validator: (value) {
                        if(value.isEmpty) {
                          return 'Ingresa un precio';
                        }
                        return null;
                      },
                      controller: sellingPriceController,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Builder(
                      builder: (context) => RaisedButton(
                        child: Text('Agregar al carrito'),
                        onPressed: () async {
                          if(_formKey.currentState.validate()) {
                            var now = DateTime.now();
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            int personal_id = prefs.getInt('personal_id');
                            CartItem item = CartItem(movement_date: now.toString(), customer: customer, person: personal_id, product: product, ammount: double.parse(amountController.text), selling_price: double.parse(sellingPriceController.text), cost_price: product.cost_price, movementType: 4, description: '');
                            appContext.cart.addItem(item);
                            Navigator.pop(context);
                          }
                        },
                      ),
                    )
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
}