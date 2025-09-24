import 'package:chat_app/Auth/authservice.dart';
import 'package:chat_app/Components/mybutton.dart';
import 'package:flutter/material.dart';
import '../Components/textfield.dart';
import 'dart:async';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();

  bool isLoading = false;

  void login() async {
    setState(() {
      isLoading = true; // show progress indicator
    });

    // Show the progress indicator for 3 seconds
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false; // hide progress indicator
    });

    final authService = AuthService();

    try {
      await authService.signInWithEmailPassword(
          _emailcontroller.text, _passwordcontroller.text);
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(e.toString()),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.message,
                  size: 60, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 50),
              Text(
                "Welcome back, you've been missed!",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 17),
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: MyTextField(
                  controller: _emailcontroller,
                  obscureText: false,
                  hintText: "Email",
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: MyTextField(
                  controller: _passwordcontroller,
                  obscureText: true,
                  hintText: "Password",
                ),
              ),
              const SizedBox(height: 40),

              // Show either the button or the loading indicator
              isLoading
                  ? const CircularProgressIndicator()
                  : Mybutton(
                onTap: login,
                text: "Log in",
              ),

              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Not a member?",
                    style: TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(
                      "Register Now",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
