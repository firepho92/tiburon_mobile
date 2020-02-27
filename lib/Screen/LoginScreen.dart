import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiburon_mobile/Context/AppContext.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  _fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);  
  }

  @override
  Widget build(BuildContext context) {
    final appContext = Provider.of<AppContext>(context);
    final FocusNode _usernameNode = FocusNode();
    final FocusNode _passwordNode = FocusNode();
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Entrar'),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: appContext.isAuthWaiting ? 
          Center(
            child: (
              CircularProgressIndicator()
            ),
          )
          :
          Form(
            key: _formKey,
            child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Usuario',
                    fillColor: Colors.white,
                    border: InputBorder.none
                  ),
                  validator: (value) {
                    if(value.isEmpty) {
                      return 'Ingresa un usuario';
                    }
                    return null;
                  },
                  controller: userController,
                  focusNode: _usernameNode,
                  onFieldSubmitted: (term) {
                    _fieldFocusChange(context, _usernameNode, _passwordNode);
                  },
                ),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    border: InputBorder.none
                  ),
                  validator: (value) {
                    if(value.isEmpty) {
                      return 'Ingresa contraseña';
                    }
                    return null;
                  },
                  controller: passwordController,
                  focusNode: _passwordNode,
                ),             
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Builder(
                    builder: (context) => FlatButton(
                      onPressed: () {
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus) { 
                          currentFocus.unfocus(); 
                        }
                        if(_formKey.currentState.validate()) {
                          appContext.login(userController.text, passwordController.text, _scaffoldKey);
                        }
                      },
                      child: Text('Entrar'),
                    ),
                  )
                )
              ],
            ),
          )
        )
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

