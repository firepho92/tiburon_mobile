import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiburon_mobile/Components/DepositsForm.dart';
import 'package:tiburon_mobile/Components/Products.dart';
import 'package:tiburon_mobile/Context/AppContext.dart';
import 'package:tiburon_mobile/Models/Customer.dart';
//import 'package:tiburon_mobile/Components/DepositsForm.dart';
//import 'package:tiburon_mobile/Components/Products.dart';
import 'package:tiburon_mobile/Models/Movement.dart';
import 'package:tiburon_mobile/Models/Deposit.dart';

class CustomerScreen extends StatefulWidget {
  //CustomerScreen({Key key, this.customer}) : super(key: key);
  CustomerScreen({Key key}) : super(key: key){
    //this.customer = null;
  }

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  static const routeName = '/customer';
  @override
  _CustomerScreenState createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {

  double _currentDebt(List<Movement> movements, List<Deposit> deposits, customer) {
    List<Movement> _movements = movements.where((movement) => movement.customer == customer.customer_id).toList();
    List<Deposit> _deposits = deposits.where((deposit) => deposit.customer == customer.customer_id).toList();
    var movementsTotal = 0;
    var depositsTotal = 0;

    for(int i = 0; i < _movements.length; i++)
      movementsTotal += _movements[i].selling_price * _movements[i].ammount;
    for(int i = 0; i < _deposits.length; i++)
      depositsTotal += _deposits[i].ammount;
    var debt = movementsTotal - depositsTotal;
    return debt.toDouble();
  }
  
  @override
  Widget build(BuildContext context) {
    final appContext = Provider.of<AppContext>(context);
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(appContext.customer.customer_name, style: TextStyle(color: Colors.black),),
        actions: <Widget>[
          FlatButton(
            child: Text('Agregar pago', style: TextStyle(fontSize: 15, decoration: TextDecoration.underline, color: Color.fromARGB(255, 0, 115, 244)),),
            textColor: Colors.black,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => Provider.value(value: appContext, child: DepositsForm(customer: appContext.customer),)));
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(5),
              child: Container(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Center(
                    child: FutureBuilder(
                      future: appContext.fetchDebt(),
                      builder: (context, snapshot) {
                        if(snapshot.hasData) {
                          return Text(snapshot.data);
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    )
                  )
                )
              )
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: Container(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Calle: ' + appContext.customer.street, style: TextStyle(fontSize: 15), overflow: TextOverflow.ellipsis,),
                      Text('Número: ' + appContext.customer.number, style: TextStyle(fontSize: 15), overflow: TextOverflow.ellipsis),
                      Text('Colonia: ' + appContext.customer.district, style: TextStyle(fontSize: 15), overflow: TextOverflow.fade,),
                      Text('Teléfono: ' + appContext.customer.phone, style: TextStyle(fontSize: 15), overflow: TextOverflow.ellipsis),
                      Text('Email: ' + appContext.customer.email, style: TextStyle(fontSize: 15), overflow: TextOverflow.fade,)
                    ],
                  ),
                )
              )
            ),
          ],
        ),
      ),
      floatingActionButton: IconButton(
        icon: Icon(Icons.shopping_basket, color: Color.fromARGB(255, 0, 115, 244), size: 30,),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => Provider.value(value: appContext, child: Products(customer: appContext.customer),)));
        },
      ),
    );
  }
}

