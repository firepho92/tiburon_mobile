import 'package:flutter/material.dart';
import 'package:tiburon_mobile/Models/Deposit.dart';
import 'package:tiburon_mobile/Models/Customer.dart';
import 'package:provider/provider.dart';
import 'package:tiburon_mobile/Context/AppContext.dart';
import 'package:tiburon_mobile/Models/Email.dart';

class DepositsForm extends StatefulWidget {
  DepositsForm({Key key, this.customer}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final Customer customer;
  @override
  _DepositsFormState createState() => _DepositsFormState(customer: customer);
}

class _DepositsFormState extends State<DepositsForm> {
  _DepositsFormState({this.customer});
  final _formKey = GlobalKey<FormState>();
  final Customer customer;
  String _cash;
  bool _sale_type = false;

  TextEditingController amountController = TextEditingController();
  void _onSaleTypeChange(bool value) => setState(() => _sale_type = value);

  void _showDialog(msg, context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("Notificación"),
          content: Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text("Aceptar"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  String _emailContent(AppContext appContext) {
    String content = """
      <h3> Cerveza artesanal Tiburón. ${DateTime.now()} """ + customer.customer_name + """ </h3>
          <table style="border: 1px solid #ddd; text-align: left" text-align="left" cellpadding="0" cellspacing="0" width="100%">
            <tr>
              <th style="border: 1px solid #ddd; text-align: left; padding: 5px">Monto</th>
              <th style="border: 1px solid #ddd; text-align: left; padding: 5px">Tipo de pago</th>
            </tr>
            <tr>
              <td style="border: 1px solid #ddd; text-align: left; padding: 5px">${amountController.text}</td>
              <td style="border: 1px solid #ddd; text-align: left; padding: 5px">${_cash}</td>
            </tr>
          </table>

      """;
    return content;
  }


  void _finishDeposit(AppContext appContext, Map<String, dynamic> deposit, context) async {
    if(await appContext.sendDeposit(deposit)) {
      appContext.fetchDeposits();
      appContext.fetchMovements();
      Email email = Email(this._emailContent(appContext), 'Notificación de depósito');
      await email.sendMessage();
      _showDialog('Agregado con éxito', context);
    } else {
      _showDialog('Error, intentar de nuevo', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appContext = Provider.of<AppContext>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(customer.customer_name + ' nuevo depósito'),
      ),
      body: Center(
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
                      labelText: 'Monto'
                    ),
                    validator: (value) {
                      if(value.isEmpty) {
                        return 'Cantidad a depositar';
                      }
                      return null;
                    },
                    controller: amountController,
                  ),
                ),
                DropdownButton<String>(
                  hint: Text('Tipo de pago'),
                  value: _cash,
                  icon: Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  underline: Container(
                    height: 2,
                    color: Colors.blue,
                  ),
                  onChanged: (String cash) {
                    setState(() {
                      _cash = cash;
                    });
                  },
                  items: <String>['Efectivo', 'Depósito']
                    .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    })
                    .toList(),
                ),
                CheckboxListTile(
                  value: _sale_type,
                  onChanged: _onSaleTypeChange,
                  title: Text('Consignación'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Builder(
                    builder: (context) => RaisedButton(
                      child: Text('Agregar pago'),
                      onPressed: () {
                        if(_formKey.currentState.validate()) {
                          var now = DateTime.now();
                          Deposit deposit = Deposit(deposit_date: now.toString(), payment_type: _cash == 'Efectivo' ? 0 : 1, sale_type: _sale_type ? 1 : 0, customer: customer.customer_id, ammount: amountController.text, );
                          _finishDeposit(appContext, deposit.getAsMap(), context);
                          //Navigator.pop(context);
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
    );
  }
  
}