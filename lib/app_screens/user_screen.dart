// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:task1/app_screens/login_screen.dart';
import 'package:task1/app_screens/signup_update_screen.dart';
import 'package:task1/app_utils/app_colors.dart';
import 'package:task1/app_utils/app_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task1/database_helper/db_helper.dart';
import 'package:task1/model/user_model.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final _pref = SharedPreferences.getInstance();
  final dbHelper = DatabaseHelper.instance;
  List<User> users = [];
  String? email;
  String? username;
  int? number;
  String? gender;
  String? birthDate;
  String? password;


  @override
  void initState() {
    super.initState();
    getUserData();
    _viewUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(userDetails),
        actions: [
          PopupMenuButton(
            onSelected: (value){
              setState(() {
                logoutDialog();
              });
            },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 1,
                    child: Text(
                      logoutStr,
                    ),
                ),
              ],
          ),
          // IconButton(
          //   tooltip: logoutStr,
          //   icon: const Icon(Icons.exit_to_app),
          //   onPressed: () {
          //     logoutDialog();
          //   },
          // ),
        ],
      ),
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return SingleChildScrollView(
              child: Column(
                children: [
                  //logged in user
                  const Text(loggedinUser),
                  Text("$emailStr: $email"),

                  //table data
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: users.length,
                      itemBuilder: (BuildContext context, int index) {

                        //even index alignment
                        if (index % 2 == 0) {
                          return InkWell(
                            onLongPress : (){
                              if(users[index].email != email) {
                                delDialog(index);
                              }
                              else{
                                loggedInDelDialog();
                              }
                            },
                            onTap: () {
                              setState(() {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignupPage(isLoggedin: true, users: users,index: index,)),
                                );
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //data column
                                Flexible(
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("$emailStr: ${users[index].email}"),
                                        Text("$userStr: ${users[index].username}"),
                                        Text("$phoneStr: ${users[index].number}"),
                                        Text("$genderStr: ${users[index].gender}"),
                                        Text("$birthStr: ${users[index].birthDate}"),
                                        Text("$passStr: ${users[index].password}"),
                                      ],
                                    ),
                                ),
                                //button column
                                Column(
                                  children: [
                                    //edit data button
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => SignupPage(isLoggedin: true, users: users,index: index,)),
                                          );
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: editColor,
                                      ),
                                      child: const Text(editStr),
                                    ),

                                    //delete data button
                                    ElevatedButton(
                                      onPressed: () {
                                        //checking logged in user email
                                        if(users[index].email != email){
                                          delDialog(index);
                                        }
                                        else{
                                          loggedInDelDialog();
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: deleteColor,
                                      ),
                                      child: const Text(deleteStr),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }
                        //odd index alignment
                        else {
                          return InkWell(
                            onLongPress : (){
                              if(users[index].email != email) {
                                delDialog(index);
                              }
                              else{
                                loggedInDelDialog();
                              }
                            },
                            onTap: () {
                              setState(() {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignupPage(isLoggedin: true, users: users,index: index,)),
                                );
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //button column
                                Column(
                                  children: [
                                    //edit data button
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => SignupPage(isLoggedin: true, users: users,index: index,)),
                                          );
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: editColor,
                                      ),
                                      child: const Text(editStr),
                                    ),

                                    //delete data button
                                    ElevatedButton(
                                      onPressed: () {
                                        delDialog(index);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: deleteColor,
                                      ),
                                      child: const Text(deleteStr),
                                    ),
                                  ],
                                ),
                                //data column
                                Flexible(
                                  child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("$emailStr: ${users[index].email}"),
                                    Text("$userStr: ${users[index].username}"),
                                    Text("$phoneStr: ${users[index].number}"),
                                    Text("$genderStr: ${users[index].gender}"),
                                    Text("$birthStr: ${users[index].birthDate}"),
                                    Text("$passStr: ${users[index].password}"),
                                  ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider(color: dividerColor, height: 25,);
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  //FutureBuilder future
  Future getData() {
    return Future.delayed(const Duration(seconds: 2), () {
      return "No data";
    });
  }

  //get login data
  Future getUserData() async {
    final SharedPreferences sp = await _pref;
    setState(() {
      email = sp.getString("email");
      username = sp.getString("username");
      number = sp.getInt("number");
      gender = sp.getString("gender");
      birthDate = sp.getString("birthDate");
      password = sp.getString("password");
    });
  }

  //display users
  Future _viewUsers() async {
    final allRows = await dbHelper.getAllUsers();
    users.clear();
    for (var row in allRows) {
      users.add(User.fromJson(row));
    }
    setState(() {});
  }

  //delete user
  Future _delete(email) async {
    await dbHelper.delete(email);
  }

  //logout alert
  void logoutDialog(){
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(logoutStr),
            content: const Text(logoutContent),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(noStr),
              ),
              TextButton(
                onPressed: () async {
                  SharedPreferences pref =
                  await SharedPreferences.getInstance();
                  pref.remove("email");
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                          (route) => false);
                },
                child: const Text(yesStr),
              ),
            ],
          );
        });
  }
  //logged in delete alert
  void loggedInDelDialog(){
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: const Text(invalidDeleteContent),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              ),
            ],
          );
        });
  }
  //delete alert
  void delDialog(index){
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(deleteStr),
            content: const Text(deleteContent),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(noStr),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _delete(users[index].email);
                    users.removeAt(index);
                  });
                  Navigator.pop(context);
                },
                child: const Text(yesStr),
              ),
            ],
          );
        });
  }
}
