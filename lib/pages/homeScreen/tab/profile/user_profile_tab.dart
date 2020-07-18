import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:markBoot/common/commonFunc.dart';
import 'package:markBoot/common/common_widget.dart';
import 'package:markBoot/common/style.dart';
import 'package:markBoot/pages/homeScreen/tab/offers/offers_page_tab.dart';
import 'package:markBoot/pages/homeScreen/tab/profile/paymentReq_page.dart';
import 'package:markBoot/pages/homeScreen/tab/profile/post_list_ui.dart';
import 'package:markBoot/pages/homeScreen/tab/profile/settings_page.dart';
import 'package:markBoot/pages/homeScreen/tab/profile/transaction_page.dart';
import 'package:markBoot/pages/homeScreen/tab/tournament/tournament_tab.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileTab extends StatefulWidget {
  @override
  _UserProfileTabState createState() => _UserProfileTabState();
}

class _UserProfileTabState extends State<UserProfileTab> with SingleTickerProviderStateMixin{

  AnimationController animationController;
  Animation animation;
  Firestore _firestore= Firestore.instance;
  TextEditingController updateNameCont = TextEditingController();
  SharedPreferences prefs;
  String name,email,phoneNo;
  bool isShowDialog = false;
  Map<String,dynamic> pendingTasks = new Map();
  Map<String,dynamic> internshipList = new Map();
  Map<String,dynamic> campaignList =new Map();
  Map<String,dynamic> tournamentList =new Map();
  Map<String,dynamic> offersList =new Map();
  String approvedAmount ="0";
  String pendingAmount ="0";
  bool isShowInitBar = false;


  initAnim() {
    animationController = AnimationController(vsync: this,duration: Duration(milliseconds: 500));
    animation = Tween<double>(begin: 0.0,end:1.0).animate(CurvedAnimation(
      parent: animationController,curve: Curves.ease
    ))..addListener(() {
      setState(() {

      });
    });
  }

  init() async {
    isShowInitBar = true;
    prefs = await SharedPreferences.getInstance();
   name =  prefs.getString("userName");
   phoneNo =  prefs.getString("userPhoneNo");
   email =  prefs.getString("userEmailId");
   setState(() {

   });
   DocumentSnapshot snapshot =  await _firestore.collection("Users").document(phoneNo).get();
   Map<String,dynamic> userData = snapshot.data;
   pendingTasks = userData["pendingTasks"] ?? new Map();
    campaignList = userData["campaignList"] ?? new Map();
    internshipList = userData["internshipList"] ?? new Map();
    offersList = userData["offersList"] ?? new Map();
    tournamentList = userData["tournamentList"] ?? new Map();
    approvedAmount = userData["approvedAmount"] ?? "0";
    pendingAmount = userData["pendingAmount"] ?? "0";

    isShowInitBar = false;
   setState(() {

   });
  }

