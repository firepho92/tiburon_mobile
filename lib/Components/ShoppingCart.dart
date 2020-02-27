import 'package:flutter/material.dart';
import 'package:tiburon_mobile/Models/Email.dart';
import 'package:tiburon_mobile/Models/Customer.dart';
import 'package:provider/provider.dart';
import 'package:tiburon_mobile/Context/AppContext.dart';
import 'package:barcode_scan_fix/barcode_scan.dart';
import 'package:tiburon_mobile/Screen/LoadingScreen.dart';
//import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class ShoppingCart extends StatefulWidget {
  ShoppingCart({Key key, this.customer}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final Customer customer;

  @override
  _ShoppingCartState createState() => _ShoppingCartState(customer: this.customer);
}

class _ShoppingCartState extends State<ShoppingCart> {
  bool _iva = false;
  final Customer customer;
  bool _wait = false;
  String _dialogText = '';
  bool _loading = false;
  bool failedMail = false;
  
  _ShoppingCartState({this.customer});

  void _onIvaChange(bool value) => setState(() => _iva = value);

  double _getSubtotal(double price, double amount) {
    double total = 0;
    if(_iva == true)
      total = amount * price + (amount * price * 0.16);
    else
      total = amount * price;
    return total;
  }

  double _getTotal(AppContext appContext) {
    double total = 0;
    total = appContext.cart.items.fold(0, (curr, product) => curr + product.selling_price * product.ammount);
    if(_iva)
      total += total * 0.16;
    return total;
  }

  double _calculateIVA(double _total) {
    double iva = 0;
    if(_iva)
      iva = _total * 0.16;
    return iva;
  }

  Future<bool> scan(_scaffoldKey) async {
    String result = await BarcodeScanner.scan();
    print(result);
    if(result == customer.customer_id.toString()) {
      return true;
    } else {
      return false;
    }
  }

  Widget loadingWidget() {
    return Scaffold(
      body: Center(
        child: _wait ? CircularProgressIndicator()
        :
        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(_dialogText),
              FlatButton(
                child: Text('Aceptar'),
                onPressed: () {
                  setState(() {
                    _loading = false;
                    Navigator.popUntil(context, ModalRoute.withName('/customer'));
                  });
                },
              )
            ],
          ),
        )
      ),
    );
  }

  void finishSale(_scaffoldKey, AppContext appContext, context) async {
    setState(() {
      _wait = true;
      _loading = true;
    });
    if(customer.qr == 2) {//arreglar a igualar a 1
      if(await scan(_scaffoldKey)) {
        if(await appContext.sendSale()) {
          Email email = Email(this._emailContent(appContext), 'Notificación de venta');
          await email.sendMessage();
          appContext.cart.emptyCart();
          setState(() {
            _wait = false;
            _dialogText = 'Venta exitosa';
          });
        }
      } else {
        print('error');
      }
    } else {
      if(await appContext.sendSale()) {
          Email email = Email(this._emailContent(appContext), 'Notificación de venta');
          await email.sendMessage();
          appContext.cart.emptyCart();
          setState(() {
            _wait = false;
            _dialogText = 'Venta exitosa';
          });
        }
    }
    
  }

  String _emailContent(AppContext appContext) {
    String tableRows = "";
    double total = 0;
    double subtotal = 0;
    appContext.cart.items.forEach((item) => subtotal += item.ammount * item.selling_price);
    appContext.cart.items.forEach((item) => total += item.ammount * item.selling_price + (item.selling_price * item.ammount * 0.16));
    appContext.cart.items.forEach((item) => tableRows += """
    <tr>
      <td style="border: 1px solid #ddd; text-align: left; padding: 5px">${item.product.product_name}</td>
      <td style="border: 1px solid #ddd; text-align: left; padding: 5px">${item.selling_price}</td>
      <td style="border: 1px solid #ddd; text-align: left; padding: 5px">${item.ammount}</td>
      <td style="border: 1px solid #ddd; text-align: left; padding: 5px">${item.selling_price * item.ammount}</td>
    </tr>""");
    String content = """
      <h3> Cerveza artesanal Tiburón. ${DateTime.now()} """ + customer.customer_name + """ </h3>
          <table style="border: 1px solid #ddd; text-align: left" text-align="left" cellpadding="0" cellspacing="0" width="100%">
            <tr>
              <th style="border: 1px solid #ddd; text-align: left; padding: 5px">Producto</th>
              <th style="border: 1px solid #ddd; text-align: left; padding: 5px">PU</th>
              <th style="border: 1px solid #ddd; text-align: left; padding: 5px">Importe</th>
            </tr>
            """ + tableRows + """
            <tr>
              <td></td>
              <td></td>
              <td style="border: 1px solid #ddd; text-align: left; padding: 5px">Subtotal</td>
              <td style="border: 1px solid #ddd; text-align: left; padding: 5px">${subtotal}</td>
            </tr>
            <tr>
              <td></td>
              <td></td>
              <td style="border: 1px solid #ddd; text-align: left; padding: 5px">Total</td>
              <td style="border: 1px solid #ddd; text-align: left; padding: 5px">${appContext.cart.items[0].iva == 1 ? total : subtotal}</td>
            </tr>
            
          </table>

      """;
      return content;

  }

  @override
  Widget build(BuildContext context) {
    final appContext = Provider.of<AppContext>(context);
    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
    return _loading ? loadingWidget()
      : 
      Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black
          ),
          elevation: 0,
          centerTitle: true,
          title: Text('Carrito', style: TextStyle(color: Colors.black),),
          actions: <Widget>[
            Center(
              child: Text('IVA', style: TextStyle(color: Colors.black),),
            ),
            Checkbox(
              value: _iva,
              onChanged: _onIvaChange,
              activeColor: Color.fromARGB(255, 0, 115, 244),
            )
          ],
        ),
        body: ListView.builder(
          itemCount: appContext.cart.items.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              elevation: 0,
              child: ListTile(
                contentPadding: EdgeInsets.all(10.0),
                title: Text(appContext.cart.items[index].product.product_name),
                subtitle: Text('Precio: \$' + appContext.cart.items[index].selling_price.toString() + '\nUnidades: ' + appContext.cart.items[index].ammount.toString() + '\nSubtotal: \$' + _getSubtotal(appContext.cart.items[index].selling_price, appContext.cart.items[index].ammount).toString()),
                trailing: IconButton(
                  icon: Icon(Icons.remove_shopping_cart),
                  onPressed: () {
                    appContext.cart.removeItem(appContext.cart.items[index]);
                    setState(() {});
                  },
                ),
                onTap: () {},
              ),
            );
          },
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Color(0xFFFFFFFF),
          ),
          child: ListTile(
            subtitle: Text('IVA: \$' + _calculateIVA(_getTotal(appContext)).toStringAsFixed(2), style: TextStyle(fontSize: 18),),
            title: Text('Total: \$' + _getTotal(appContext).toString(), style: TextStyle(fontSize: 18),),
            trailing: IconButton(
              icon: Icon(Icons.send),
              color: Color.fromARGB(255, 0, 115, 244),
              onPressed: () {
                appContext.cart.setIVA(_iva);
                finishSale(_scaffoldKey, appContext, context);
              },
            ),
          ),
        ),
      floatingActionButton: IconButton(
        icon: Icon(Icons.delete_outline, color: Color.fromARGB(255, 0, 115, 244)),
        onPressed: () {
          appContext.cart.emptyCart();
          setState(() {});
        },
      )
    );
  }
  
}
