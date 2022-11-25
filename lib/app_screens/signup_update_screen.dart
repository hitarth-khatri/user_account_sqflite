// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task1/app_screens/login_screen.dart';
import 'package:task1/app_screens/user_screen.dart';
import 'package:task1/app_utils/app_strings.dart';
import 'package:task1/model/user_model.dart';
import 'package:task1/validation/validation.dart';
import 'package:task1/database_helper/db_helper.dart';


class SignupPage extends StatefulWidget {
  final bool? isLoggedin;
  final List? users;
  final int? index;
  const SignupPage({
    Key? key,
    this.isLoggedin,
    this.users,
    this.index,
  }) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final dbHelper = DatabaseHelper.instance;
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  TextEditingController birthController = TextEditingController();

  String gender = "Not Specified";
  int? number;
  String? username;
  String? email;
  String? password;
  String? cPassword;
  bool _obscureTextSet = true;
  bool _obscureTextConfirm = true;
  bool isChecked = false;

  // String? birthDateString;
  String? birthDate;

  var isEnabled = true;
  var radioSelected = false;

  @override
  Widget build(BuildContext context) {
    bool? isLoggedin = widget.isLoggedin;
    List? users = widget.users;
    int? index = widget.index;

    //update text field prefilled data
    if (isLoggedin == true) {
      emailController.text = users![index!].email;
      nameController.text = users[index].username;
      numberController.text = users[index].number.toString();
      birthController.text = users[index].birthDate.toString();
      gender = users[index].gender;
      passController.text = users[index].password;
      confirmPassController.text = users[index].password;
      isEnabled = false;
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(isLoggedin == true ? updateStr : signupStr),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                //email id
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    enabled: isEnabled,
                    autocorrect: false,
                    controller: emailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: emailStr,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return requiredField;
                      }
                      if (!validateEmail(value)) {
                        return enterValidEmail;
                      }
                      return null;
                    },
                  ),
                ),

                //username
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: nameController,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: userStr,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return requiredField;
                      }
                      if (value.length < usernameLength) {
                        return validNameLength;
                      }
                      return null;
                    },
                  ),
                ),

                //phone number
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    autocorrect: false,
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    controller: numberController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: phoneStr,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return requiredField;
                      }
                      if (value.length < 10) {
                        return numberLength;
                      }
                      return null;
                    },
                  ),
                ),

                //Date of birth
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: StatefulBuilder(
                    builder: (context, setState) => InkWell(
                      onTap: () {
                        setState(() {
                          selectDate();
                        });
                      },
                      child: IgnorePointer(
                        child: TextFormField(
                          controller: birthController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.calendar_month),
                            border: OutlineInputBorder(),
                            labelText: birthStr,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return requiredField;
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                ),

                // Gender selection
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: StatefulBuilder(
                    builder: (context, setState) => Column(
                      children: [
                        RadioListTile(
                          title: const Text(maleStr),
                          value: maleStr,
                          groupValue: gender,
                          onChanged: (value) {
                            setState(() {
                              gender = value.toString();
                              radioSelected = true;
                            });
                          },
                        ),
                        RadioListTile(
                          title: const Text(femaleStr),
                          value: femaleStr,
                          groupValue: gender,
                          onChanged: (value) {
                            setState(() {
                              gender = value.toString();
                              radioSelected = true;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                //set password
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: StatefulBuilder(
                    builder: (context,setState) => TextFormField(
                      controller: passController,
                      enableSuggestions: false,
                      obscureText: _obscureTextSet,
                      autocorrect: false,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: setPassStr,
                        helperMaxLines: 8,
                        helperText: helperStr,
                        suffixIcon: IconButton(
                          onPressed: () {
                            _obscureTextSet = !_obscureTextSet;
                            setState(() {});
                          },
                          icon: Icon(_obscureTextSet
                              ? Icons.visibility_off
                              : Icons.visibility),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return requiredField;
                        }
                        if (!validatePassword(value)) {
                          return helperStr;
                        }
                        return null;
                      },
                    ),
                  ),
                ),

                //confirm password
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: StatefulBuilder(
                    builder: (context,setState) => TextFormField(
                      controller: confirmPassController,
                      enableSuggestions: false,
                      obscureText: _obscureTextConfirm,
                      autocorrect: false,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: confirmPassStr,
                        suffixIcon: IconButton(
                          onPressed: () {
                            _obscureTextConfirm = !_obscureTextConfirm;
                            setState(() {});
                          },
                          icon: Icon(_obscureTextConfirm
                              ? Icons.visibility_off
                              : Icons.visibility),
                        ),
                      ),
                      validator: (value) {
                        if (passController.value != confirmPassController.value) {
                          return 'Password not match';
                        }
                        return null;
                      },
                    ),
                  ),
                ),

                //condition checkbox
                StatefulBuilder(
                  builder: (context,setState) => CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      value: isChecked,
                      title: const Text(termsCheckbox),
                      onChanged: (value) {
                        setState(() {
                          isChecked = value ?? false;
                          print(isChecked);
                        });
                      }),
                ),

                //signup button
                ElevatedButton(
                  onPressed: () => isLoggedin == true ? updateData() : signup(),
                  child: Text(isLoggedin == true ? updateStr : signupStr),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  // void selectDate() async {
  //   final datePick = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(1950),
  //     lastDate: DateTime.now(),
  //   );
  //   if (datePick != null) {
  //     final DateFormat formatter = DateFormat('dd-MM-yyyy');
  //     birthDate = formatter.format(datePick);
  //     birthController.text = birthDate!;
  //   }
  // }

  //DOB selection
  void selectDate() async {
    final datePick = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (datePick != null) {
      var month = DateTime.parse(datePick.toString()).month;
      var date = DateTime.parse(datePick.toString()).day;
      var year = DateTime.parse(datePick.toString()).year;
      birthDate = "$date/$month/$year";
      birthController.text = birthDate!;
      print(birthController.text);
    }
  }

  //onPressed signup
  signup() async {
    username = nameController.text;
    number = int.parse(numberController.text);
    email = emailController.text;
    birthDate = birthController.text;
    password = passController.text;
    cPassword = confirmPassController.text;

    if (_formKey.currentState!.validate()) {
      if (radioSelected == false) {
        const snackBar = SnackBar(
          content: Text(radioValidate),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      else if (isChecked == false) {
        const snackBar = SnackBar(
          content: Text(checkboxValidate),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      else {
        _formKey.currentState!.save();
        _insert(username, number, email, password, gender, birthDate);
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
        );
      }
    }
  }

  //onPressed update
  updateData() async {
    username = nameController.text;
    number = int.parse(numberController.text);
    email = emailController.text;
    birthDate = birthController.text;
    password = passController.text;
    cPassword = confirmPassController.text;

    if (_formKey.currentState!.validate()) {
      if (isChecked == false) {
        const snackBar = SnackBar(
          content: Text(checkboxValidate),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      else {
        _formKey.currentState!.save();
        setState(() {
          _update(username, number, email, password, gender, birthDate);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const UserPage()),
          );
        });
      }
    }
  }

  //insert function add data to db
  void _insert(username, number, email, password, gender, birthDate) async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnName: username,
      DatabaseHelper.columnNumber: number,
      DatabaseHelper.columnEmail: email,
      DatabaseHelper.columnPass: password,
      DatabaseHelper.columnGender: gender,
      DatabaseHelper.columnDOB: birthDate,
    };

    User user = User.fromJson(row);
    await dbHelper.insert(user);
  }

  //update function update data from db
  void _update(username, number, email, password, gender, birthDate) async {
    User user = User(username, number, email, birthDate, password, gender);
    await dbHelper.update(user);
  }

  //password rules
// Row(
//   children: [
//     Column(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: const [
//         Text("Include special character",style: TextStyle(color: Colors.grey, fontSize: 10),),
//         Text("One Uppercase",style: TextStyle(color: Colors.grey, fontSize: 10),),
//         Text("One Lowercase",style: TextStyle(color: Colors.grey, fontSize: 10),),
//       ],
//     ),
//   ],
// ),

}
