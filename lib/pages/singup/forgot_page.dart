import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:markBoot/common/commonFunc.dart';
import 'package:markBoot/common/common_widget.dart';
import 'package:markBoot/common/style.dart';
import 'package:markBoot/pages/homeScreen/home.dart';
import 'package:markBoot/pages/singup/reset_password_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController phoneCont = TextEditingController();
  String userVerificationId ;
  TextEditingController otpCont = TextEditingController();
  String number;
  SharedPreferences prefs;

  init() async {
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CommonWidget().commonTextField(controller: phoneCont,hintText: "Phone",
              keyboardType: TextInputType.number
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 40,
            width: 200,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(60)
              ),
              color: Color(CommonStyle().lightYellowColor),
              onPressed: (){
                if(phoneCont.text.isEmpty) {
                  Fluttertoast.showToast(msg: "Enter phone number",
                  backgroundColor: Colors.red,textColor: Colors.white
                  );
                }
                else {
                  number = phoneCont.text;
                  if (number.length > 10) {
                    number = number.substring(number.length - 10);
                  }
                  loginUser(number);
                }
              },
              child: Text("Send Otp",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold
              ),
              ),
            ),
          )
        ],
      ),
    );
  }

  showOTPDialog()  {
    showDialog(context: context,
    barrierDismissible: true,
    builder: (context) {
       return Center(
         child: Container(
           width: 260,
           height: 260,
           child: Material(
             color: Colors.transparent,
             child: Center(
               child: Container(
                 decoration: BoxDecoration(
                   color: Color(CommonStyle().blueCardColor),
                   borderRadius: BorderRadius.circular(10)
                 ),
                 width: 260,
                 height: 260,
                 child:Column(
                   mainAxisAlignment: MainAxisAlignment.start,
                   children: <Widget>[
                     SizedBox(
                       height: 30,
                     ),
                     CommonWidget().commonTextField(controller:otpCont,hintText: "Enter OTP" ),
                     SizedBox(
                       height: 20,
                     ),
                     Container(
                       width:200,
                       padding: EdgeInsets.symmetric(horizontal: 30),
                       height: 40,
                       child: RaisedButton(
                         color: Color(CommonStyle().lightYellowColor),
                         shape: RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(60)
                         ),
                         onPressed: (){
                           FocusScope.of(context).unfocus();
                           verifyCode();
                         },
                         child: Text("Verify",
                           style: TextStyle(
                             fontSize: 18,
                             fontWeight: FontWeight.bold,
                             color: Colors.white,
                           ),
                         ),
                       ),
                     ),
                   ],
                 ),
               ),
             ),
           ),
         ),
       );
    }
    );
  }

  Future<bool> loginUser(String number) async{
    CommonFunction().showProgressDialog(isShowDialog: true, context: context);
    FirebaseAuth _auth = FirebaseAuth.instance;
    debugPrint("Number +91$number");
    _auth.verifyPhoneNumber(
        phoneNumber:"+91$number",
        timeout: Duration(seconds:60),
        verificationCompleted: (AuthCredential credential) async{
          AuthResult result = await _auth.signInWithCredential(credential);
          FirebaseUser user = result.user;
          if(user != null){
            debugPrint("USERRRRRR $user");
          }else{
            print("Error");
          }
        },
        verificationFailed: (AuthException exception){
          print(exception.message);
        },
        codeSent: (String verificationId, [int forceResendingToken]) async{
          debugPrint("VVVVVVVVVVVVV ${verificationId} , token $forceResendingToken");
          userVerificationId = verificationId;
          showOTPDialog();
        },
        codeAutoRetrievalTimeout: null
    );
    CommonFunction().showProgressDialog(isShowDialog: false, context: context);
  }

  verifyCode() async{
    try{
      String enteredOTPCode = otpCont.text.trim().toString();
      if(enteredOTPCode.isNotEmpty) {
        CommonFunction().showProgressDialog(isShowDialog: true,context: context);
        debugPrint("ID $userVerificationId");
        debugPrint("CODE112 $enteredOTPCode");
        AuthCredential credential = PhoneAuthProvider.getCredential(verificationId: userVerificationId, smsCode: enteredOTPCode);

        FirebaseAuth auth = FirebaseAuth.instance;
        debugPrint("CRED $credential");
        AuthResult result = await auth.signInWithCredential(credential);
        debugPrint("AUTHRES $result");
        FirebaseUser user = result.user;

        if(user != null){
          await CommonFunction().showProgressDialog(isShowDialog: false,context: context);
          debugPrint("UUUUUUUUUUUUUU ${user.phoneNumber}");
          Navigator.push(context, MaterialPageRoute(
              builder: (context) =>ResetPasswordPage(phoneNo: number,)
          ));
        }else{
          print("Error");
        }
      }
      else {
        Fluttertoast.showToast(msg: "Enter valid OTP.",backgroundColor: Colors.red,textColor: Colors.white);
      }
    }
    catch(e) {
      debugPrint("ExceptionAuth : ${e.toString()}");
    }
    CommonFunction().showProgressDialog(isShowDialog: false,context: context);
  }

}
