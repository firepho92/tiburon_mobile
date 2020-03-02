import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiburon_mobile/Context/AppContext.dart';
import 'package:tiburon_mobile/Components/Customers.dart';

class App extends StatefulWidget {
  App({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {

  Widget body(AppContext appContext) {
    if(appContext.customers.length == 0) {
      return Scaffold(
        body: Center(
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
        ),
      );
    } else {
      return Customers();
    }
  }


  @override
  Widget build(BuildContext context) {
    final appContext = Provider.of<AppContext>(context);
    if(appContext.customers.length == 0)
      appContext.fetchCustomers();
    return body(appContext);
  }
}