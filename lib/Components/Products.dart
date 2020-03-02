import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiburon_mobile/Components/CartForm.dart';
import 'package:tiburon_mobile/Components/ShoppingCart.dart';
import 'package:tiburon_mobile/Context/AppContext.dart';
import 'package:tiburon_mobile/Models/Customer.dart';
import 'package:tiburon_mobile/Models/Product.dart';
//import 'package:tiburon_mobile/Components/CartForm.dart';
//import 'package:tiburon_mobile/Components/ShoppingCart.dart';

class Products extends StatefulWidget {
  Products({Key key, this.customer}) : super(key: key);
  final Customer customer;
  @override
  _ProductsState createState() => _ProductsState(customer: customer);
}

class _ProductsState extends State<Products> with TickerProviderStateMixin {
  _ProductsState({this.customer});
  Customer customer;
  final TextEditingController _controller = TextEditingController();
  bool _searching = false;
  Widget _searchWidget;
  String searchText = '';

  List<Widget> productsList(AppContext appContext) {
    List<Widget> items = List();
    List<Product> products = List();
    if(searchText.isNotEmpty) {
      products = appContext.products.where((product) => product.product_name.toString().toLowerCase().contains(searchText)).toList();
    } else {
      products = appContext.products;
    }
    items = products.map((product) => Container(
      child: FlatButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => Provider.value(value: appContext, child: CartForm(customer: appContext.customer, product: product,),)));
        },
        child: Text(product.product_name),
      )
    )).toList();
    return items;
  }

  void _setSearchWidget() {
    Widget searchbox = Row(
      key: ValueKey(1),
      children: <Widget>[
        Expanded(
          child: TextField(
          key: ValueKey(1),
          controller: _controller,
          style: TextStyle(
            color: Colors.black,
          ),
          decoration: InputDecoration(
            hintText: "Buscar...",
            hintStyle: TextStyle(color: Colors.grey),
          ),
          onChanged: (text) {
            setState(() {
              searchText = _controller.text;
            });
          },
        ),
        ),
        IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            setState(() {
              _searching = false;
                _controller.clear();
                this.searchText = '';
                this._setSearchWidget();
            });
          },
        )
      ],
    );
    Widget searchIcon = IconButton(
      key: ValueKey(2),
      icon: Icon(Icons.search),
      onPressed: () {
        _searching = true;
        this._setSearchWidget();
      },
    );
    if(_searching) {
      setState(() {
        _searchWidget = searchbox;
      });
    } else {
      setState(() {
        _searchWidget = searchIcon;
      });
    }
  }

  void actualizar(appContext) async {
    await appContext.fetchProducts();
    setState(() {
      
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final appContext = Provider.of<AppContext>(context);
    if(appContext.products.length == 0) {
      actualizar(appContext);
    }
    this._setSearchWidget();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        elevation: 0,
      ),
      body: appContext.products.length == 0 ? 
        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Sin elementos para mostrar'),
              FlatButton(
                child: Text('Reintentar'),
                onPressed: () {
                  appContext.fetchCustomers();
                  setState((){});
                },
              )
            ],
          ),
        )
        :
        Center(
          child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
              child: Icon(Icons.local_drink, color: Color.fromARGB(255, 0, 115, 244), size: 30,),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 15, 0, 5),
              child: Text('Productos', style: TextStyle(fontSize: 25),)
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: _searchWidget,
              )
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(thickness: 1),
            ),
            Expanded(
              child: ListView(
                physics: AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                children: productsList(appContext)
              )
            ),
          ],
        )
      ),
      floatingActionButton: IconButton(
        icon: Icon(Icons.shopping_cart, color: Color.fromARGB(255, 0, 115, 244), size: 30,),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => Provider.value(value: appContext, child: ShoppingCart(customer: customer),)));
        },
      ),
    );
  }
}

