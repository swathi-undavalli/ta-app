import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  static const String id = "LoginView";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/AppLogoPondy.png',
                height: 100,
                width: 100,
              ),
              SizedBox(height: 20),
              Text(
                "Log In",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter a search term',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
