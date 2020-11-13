import 'package:chat_app/helper/helperfunctions.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/material.dart';

import 'chatroomscreen.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;
  AuthMethods authMethods = new AuthMethods();
  DataBaseMethods dataBaseMethods = new DataBaseMethods();

  final formKey = GlobalKey<FormState>();
  TextEditingController userNameTextEditingController =
      new TextEditingController();
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();

  signMeUp() {
    if (formKey.currentState.validate()) {

      Map<String, String> userInfoMap = {
        "name" : userNameTextEditingController.text,
        "email": emailTextEditingController.text,
        };

      HelperFunctions.saveUserEmailSharedPreference(emailTextEditingController.text);
      HelperFunctions.saveUserNameSharedPreference(userNameTextEditingController.text);

      setState(() {
        isLoading = true;
      });
      authMethods
          .signUpWithEmailAndPassword(
        emailTextEditingController.text,
        passwordTextEditingController.text,
      )
          .then((val) {
        //print("${val.uid}");
        dataBaseMethods.uploadUserInfo(userInfoMap);
        
        HelperFunctions.saveUserLoggedInSharedPreference(true);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ChatRoom()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarMain(context),
        body: isLoading
            ? Container(
                child: Center(child: CircularProgressIndicator()),
              )
            : SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height - 50,
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Form(
                          key: formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                validator: (val) {
                                  return val.isEmpty || val.length < 6
                                      ? "Your username must be up to 6 characters"
                                      : null;
                                },
                                controller: userNameTextEditingController,
                                style: simpleTextStyle(),
                                decoration:
                                    textFieldInputDecoration("Username"),
                              ),
                              TextFormField(
                                validator: (val) {
                                  return RegExp(
                                              r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                          .hasMatch(val)
                                      ? null
                                      : "Please provide a valid email";
                                },
                                controller: emailTextEditingController,
                                style: simpleTextStyle(),
                                decoration: textFieldInputDecoration("Email"),
                              ),
                              TextFormField(
                                obscureText: true,
                                validator: (val) {
                                  return val.length > 6
                                      ? null
                                      : "Please password should be more than 6 characters";
                                },
                                controller: passwordTextEditingController,
                                style: simpleTextStyle(),
                                decoration:
                                    textFieldInputDecoration("password"),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 12),
                        Container(
                          alignment: Alignment.centerRight,
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Text(
                                "Forgot Password?",
                                style: simpleTextStyle(),
                              )),
                        ),
                        SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            signMeUp();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(vertical: 20),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  const Color(0xff007EF4),
                                  const Color(0xff2A75BC),
                                ]),
                                borderRadius: BorderRadius.circular(30)),
                            child: Text(
                              "Sign Up",
                              style: mediumTextStyle(),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30)),
                          child: Text(
                            "Sign Up with Google",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Already have an account? ",
                                  style: mediumTextStyle()),
                              GestureDetector(
                                onTap: (){
                                  widget.toggle();
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  child: Text(
                                    "Sign In now",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        decoration: TextDecoration.underline),
                                  ),
                                ),
                              ),
                            ]),
                        SizedBox(
                          height: 100,
                        )
                      ],
                    ),
                  ),
                ),
              ));
  }
}
