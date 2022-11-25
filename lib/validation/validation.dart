import 'package:task1/app_utils/app_strings.dart';

validateEmail(String email) {
  final emailReg = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
  return emailReg.hasMatch(email);
}

validatePassword(String password) {
  String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$';
  final passwordReg = RegExp(pattern);
  return passwordReg.hasMatch(password);
}
validateName(String? value){
  if(value!.length<4){
    return validNameLength;
  }
}


// validateGender(int radioValue){
//   if (radioValue<0){
//     const Text("select gender");
//   }
// }