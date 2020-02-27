import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiburon_mobile/Components/CustomerScreen.dart';
import 'package:tiburon_mobile/Context/AppContext.dart';
import 'package:tiburon_mobile/Screen/App.dart';
import 'package:tiburon_mobile/Screen/LoginScreen.dart';
import 'package:tiburon_mobile/Screen/LoadingScreen.dart';

void main() {
  Provider.debugCheckInvalidValueType = null;
  runApp(MyApp());
  } 

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  ChangeNotifierProvider<AppContext>(
      create: (BuildContext context) => AppContext(),
      child: MaterialApp(

        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/customers':
              return CupertinoPageRoute(
                builder: (_) => App(),
                settings: settings
              );
            case '/customer':
              return CupertinoPageRoute(
                builder: (_) => CustomerScreen(),
                settings: settings
              );
          }
        },
        title: 'Tiburón',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Tiburón'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin{
  Widget _bodyWidget;

  _MyHomePageState() {
    _bodyWidget = LoadingScreen();
    setBody();
  }

  Widget loading() {
    return LoadingScreen();
  }

  void setBody() async {
    if(await isLogged()) {
      setState(() {
        _bodyWidget = App();
      });
    } else {
      setState(() {
        _bodyWidget = LoginScreen();
      });
    }
  }

  Future<bool> isLogged() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String personal_name = prefs.getString('personal_name');
    int personal_id = prefs.getInt('personal_id');
    if(personal_name != '' && personal_name != null) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _bodyWidget,
    );
  }
}
