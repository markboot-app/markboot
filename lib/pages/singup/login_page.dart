import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:markBoot/common/commonFunc.dart';
import 'package:markBoot/common/common_widget.dart';
import 'package:markBoot/common/style.dart';
import 'package:markBoot/pages/homeScreen/home.dart';
import 'package:markBoot/pages/singup/signup_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'admin_login.dart';
import 'forgot_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController phoneCont = TextEditingController();
  TextEditingController passCont = TextEditingController();
  Firestore _firestore = Firestore();
  CommonWidget commonWidget = CommonWidget();
  SharedPreferences prefs;
  CommonFunction commonFunction = CommonFunction();
  String userVerificationId ;

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    init();
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Color(CommonStyle().darkBlueColor),
      body: Container(
        margin: EdgeInsets.only(top: 40),
        padding: EdgeInsets.symmetric(horizontal: 0,),
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            appLogo(),
            SizedBox(
              height: 20,
            ),
            commonWidget.commonTextField(controller: phoneCont,hintText: "Phone",
                keyboardType: TextInputType.number
            ),
            commonWidget.commonTextField(controller: passCont,hintText: "Password",obscureText: true),
            SizedBox(
              height: 30,
            ),
            Container(
              width: 220,
              padding: EdgeInsets.symmetric(horizontal: 30),
              height: 40,
              child: RaisedButton(
                color: Color(CommonStyle().lightYellowColor),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(60)
                ),
                onPressed: (){
                  FocusScope.of(context).unfocus();
                  userLogin();
                },
                child: Text("Sign In",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            GestureDetector(
              onTap: (){
                Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context)=>SignUpPage()
                ));
              },
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Don't have an account?",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15
                      ),
                    ),
                    Text(" Sign up",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                          color: Colors.grey,
                          fontSize: 15
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height:0,
            ),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context)=> ForgotPasswordPage()
                ));
              },
              child: Container(
                padding: EdgeInsets.all(8),
                child: Text("Forgot Password",
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 14
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(),
            ),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context)=>AdminPage()
                ));
              },
              child: Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(bottom: 10),
                alignment: Alignment.bottomLeft,
                child: Text("Admin Login",
                style: TextStyle(
                  color: Color(CommonStyle().darkBlueColor),
                  fontSize: 12
                ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget appLogo() {
    return
      Container(
        height: 50,
        child: Text("Log In",
          style: TextStyle(
              color: Color(CommonStyle().appbarColor),
              fontSize: 30
          ),
        ),
      );
  }


  userLogin() async {
    try{
      debugPrint("userLogin");
      String phoneNo =phoneCont.text.trim().toString();
      String password = passCont.text.trim().toString();
      if(phoneNo.isEmpty) {
        Fluttertoast.showToast(msg: "Enter phone number",
        backgroundColor: Colors.red,
          textColor: Colors.white
        );
        return;
      }
      else if(password.isEmpty) {
          Fluttertoast.showToast(msg: "Enter password",
              backgroundColor: Colors.red,
              textColor: Colors.white
          );
          return;
      }

      // Show Progress Dialog
      commonFunction.showProgressDialog(isShowDialog: true, context: context);
      //..........

      DocumentSnapshot snapshot = await _firestore.collection("Users").document("+91$phoneNo").get();
      debugPrint("SNAPSHOT ${snapshot.exists}");
      if(snapshot.exists == true) {
        Map<String,dynamic>userData = snapshot.data;
        String userPassword = userData["password"] ?? "";
        debugPrint("USERDATA $userData");
        if(password == userPassword) {
          prefs.setString("userName", userData["name"]??"");
          prefs.setString("userPhoneNo", "+91$phoneNo"??"");
          prefs.setString("userEmailId", userData["emailId"]??"");
          prefs.setString("userPassword", password??"");
          prefs.setString("userInviteCode", userData["inviteCode"]??"");
          prefs.setString("userId", userData["userId"]??"");
          prefs.setString("referralCode", userData["referralCode"]??"");
          prefs.setBool("isLogin", true);
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
            builder: (context) => HomePage()
          ), (route) => false);
        }
        else {
          debugPrint("LOGIN UNSUCCESSFUL");
        }
      }
      else {
        Fluttertoast.showToast(msg: "Phone number doesn't exist.",
        backgroundColor: Colors.red,textColor: Colors.white
        );
      }
    }
    catch(e) {
      debugPrint("Exception (LoginPage) - ${e.toString()}");
    }
    commonFunction.showProgressDialog(isShowDialog: false, context: context);
  }

}

