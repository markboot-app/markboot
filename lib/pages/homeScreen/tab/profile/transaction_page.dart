import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:markBoot/common/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransactionPage extends StatefulWidget {
  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {

  String requestAmount="";
  SharedPreferences prefs;
  String phoneNo;
  List<dynamic> transactions = new List();
  bool isShowInitBar = true;

  init()async{
    isShowInitBar = true;
    prefs = await SharedPreferences.getInstance();
    phoneNo = prefs.getString("userPhoneNo") ??"";
   DocumentSnapshot snapshot =  await Firestore.instance.collection("Users").document(phoneNo).get();
   transactions = snapshot.data["transaction"] ?? new List();
   requestAmount = snapshot.data["requestAmount"]??"";
   setState(() {

   });
   isShowInitBar = false;
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
        title: Text("Transactions",
        style: TextStyle(
          color: Colors.white,
          fontSize: 18
        ),
        ),
      ),
      body: isShowInitBar == false ?
      ListView(
        primary: true,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Visibility(
                  visible: int.parse(requestAmount)>0 ? true:false,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color(CommonStyle().blueColor),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    height: 80,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Amount",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Visibility(
                              child: Row(
                                children: <Widget>[
                                  Image.asset("assets/icons/bank.png",width: 20,height: 20,),
                                  SizedBox(width: 1,),
                                  Text(requestAmount??"0",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        Text("Processing",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 15
                          ),
                        )
                      ],
                    ) ,
                  ),
                ),

                Expanded(
                  child: Container(
                    height: 400,
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      primary: false,itemBuilder: (context,index){
                      return Container(
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                            color: Color(CommonStyle().blueColor),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        height: 80,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("Amount",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12
                                  ),
                                ),
                                Text(transactions[index]+""??"",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15
                                  ),
                                )
                              ],
                            ),
                            Text("Success",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 15
                              ),
                            )
                          ],
                        ) ,
                      );
                    },
                      itemCount: transactions.length,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ) :
          Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
    );
  }
}
