import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:clase_3/domain/user.dart';
import 'dart:developer';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  String parameter = 'ale';
  final TextEditingController _inputUser = TextEditingController();
  final TextEditingController _inputPsw = TextEditingController();

  List<User> users = [
    User(
        age: 24,
        id: '0',
        email: 'jpineiro@frba.utn.edu.ar',
        name: 'Joaquin',
        password: '123'),
    User(
        age: 24,
        id: '0',
        email: 'adomnguez@frba.utn.edu.ar',
        name: 'Alejo',
        password: '321'),
    User(
        age: 24,
        id: '0',
        email: 'mmarfisi@frba.utn.edu.ar',
        name: 'Matias',
        password: '213')
  ];

  bool userOk = false;
  bool pswOk = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Login"),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                      hintText: 'Email',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                  controller: _inputUser,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                      hintText: 'Contraseña',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                  controller: _inputPsw,
                ),
              ),
              const SizedBox(height: 29),
              OutlinedButton(
                child: const Text('Ingresar'),
                onPressed: () {
                  for (var element in users) {
                    if (_inputUser.text == element.email) {
                      userOk = true;
                      if (_inputPsw.text == element.password) {
                        parameter = element.name;
                        context.push('/raza/$parameter');
                        pswOk = true;
                        break;
                      } else {
                        pswOk = false;
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Contraseña Incorrecta")));
                        break;
                      }
                    } else {
                      userOk = false;
                    }
                  }
                  if (userOk == false) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Usuario Incorrecto")));
                  }
                  log('Psw: ${_inputPsw.text}');
                  log('User: ${_inputUser.text}');
                },
              )
            ],
          ),
        ));
  }
}
