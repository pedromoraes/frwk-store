import 'package:flutter/material.dart';

loginPage(BuildContext context, data) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Login'),
    ),
    body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(20.0),
        child: Form(
            child: Column(children: [
          Padding(
            padding: EdgeInsets.all(20.0),
            child: TextFormField(
                decoration: InputDecoration(labelText: 'Username')),
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: TextFormField(
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password')),
          ),
          Padding(
              padding: EdgeInsets.all(20.0),
              child: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(30.0),
                color: Color(0xff01A0C7),
                child: MaterialButton(
                  minWidth: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  onPressed: () {
                    data.login = true;
                    Navigator.pushNamed(context, '/checkout');
                  },
                  child: Text("Login", textAlign: TextAlign.center),
                ),
              )),
        ]))),
  );
}
