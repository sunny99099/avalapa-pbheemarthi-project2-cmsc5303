import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:lesson6/controller/auth_controller.dart';
import 'package:lesson6/view/sign_in_screen.dart';

class SignInController{
  SignInState state;
  SignInController(this.state);

  Future<void> signIn() async{
    FormState? currentState = state.formKey.currentState;
    if(currentState == null) return;
    if(!currentState.validate()) return;
    currentState.save();

    try{
      await firebaseSignIn(email: state.model.email!, password: state.model.password!,);

    } 
    on FirebaseAuthException catch(e){
      var error = "Sigh in erro! Reason ${e.code} ${e.message}";
      print("==========$error");
    }
    catch(e){ 
      print("================= sign in error: $e");
    }
  }
}