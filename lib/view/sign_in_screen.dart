import 'package:flutter/material.dart';
import 'package:lesson6/controller/sign_in_controller.dart';
import 'package:lesson6/model/sign_in_model.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return SignInState();
  }
}

class SignInState extends State<SignInScreen> {
  late SignInModel model;
  late SignInController con;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    model = SignInModel();
    con = SignInController(this);
  }

  void callSetSate(fn) => callSetSate(fn);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sigh in"),
      ),
      body: model.inProgress ? const CircularProgressIndicator() : signInForm(),
    );
  }

  Widget signInForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  hintText: "Email address",
                ),
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                validator: model.validateEmail,
                onSaved: model.saveEmail,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: "password",
                ),
                obscureText: true,
                autocorrect: false,
                validator: model.validatepassword,
                onSaved: model.savePassword,
              ),
              const SizedBox(height: 2,),
              FilledButton.tonal(
                onPressed: con.signIn,
                child: const Text("Sign in"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
