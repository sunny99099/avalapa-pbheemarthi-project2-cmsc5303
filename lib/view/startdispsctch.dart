import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:lesson6/controller/auth_controller.dart';
import 'package:lesson6/view/home_screen.dart';
import 'package:lesson6/view/sign_in_screen.dart';

class Startdispsctch extends StatelessWidget{
  const Startdispsctch({super.key});

  static const routeName = "/Startdispatcher";

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      initialData: null,
      builder: (BuildContext context, AsyncSnapshot snapshot){
          currentUser = snapshot.data;
          return currentUser == null ? SignInScreen() : HomeScreen();
        },
      );
  }

}