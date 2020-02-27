import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiburon_mobile/Context/AppContext.dart';
import 'package:tiburon_mobile/Models/Customer.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class Customers extends StatefulWidget {
  Customers({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CustomersState createState() => _CustomersState();
}

class _CustomersState extends State<Customers> {
  String searchText = '';
  Widget appBarTitle = Text('Clientes');
  final TextEditingController _controller = TextEditingController();
  bool _searching = false;
  Widget _searchWidget = null;

  List<Widget> customersList(AppContext appContext) {
    List<Widget> items = List();
    List<Customer> customers = List();
    if(searchText.isNotEmpty) {
      customers = appContext.customers.where((customer) => customer.customer_name.toString().toLowerCase().contains(searchText)).toList();
    } else {
      customers = appContext.customers;
    }
    items = customers.map((customer) => Container(
      child: FlatButton(
        onPressed: () {
          appContext.customer = customer;
          Navigator.pushNamed(context, '/customer');
        },
        child: Text(customer.customer_name),
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

  @override
  Widget build(BuildContext context) {
    this._setSearchWidget();
    final appContext = Provider.of<AppContext>(context);
    var _refreshIndicatorKey;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(0, 60, 0, 5),
              child: Icon(Icons.people_outline, color: Color.fromARGB(255, 0, 115, 244), size: 30,),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 15, 0, 5),
              child: Text('Clientes', style: TextStyle(fontSize: 25),)
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
              child: LiquidPullToRefresh(
                key: _refreshIndicatorKey,
                onRefresh: () => appContext.fetchCustomers(),
                color: Color.fromARGB(255, 0, 115, 244),
                child: ListView(
                  shrinkWrap: true,
                  children: customersList(appContext)
                ),
              )
            ),
          ],
        )
      ),
    );
  }
}