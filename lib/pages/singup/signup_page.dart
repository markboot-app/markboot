import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:markBoot/common/commonFunc.dart';
import 'package:markBoot/common/common_widget.dart';
import 'package:markBoot/common/style.dart';
import 'package:markBoot/pages/singup/verification_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_page.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  TextEditingController nameCont = TextEditingController();
  TextEditingController phoneNoCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController passCont = TextEditingController();
  TextEditingController inviteCodeCont = TextEditingController();
  SharedPreferences prefs;
  CommonFunction commonFunction = CommonFunction();
  CommonWidget commonWidget = CommonWidget();

  // Firebase
  Firestore _firestore = Firestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> init() async{
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
      backgroundColor: Color(CommonStyle().darkBlueColor),
//      appBar: AppBar(
//        backgroundColor: Color(CommonStyle().appbarColor),
//        leading: IconButton(
//          icon: Icon(Icons.arrow_back),
//          onPressed: (){
//            Navigator.pop(context);
//          },
//        ),
//      ),
      body:Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child:SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              IconButton(
                icon: Icon(Icons.arrow_back,size: 25,color: Color(CommonStyle().appbarColor),),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
              //Center(child: appLogo()),
              SizedBox(
                height: 20,
              ),
              Center(child: commonWidget.commonTextField(controller: nameCont,hintText: "Name")),
              Center(
                child: commonWidget.commonTextField(controller: phoneNoCont,hintText: "Phone Number",keyboardType: TextInputType.number,
                    obscureText: false
                ),
              ),
              Center(child: commonWidget.commonTextField(controller: emailCont,hintText: "Email")),
              Center(child: commonWidget.commonTextField(controller: passCont,hintText: "Password",obscureText: true)),
              Center(child: commonWidget.commonTextField(controller: inviteCodeCont,hintText: "Invite Code")),
              SizedBox(
                height: 30,
              ),
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  width: 220,
                  height: 40,
                  child: RaisedButton(
                    color: Color(CommonStyle().lightYellowColor),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60)
                    ),
                    onPressed: (){
                      FocusScope.of(context).unfocus();
                      SignUpService();
                    },
                    child: Text("Sign Up",

                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
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
                      builder: (context) => LoginPage()
                  ));
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Already have an account?",textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color(CommonStyle().appbarColor),
                            fontSize: 15
                        ),
                      ),
                      Text(" Sign in",
                        style: TextStyle(
                          decorationColor: Colors.yellowAccent,
                          decoration: TextDecoration.underline,
                            color: Color(CommonStyle().appbarColor),
                            fontSize: 15
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget appLogo() {
    return
        Container(
          height: 50,
          child: Text("App Logo",
           style: TextStyle(
             color: Colors.white,
             fontSize: 30
           ),
          ),
        );
  }



  SignUpService()async {
    try {

      String name = nameCont.text.trim().toString();
      String phoneNo=phoneNoCont.text.trim().toString();
      String email=emailCont.text.trim().toString();
      String password=passCont.text.trim().toString();
      String inviteCode=inviteCodeCont.text.trim().toString();

      if(name.isEmpty) {
        Fluttertoast.showToast(msg: "Enter name.",backgroundColor: Colors.red,textColor: Colors.white);
        return;
      }
      else if(phoneNo.isEmpty) {
        Fluttertoast.showToast(msg: "Enter phone number.",backgroundColor: Colors.red,textColor: Colors.white);
        return;
      }
      else if(email.isEmpty) {
        Fluttertoast.showToast(msg: "Enter email id.",backgroundColor: Colors.red,textColor: Colors.white);
        return;
      }
      else if(password.isEmpty) {
        Fluttertoast.showToast(msg: "Enter password.",backgroundColor: Colors.red,textColor: Colors.white);
        return;
      }

      // show ProgressBar
      commonFunction.showProgressDialog(isShowDialog: true, context: context);


     DocumentSnapshot snapshot = await _firestore.collection("Users").document("+91$phoneNo").get();
      debugPrint("SNAPSHOT ${snapshot.exists}");
      if(snapshot.exists == false) {
        prefs.setString("userName", name);
        prefs.setString("userPhoneNo", "+91$phoneNo");
        prefs.setString("userEmailId", email);
        prefs.setString("userPassword", password);
        prefs.setString("userInviteCode", inviteCode);
        await commonFunction.showProgressDialog(isShowDialog: false, context: context);
        Future.delayed(Duration(milliseconds: 10),(){
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => PhoneVerification()
          ));
        });
      }
      else {
        await commonFunction.showProgressDialog(isShowDialog: false, context: context);
        Fluttertoast.showToast(msg: "Mobile no already in used");
      }
    }
    catch(e) {
      debugPrint("Exception : (SignUpService) - ${e.toString()}");
    }
  }

}

