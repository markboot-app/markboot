import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:markBoot/common/commonFunc.dart';
import 'package:markBoot/common/style.dart';

class AmountReqUserListPage extends StatefulWidget {
  @override
  _AmountReqUserListPageState createState() => _AmountReqUserListPageState();
}

class _AmountReqUserListPageState extends State<AmountReqUserListPage> {

  List<DocumentSnapshot> usersList  = new List();
  bool isShowInitBar = true;

  init() async {
    QuerySnapshot querySnapshot = await Firestore.instance.collection("Users").getDocuments();
    if(querySnapshot !=null ){
      for(DocumentSnapshot snapshot in querySnapshot.documents) {
        Map<String,dynamic>userData = snapshot.data;
        String requestAmount = userData["requestAmount"] ??"0";
        if(int.parse(requestAmount)>0) {
          usersList.add(snapshot);
        }
      }
    }
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
        title: Text("Amount Request"),
      ),
      body: isShowInitBar == true ?
       Container(
         child: Center(
           child: CircularProgressIndicator(),
         ),
       )
          : (
      usersList.length> 0 ?
          ListView.builder(itemBuilder: (context,index){
            return Container(
              height: 80,
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Color(CommonStyle().blueColor),
                borderRadius: BorderRadius.circular(10)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(usersList[index]["name"]??"",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13
                      ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(usersList[index]["paymentNo"],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15
                      ),
                      )
                    ],
                  ),
                  Container(
                    height: 40,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Row(
                      children: <Widget>[
                        Text(usersList[index]["requestAmount"],
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                        ),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(usersList[index]["paymentMethod"],
                          style: TextStyle(
                              color: Colors.black,
                            fontSize: 12
                          ),
                        ),

                      ],
                    )
                  ),
                  Container(
                    child: RaisedButton(
                      color: Color(CommonStyle().lightYellowColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      onPressed: (){
                        payService(usersList[index]);
                      },
                      child: Text("Pay",
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
            );
          },
          itemCount: usersList.length,
          )
          : Center(
            child: Container(
            child: Text("No users found",
            style: TextStyle(
            fontSize: 15,
            color: Colors.white
          ),
          ),
        ),
      )
      )
    );
  }

  Future<void> payService(snapshot)async{
    try{
      CommonFunction().showProgressDialog(isShowDialog: true, context: context);
      await Firestore.instance.collection("Users").document(snapshot["phoneNo"]).setData({
        "requestAmount" : "0"
      },
      merge: true
      );
      usersList.remove(snapshot);
      setState(() {

      });
      Fluttertoast.showToast(msg: "Pay successfully",
      backgroundColor: Colors.green,textColor: Colors.white
      );
    }
    catch(e){
      Fluttertoast.showToast(msg: "please try again",
      textColor: Colors.white,backgroundColor: Colors.red
      );
    }
    CommonFunction().showProgressDialog(isShowDialog: false, context: context);
  }

}
