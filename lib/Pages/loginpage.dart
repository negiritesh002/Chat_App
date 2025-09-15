import 'package:chat_app/Auth/authservice.dart';
import 'package:chat_app/Components/mybutton.dart';
import 'package:flutter/material.dart';
import '../Components/textfield.dart';

class LoginPage extends StatelessWidget {

  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();

  final void Function()? onTap;

  LoginPage({super.key,required this.onTap});

  void login(BuildContext context)async{
    final authService = AuthService();

  try {
    await authService.signInWithEmailPassword(_emailcontroller.text, _passwordcontroller.text);
  }

  catch(e){
    showDialog(context: context, builder: (context) => AlertDialog(
      title: Text(e.toString()),
    ));
  }}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.message,size: 60, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 50),
              Text("Welcome back, you've been missed!",style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 17
              ),),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: MyTextField(
                  controller: _emailcontroller,
                  obscureText: false,
                  hintText: "Email",),
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

              Mybutton(
                onTap: () => login(context),
                text: "Log in",
              ),

              const SizedBox(height: 15),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Not a member?",style: TextStyle(color: Theme.of(context).colorScheme.primary),),
                  GestureDetector(
                    onTap: onTap,
                    child: Text("Register Now",style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold
                    ),),
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