  @override
  void initState() {
    init();
    initAnim();
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          backgroundColor: Color(CommonStyle().darkBlueColor),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(140),
            child:Container(
                height: 140,
                padding: EdgeInsets.only(left: 20,top: 30,right: 20),
                decoration: BoxDecoration(
                    color: Color(CommonStyle().blueColor),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    )
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              height: 60,
                              constraints: BoxConstraints(
                                  maxWidth: MediaQuery.of(context).size.width*0.60
                              ),
                              child: Text(name ?? "",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            SizedBox(width: 20,),
                          ],
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context)=>MoreSettingsPage()
                              ));
                            },
                            child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100)
                                ),
                                child: Icon(Icons.more_vert,color: Colors.white,size: 25,)),
                          ),
                        )
                      ],
                    ),
                    Text(email ?? "",
                      style: TextStyle(color: Colors.white,fontSize: 15),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(phoneNo ?? "",style: TextStyle(color: Colors.white,fontSize: 15),),
                  ],
                )
            ),
          ),
          body: isShowInitBar == true?
              Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
              : GestureDetector(
            onTap: (){
              if(animationController.isCompleted) {
                animationController.reverse();
              }
            },
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                        color: Color(CommonStyle().blueColor),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    height: 260,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Earning",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 80,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Text("APPROVED",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12
                                    ),
                                  ),
                                  Text("AMOUNT",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Image.asset("assets/icons/bank.png",width: 20,height: 20,),
                                      SizedBox(width: 1,),
                                      Text(approvedAmount??"0",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              Container(
                                width: 1,
                                color: Colors.white,
                              ),
                              Column(
                                children: <Widget>[
                                  Text("PENDING",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12
                                    ),
                                  ),
                                  Text("AMOUNT",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Image.asset("assets/icons/bank.png",width: 20,height: 20,),
                                      SizedBox(width: 1,),
                                      Text(pendingAmount??"0",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 50,
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          width: MediaQuery.of(context).size.width,
                          child: RaisedButton(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context)=>TransactionPage()
                              ));
                            },
                            child: Text("Transactions",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(CommonStyle().blueColor),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          child: RaisedButton(
                            color: Color(CommonStyle().lightYellowColor),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)
                            ),
                            onPressed: ()async{
                              if(int.parse(approvedAmount) >= 150) {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context)=>PaymentRequestPage()
                                )).then((value) {
                                  debugPrint("returnVal $value");
                                  init();

                                });
                              }
                            },
                            child: Text(int.parse(approvedAmount) < 150 ? "AMOUNT<150":"WITHDRAW",
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
                  SizedBox(
                    height: 10,
                  ),
//                  GestureDetector(
//                    onTap: (){
//                    },
//                    child: Container(
//                      margin: EdgeInsets.symmetric(horizontal: 15),
//                      width: MediaQuery.of(context).size.width,
//                      decoration: BoxDecoration(
//                          color: Color(CommonStyle().blueColor),
//                          borderRadius: BorderRadius.circular(10)
//                      ),
//                      height: 200,
//                      child: Column(
//                        mainAxisSize: MainAxisSize.max,
//                        mainAxisAlignment: MainAxisAlignment.center,
//                        children: <Widget>[
//                          Text("Current Money",
//                            style: TextStyle(
//                                color: Colors.green,
//                                fontSize: 22,
//                                fontWeight: FontWeight.bold
//                            ),
//                          ),
//                          Row(
//                            children: <Widget>[
//
//                            ],
//                          )
//                        ],
//                      ),
//                    ),
//                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => PostListUIPage(docMap: pendingTasks,
                              path: "Posts/Gigs/Tasks",type: "Gigs",subType: "Tasks",
                              campaignMap : campaignList
                          )
                      ));
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Color(CommonStyle().blueColor),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      height: 200,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Gigs",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Text(pendingTasks.length.toString() ?? "",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => OffersPageTab(isRedirectFromProfile: true,docList: offersList,)
                      ));
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Color(CommonStyle().blueColor),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      height: 200,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Offers",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Text(offersList.length.toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => PostListUIPage(docMap: internshipList,
                            path: "Posts/Internship/Internship",type: "Internship",subType: "Internship",
                          )
                      ));
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Color(CommonStyle().blueColor),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      height: 200,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Internship",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Text(internshipList.length.toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => TournamentPageTab(
                            isRedirectFromProfile: true,docList: tournamentList,
                          )
                      ));
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Color(CommonStyle().blueColor),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      height: 200,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Tournament",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Text(tournamentList.length.toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 50,),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: animation != null ?MediaQuery.of(context).size.height*0.5*animation.value : 0,
            color: Colors.white,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 50 * animation.value,
                ),
                Container(
                  height: 50 * animation.value,
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: TextField(
                    controller: updateNameCont,
                    onTap: (){

                    },
                    decoration: InputDecoration(
                        hintText: "Name"
                    ),
                  ),
                ),
                SizedBox(
                  height: 40 *animation.value ,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 60),
                  height: 50 * animation.value,
                  width: MediaQuery.of(context).size.width,
                  child: RaisedButton(
                    color: Color(CommonStyle().blueColor),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)
                    ),
                    onPressed: (){
                      debugPrint("Pressed");
                      FocusScope.of(context).unfocus();
                      updateName();
                    },
                    child: Text("Update",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  updateName() async {
    try {
      String name = updateNameCont.text.trim().toString();
      if(name.isEmpty) {
        Fluttertoast.showToast(msg: "Enter name.",backgroundColor: Colors.red,textColor: Colors.white);
        return;
      }
      isShowDialog = true;
      showProgressDialog();
      debugPrint("DDD");
      Map<String,String> userData = {
        "name" : name,
      };
      await  _firestore.collection("Users").document(phoneNo).setData(userData,merge: true)
      .whenComplete(() {
       // CommonFunction().showProgressDialog(isShowDialog: false, context: context);
        Fluttertoast.showToast(msg: "update successfully.",backgroundColor: Colors.red,textColor: Colors.white);
        return;
      })
      .catchError((error){
       // CommonFunction().showProgressDialog(isShowDialog: false, context: context);
        Fluttertoast.showToast(msg: "getting some error.",backgroundColor: Colors.red,textColor: Colors.white);
        return;
      })
      .timeout(Duration(seconds: 5),onTimeout: (){
        //CommonFunction().showProgressDialog(isShowDialog: false, context: context);
        Fluttertoast.showToast(msg: "please try again.",backgroundColor: Colors.red,textColor: Colors.white);
        return;
      });
    }
    catch(e) {
      debugPrint("Exception : (UpdateName)-> $e");
    }
    isShowDialog = false;
    showProgressDialog();
  }

  Future<void> showProgressDialog() {
    if(isShowDialog) {
      showDialog(context: context,
          builder: (context){
            return Center(
              child: Container(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(),
              ),
            );
          });
    }
    else if(Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

}



