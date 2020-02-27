import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:tiburon_mobile/Models/Product.dart';
import 'package:tiburon_mobile/Models/Customer.dart';
import 'package:tiburon_mobile/Models/Movement.dart';
import 'package:tiburon_mobile/Models/Deposit.dart';
import 'package:tiburon_mobile/Models/Person.dart';
import 'package:tiburon_mobile/Models/Cart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppContext with ChangeNotifier {
  var _prefs = SharedPreferences.getInstance();
  int _isLoading = 0;
  final String _serverIP = 'http://177.246.237.217:8000';//'http://177.246.228.199:8000';
  List<Product> _products = List();
  List<Customer> _customers = List();
  List<Movement> _movements = List();
  List<Deposit> _deposits = List();
  Cart cart = Cart();
  Person _person;
  Customer _customer;
  bool _logged = false;
  bool _waiting = false;
  bool _loading = false;

  AppContext() {
    //init();
  }

  /*init() async {
    if(await fetchProducts() && await fetchCustomers()) {
      _isLoading = 1;
    } else {
      _isLoading = 2;
    }
    await getLoggedUser();
    notifyListeners();
  }*/

  List<Product> get products => _products;
  List<Customer> get customers => _customers;
  List<Movement> get movements => _movements;
  List<Deposit> get deposits => _deposits;

  int get isLoading => _isLoading;
  bool get logged => _logged;
  bool get isAuthWaiting => _waiting;
  Person get person => _person;
  bool get loading => _loading;
  Customer get customer => _customer;

  set customer(Customer customer) {this._customer = customer;}
  set loading(bool loading) {this._loading = loading;}

  void setLogged(state) {
    _logged = state;
    notifyListeners();
  }

  Future<bool> isLogged() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int personal_id = prefs.getInt('personal_id');
    String alias = prefs.getString('alias');
    String personal_name = prefs.getString('personal_name');
    if(personal_name != '' && personal_name != null) {
      _person = Person.persistent(personal_id: personal_id, personal_name: personal_name, alias: alias);
      _logged = true;
      return true;
    }
    return false;
  }

  void login(alias, password, GlobalKey<ScaffoldState> _scaffoldKey) async {
    _waiting = true;
    notifyListeners();
    Dio client = Dio();
    client.options.connectTimeout = 5000;
    client.options.responseType = ResponseType.plain;
    Response response;

    try{
      response = await client.post(_serverIP + '/auth', data: {"alias": alias, "password": password});
      var p = (json.decode(response.data) as List).map((data) => Person.fromJson(data)).toList();
      if(p.isNotEmpty) {
        _person = p[0];
        final SharedPreferences prefs = await _prefs;
        prefs.setInt('personal_id', _person.personal_id);
        prefs.setString('alias', _person.alias);
        prefs.setString('personal_name', _person.personal_name);
      } else {
        _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Error: Usuario o contraseña incorrectos.'),));
        _waiting = false;
        notifyListeners();
      }
    } on TimeoutException {
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Error: No se puede conectar con el servidor.'),));
      _waiting = false;
      print('error de conexión');
    } on Exception catch(e) {
      print('error general: '+ e.toString());
    }

    if(response.statusCode == 200) {
      _logged = true;
      _waiting = false;
      notifyListeners();
    }

    _waiting = false;
    notifyListeners();
  }

  Future<bool> fetchProducts() async {
    Dio client = Dio();
    client.options.connectTimeout = 5000;
    client.options.responseType = ResponseType.plain;
    Response response;
    try {
      response = await client.get(_serverIP + '/products');
      _products = (json.decode(response.data) as List).map((data) => Product.fromJson(data)).toList();
      notifyListeners();
    } on TimeoutException {
      print('error de conexión');
      return false;
    } on Exception catch(e) {
      print('error general: '+ e.toString());
      return false;
    } finally {
      notifyListeners();
    }

    if(response.statusCode == 200) {
      notifyListeners();
      return true;
    }
    notifyListeners();
    return false;
  }

  fetchCustomers() async {
    Dio client = Dio();
    client.options.connectTimeout = 5000;
    client.options.responseType = ResponseType.plain;
    Response response;
    try {
      response = await client.get(_serverIP + '/customers');
      _customers = (json.decode(response.data) as List).map((data) => Customer.fromJson(data)).toList();
    } on TimeoutException {
      print('error de conexión');
      return false;
    } on Exception catch(e) {
      print('error general: '+ e.toString());
      return false;
    }

    if(response.statusCode == 200) {
      notifyListeners();
      return true;
    }
  }

  Future<String> fetchDebt() async {
    Dio client = Dio();
    client.options.connectTimeout = 3000;
    client.options.responseType = ResponseType.plain;
    Response response;
    try {
      response = await client.post(_serverIP + '/sales/debt', data: {'customer_id': customer.customer_id});
      print(response.data);
      return 'hola';
    } on TimeoutException {
      print('error de conexión');
      return 'adios';
    } on Exception catch(e) {
      print('error general: '+ e.toString());
      return 'adios';
    }
  }

  fetchMovements() async {
    Dio client = Dio();
    client.options.connectTimeout = 3000;
    client.options.responseType = ResponseType.plain;
    Response response;
    try {
      response = await client.get(_serverIP + '/sales?movementType=4');
      _movements = (json.decode(response.data) as List).map((data) => Movement.fromJson(data)).toList();
    } on TimeoutException {
      print('error de conexión');
      return false;
    } on Exception catch(e) {
      print('error general: '+ e.toString());
      return false;
    }

    if(response.statusCode == 200) {
      return true;
    }
  }

  fetchDeposits() async {
    Dio client = Dio();
    client.options.connectTimeout = 3000;
    client.options.responseType = ResponseType.plain;
    Response response;
    try {
      response = await client.get(_serverIP + '/deposits');
      _deposits = (json.decode(response.data) as List).map((data) => Deposit.fromJson(data)).toList();
    } on TimeoutException {
      print('error de conexión');
      return false;
    } on Exception catch(e) {
      print('error general: '+ e.toString());
      return false;
    }

    if(response.statusCode == 200) {
      return true;
    }
  }

  Future<bool> sendSale() async {
    List<Map> items = cart.getItemsAsMap();
    Dio client = Dio();
    client.options.connectTimeout = 3000;
    client.options.responseType = ResponseType.plain;
    Response response;
    try {
      response = await client.post(_serverIP + '/sales/many', data: {"data": items});
    } on TimeoutException {
      print('error de conexión');
      return false;
    } on Exception catch(e) {
      print('error general: '+ e.toString());
      return false;
    }

    if(response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> sendDeposit(Map<String, dynamic> deposit) async {
    Dio client = Dio();
    client.options.connectTimeout = 3000;
    client.options.responseType = ResponseType.plain;
    Response response;
    try {
      response = await client.post(_serverIP + '/deposits', data: {'deposit': deposit});
    } on TimeoutException {
      print('Error de conexión');
      return false;
    } on Exception catch(e) {
      print(e.toString());
      return false;
    }

    if(response.statusCode == 200) {
      return true;
    }
    return false;
  }
}