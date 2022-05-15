import 'dart:convert';
import 'package:bus_pasajero/pages/home_page.dart';
import 'package:bus_pasajero/services/auth_services.dart';
import 'package:bus_pasajero/services/globals.dart';
import 'package:bus_pasajero/utils/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);
  
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String _name = '';
  String _email = '';
  String _password = '';

  createAccountPressed() async {
    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_email);
    if (emailValid) {
      http.Response response = await AuthServices.register(_name, _email, _password);
      Map responseMap = jsonDecode(response.body);
      if (response.statusCode == 401) {
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (BuildContext context) => const HomePage(),
        ));
      } else {
          errorSnackBar(context, responseMap.values.first[0]);
      }
    } else {
        errorSnackBar(context, 'Email not valid');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/mapa_login.jpg"),
                fit: BoxFit.cover
              )
            ),
          ),
          Positioned(
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Card(
                    elevation: 4.0,
                    color: Colors.white,
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          const SizedBox(height: 20,),
                          TextField(
                            decoration: const InputDecoration(hintText: 'Username'),
                            onChanged: (value) {
                              _name = value;
                            },
                          ),
                          const SizedBox(height: 20,),
                          TextField(
                            decoration: const InputDecoration(hintText: 'Email'),
                            onChanged: (value) {
                              _email = value;
                            },
                          ),
                          const SizedBox(height: 20,),
                          TextField(
                            obscureText: true,
                            decoration: const InputDecoration(hintText: 'Password'),
                            onChanged: (value) {
                              _password = value;
                            },
                          ),
                          const SizedBox(height: 20,),
                          RoundedButton(
                            btnText: 'Sign Up', 
                            onBtnPressed: () => createAccountPressed(),
                          ),
                          const SizedBox(height: 20,)
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          )
        ],
      ),
    );
  }
}