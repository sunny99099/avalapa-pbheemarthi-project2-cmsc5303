class  SignInModel {
  String? email;
  String? password;
  bool inProgress = false;

  String? validateEmail(String? value){
    if(value == null || value.isEmpty){
      return 'No email provided';
    }
    else if (!(value.contains('@') && value.contains('.'))){
      return 'Invalid Email Address';
    }
    else {
      return null;
    }
  }

  String? validatePassword(String? value){
    if(value == null || value.isEmpty){
      return 'No Password Provided';
    }
    else if (value.length < 6){
      return 'Min chars is 6';
    }
    else {
      return null;
    }
  }

  void saveEmail(String? value){
    if (value != null) email = value;
  }

  void savePassword(String? value){
    if (value != null) password = value;
  }


}