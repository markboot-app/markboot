import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:markBoot/common/commonFunc.dart';
import 'package:markBoot/common/common_widget.dart';
import 'package:markBoot/common/style.dart';
import 'package:shared_preferences/shared_preferences.dart';


class PaymentRequestPage extends StatefulWidget {
  @override
  _PaymentRequestPageState createState() => _PaymentRequestPageState();
}

class _PaymentRequestPageState extends State<PaymentRequestPage> {

  List<String> paymentMethod = ["Paytm","PhonePay","Google Pay"];
  String selectedPayMethod ;
  TextEditingController phoneNoCont = TextEditingController();
  TextEditingController amountCont = TextEditingController();
  String userPhoneNo;
  SharedPreferences prefs;

  init() async {
    prefs = await SharedPreferences.getInstance();
    userPhoneNo = prefs.getString("userPhoneNo")??"";
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
      appBar: AppBar(
        backgroundColor: Color(CommonStyle().blueColor),
        title: Text("Payment Request",
        style: TextStyle(
          color: Colors.white,
          fontSize: 18
        ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
           Padding(
             padding: EdgeInsets.symmetric(horizontal: 30),
             child:  DropdownButton(
               hint: Text("Select Payment Method" ,style: TextStyle(
                   color: Colors.white70
               ),),
               dropdownColor: Color(CommonStyle().blueColor),
               isExpanded: true,
               onChanged: (value){
                 selectedPayMethod = value;
                 setState(() {

                 });
               },
               value: selectedPayMethod,
               items: paymentMethod.map((e) {
                 return DropdownMenuItem(
                   value: e,
                   child: Text(e,
                     style: TextStyle(
                         color: Colors.white
                     ),
                   ),
                 );
               }).toList(),
             ),
           ),
            SizedBox(
              height: 10,
            ),
            CommonWidget().commonTextField(controller: phoneNoCont,hintText: "Phone number",keyboardType: TextInputType.number),
            CommonWidget().commonTextField(controller: amountCont,hintText: "Amount",keyboardType: TextInputType.number),
            SizedBox(
              height: 30,
            ),
            Container(
              height: 50,
              width: 200,
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: RaisedButton(
                color: Color(CommonStyle().lightYellowColor),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
                onPressed: (){
                  requestAmountService();
                },
                child: Text("Request",
                  style: TextStyle(
                      color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            )

          ],
        ),
      ),
    );
  }

  Future<void>requestAmountService() async {
    try{
      FocusScope.of(context).unfocus();
      String amount = amountCont.text;
      String phoneNo = phoneNoCont.text;
       if (phoneNo.length > 10) {
        phoneNo = phoneNo.substring(phoneNo.length - 10);
      }

      if(selectedPayMethod ==null){
        Fluttertoast.showToast(msg: "Select payment method.",
            backgroundColor: Colors.red,textColor: Colors.white
        );
        return;
      }
      else if(amount.isEmpty) {
        Fluttertoast.showToast(msg: "Enter a valid amount",
        backgroundColor: Colors.red,textColor: Colors.white
        );
        return;
      }
      else if(phoneNo.isEmpty) {
        Fluttertoast.showToast(msg: "Enter valid phone number.",
            backgroundColor: Colors.red,textColor: Colors.white
        );
        return;
      }

      CommonFunction().showProgressDialog(isShowDialog: true, context: context);

     DocumentSnapshot snapshot = await Firestore.instance.collection("Users").document(userPhoneNo).get();
      Map<String,dynamic>userData = snapshot.data;
      String requestAmount = userData["requestAmount"]??"0";
      String approvedAmount = userData["approvedAmount"]??"0";
      if(int.parse(requestAmount)>0) {
        Fluttertoast.showToast(msg: "Another transaction is in progress",
        backgroundColor: Colors.red,textColor: Colors.white
        );
        CommonFunction().showProgressDialog(isShowDialog: false, context: context);
        return;
      }

      requestAmount = (int.parse(requestAmount) +  int.parse(amount)).toString();
      approvedAmount = (int.parse(approvedAmount) - int.parse(amount)).toString();
      if(int.parse(approvedAmount)<0) {
        Fluttertoast.showToast(msg: "please try again or contact to admin",
        backgroundColor: Colors.red,textColor: Colors.white
        );
        CommonFunction().showProgressDialog(isShowDialog: false, context: context);
        return;
      }
      await Firestore.instance.collection("Users").document(userPhoneNo).setData({
        "approvedAmount":approvedAmount,
        "requestAmount":requestAmount,
        "paymentMethod" : selectedPayMethod,
        "paymentNo" : phoneNo
      },merge: true);
      Fluttertoast.showToast(msg: "Added payment request successfully",
      backgroundColor: Colors.green,textColor: Colors.white
      );
      Navigator.pop(context,true);
    }
    catch(e) {
      Fluttertoast.showToast(msg: "Please try again",
      backgroundColor: Colors.red,
        textColor: Colors.white
      );
      debugPrint("Exception :(requestAmountService)-> $e");
    }
    CommonFunction().showProgressDialog(isShowDialog: false, context: context);
  }

}
