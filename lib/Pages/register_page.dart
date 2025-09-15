import 'package:chat_app/Auth/authservice.dart';
import 'package:chat_app/Components/textfield.dart';
import 'package:flutter/material.dart';

import '../Components/mybutton.dart';

class RegisterPage extends StatelessWidget {

  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final TextEditingController _confirmpasswordcontroller = TextEditingController();

  final void Function()? onTap;

  RegisterPage({super.key,required this.onTap});

  void register(BuildContext context){
    final _auth = AuthService();

    if (_passwordcontroller.text == _confirmpasswordcontroller.text){
      try {
        _auth.signupWithEmailPassword(_emailcontroller.text, _passwordcontroller.text);
      }
      catch(e){
        showDialog(context: context, builder: (context) => AlertDialog(
          title: Text(e.toString()),
        ));
      }
    }
    else{
      showDialog(context: context, builder: (context) => const AlertDialog(
        title: Text("Password dont match!")
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
              Icon(Icons.message,size: 60, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 50),
              Text("lets create an account for you",style: TextStyle(
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
                  hintText: "Password",),
              ),
          
              const SizedBox(height: 10),
          
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: MyTextField(
                  controller: _confirmpasswordcontroller,
                  obscureText: true,
                  hintText: "Confirm Password",),
              ),
          
              const SizedBox(height: 40),
          
              Mybutton(
                onTap: () => register(context),
                text: "Register",
              ),
          
              const SizedBox(height: 15),
          
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?",style: TextStyle(color: Theme.of(context).colorScheme.primary),),
                  GestureDetector(
                    onTap: onTap,
                    child: Text("Log in Now",style: TextStyle(
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

