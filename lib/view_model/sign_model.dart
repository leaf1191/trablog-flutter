import 'package:trablog/const/const_value.dart';
import 'package:flutter/material.dart';
import 'package:trablog/singleton/storage.dart';
import 'package:trablog/singleton/http.dart';
import 'dart:convert';

class SignModel extends ChangeNotifier {
  SignModel(this.con1,this.con2, {this.con3});

  late final TextEditingController con1;
  late final TextEditingController con2;
  late final TextEditingController? con3;
  final _key = GlobalKey<FormState>();
  bool _remember = false;

  bool get remember => _remember;
  GlobalKey<FormState> get key => _key;

  signInInit() async{
    _remember = await (Storage.pref!.getBool('remember') ?? false);
    con1.text = await (Storage.pref!.getString('id') ?? '');
    notifyListeners();
  }

  signIn() async {
    if(_remember == true){
      await Storage.pref!.setString('id', con1.text);
    }
    Map<String,String> mapData = {
      'id' : con1.text,
      'password' : con2.text,
    };
    var response = await trabDio.post(SIGN_IN,queryParameters: mapData);
    var data = json.decode(response.toString());
    await Storage.pref!.setString('accessToken', data['token']);
  }

  signUp() async{
    Map<String,String> mapData = {
      'name' : con1.text,
      'username' : con2.text,
      'password' : con3!.text,
      'role' : 'ROLE_USER',
    };
    var response = await trabDio.post(SIGN_UP,queryParameters: mapData);
    var data = json.decode(response.toString());
    await Storage.pref!.setString('accessToken', data['token']);
  }

  rememberEmail() async {
    _remember = !_remember;
    await Storage.pref!.setBool('remember', _remember);

    if(_remember == false){
      await Storage.pref!.remove('id');
    }
    notifyListeners();
  }


}