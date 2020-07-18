import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:markBoot/common/commonFunc.dart';
import 'package:markBoot/common/common_widget.dart';
import 'package:markBoot/common/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Flexible(
//child: Image.network("https://www.payscale.com/wp-content/uploads/2019/05/QuitYou_HP.jpg",
//fit: BoxFit.cover,
//),
//),

class InternshipPageDetails extends StatefulWidget {
  DocumentSnapshot snapshot;
  String type;
  String subType;
  InternshipPageDetails({@required this.snapshot,this.type,this.subType});
  @override
  _InternshipPageDetailsState createState() => _InternshipPageDetailsState();
}

class _InternshipPageDetailsState extends State<InternshipPageDetails>with SingleTickerProviderStateMixin {

  Firestore _firestore = Firestore();
  String phoneNo ;
  SharedPreferences prefs;
  Map<String,dynamic> pendingPost;
  Map<String,dynamic>userData;
  bool isApplied = false;
  List<int> textColors = [0xff00E676,0xffEEFF41,0xffE0E0E0,0xffffffff];
  List<int> colors = [0xff11232D,0xff1C2D41,0Xff343A4D,0xff4F4641,0xff434343,0xff2A2A28
  ];
  Map<String,dynamic> internshipList = new Map();
  Random random = Random();
  String name;
  String emailId;
  String userId;
  TextEditingController emailCont = TextEditingController();
  bool isGetCampaignCode = false;
  String referralCode ;
  List<String>appliedInternship = new List<String>();
  AnimationController animationController ;
  Animation animation;
  File resumeFile ;

  Future<void> init() async {
    try{
      debugPrint("COUPONS ${widget.subType}");
      prefs = await SharedPreferences.getInstance();
      appliedInternship = prefs.getStringList("appliedInternship") ?? new List();
      if(appliedInternship.contains(widget.snapshot.documentID)) {
        isApplied = true;
        setState(() {

        });
      }
      phoneNo = prefs.getString("userPhoneNo") ?? "";
      name = prefs.getString("userName");
      phoneNo =  prefs.getString("userPhoneNo");
      emailId = prefs.getString("userEmailId");
      userId = prefs.getString("userId");
      referralCode = prefs.getString("referralCode") ?? "";
      DocumentSnapshot snapshot = await _firestore.collection("Users").document(phoneNo).get();
      userData = snapshot.data;
      debugPrint("DATA $userData");
      internshipList = userData["internshipList"] ?? new Map();
      if(internshipList.containsKey(widget.snapshot.documentID)){
        isApplied = true;
      }
      pendingPost = userData["post"] ?? new Map<String,dynamic>();
      setState(() {

      });
    }
    catch(e){
      debugPrint("Exception: (Init) -> $e");
    }
  }

  @override
  void initState() {
    animationController = AnimationController(vsync: this,duration: Duration(milliseconds: 200));
    animation  = Tween<double>(begin: 0.0,end: 1.0).animate(CurvedAnimation(
        parent: animationController,curve: Curves.ease
    ))
      ..addListener(() {
        setState(() {

        });
      });
    init();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(CommonStyle().darkBlueColor),
        body: Stack(
          children: <Widget>[
            CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                    backgroundColor: Colors.transparent,
                    stretch: true,
                    expandedHeight: MediaQuery.of(context).size.height * 0.70,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Hero(
                        tag: "img",
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white38,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(widget.snapshot["imgUri"])
                              )
                          ),
                          child:Container(
                            margin: EdgeInsets.only(left: 20,right: 50,top: 80,),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  child: Text(widget.snapshot["taskTitle"]??"",
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w500,
                                        color: Color(CommonStyle().lightYellowColor)
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: <Widget>[
                                    CircleAvatar(
                                      radius: 25,
                                      backgroundImage:NetworkImage(widget.snapshot["logoUri"]),
                                    ),
                                    SizedBox(width: 10,),
                                    Text(widget.snapshot["companyName"]??"",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        placeholderBuilder: (context,size, widget) {
                          return Container(
                            height: 150.0,
                            width: 150.0,
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
                    )
                ),
                SliverPadding(
                    padding: const EdgeInsets.all(20),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            child: Text("SALARY",
                              style: TextStyle(
                                  color: Color(CommonStyle().lightYellowColor),
                                  fontSize: 15
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                              child: Row(
                                children: <Widget>[
                                  Image.asset("assets/icons/bank.png",width: 15,height: 15,),
                                  SizedBox(width: 4,),
                                  Text(widget.snapshot["salary"],
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12
                                    ),
                                  ),
                                ],
                              )
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(child: singleItem("LOCATION",widget.snapshot["location"] ?? "")),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(child: singleItem("DURATION",widget.snapshot["duration"] ?? "")),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(child: singleItem("CATEGORY",widget.snapshot["category"] ?? "")),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(child: singleItem("DESIGNATION",widget.snapshot["designation"] ?? "")),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(child: singleItem("START DATE",widget.snapshot["startDate"] ?? "")),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(child: singleItem("APPLY BY",widget.snapshot["applyBy"] ?? "")),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(child: singleItem("SKILL REQUIRED",widget.snapshot["skillReq"] ?? "")),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(child: singleItem("DESCRIPTION",widget.snapshot["taskDesc"] ?? "",
                                  crossAlign: CrossAxisAlignment.start
                              )),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            height: 50,
                            child: RaisedButton(
                              color: Color(0xff384980),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)
                              ),
                              onPressed: (){
                                if(isApplied == false) {
                                  if(animationController.isCompleted){
                                    animationController.reverse();
                                  }
                                  else {
                                    animationController.forward();
                                  }
//                                  applyPostService();
                                }
                              },
                              child: Text(isApplied == true? "Applied Already" :"APPLY",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    )
                ),
              ],
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
                      height: animation!=null ? 50 * animation?.value : 0,
                    ),
                    Container(
                      height: animation!=null ? 50 * animation?.value : 0,
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: TextField(
                        controller: emailCont,
                        onTap: (){

                        },
                        decoration: InputDecoration(
                            hintText: "Email"
                        ),
                      ),
                    ),
                    SizedBox(
                      height: animation!=null ? 20 * animation?.value : 0,
                    ),
                    GestureDetector(
                        onTap: (){
//                          showPickImageDialog(_workedImgFile);
                          getFile();
                        },
                        child: Text("upload Resume Doc/pdf file")),
                    SizedBox(
                      height: animation !=null ?40 *animation.value  : 0,
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
                          if(emailCont.text.isEmpty) {
                            Fluttertoast.showToast(msg: "Enter email",
                                backgroundColor: Colors.red,textColor: Colors.white
                            );
                            return;
                          }
                          else if(resumeFile == null) {
                            Fluttertoast.showToast(msg: "Upload resume",
                                backgroundColor: Colors.red,textColor: Colors.white
                            );
                            return;
                          }
                          else {
                            applyPostService();
                          }
                        },
                        child: Text("Submit",
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
        )
    );
  }

  Widget singleItem(title,desc,{crossAlign = CrossAxisAlignment.center}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8,vertical: 20),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 1
        ),
        color:  Color(CommonStyle().blueCardColor),
        borderRadius: BorderRadius.circular(8)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: crossAlign,
        children: <Widget>[
           Container(
             child: Text(title,
             style: TextStyle(
               color: Color(CommonStyle().lightYellowColor),
               fontSize: 18
             ),
             ),
           )  ,
          SizedBox(
            height: 10,
          ),
          Container(
            child: Text(desc,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 15
            ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> getFile() async {
    try {
      resumeFile = await FilePicker.getFile(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc'],
      );
      debugPrint("FILE $resumeFile");
    }
    catch(e) {
      debugPrint("Exception : (getFile) -> $e");
    }
  }

  Future<String> uploadToStorage(File file)async {
   try{
     final StorageReference storageReference = FirebaseStorage.instance.ref().child(file.path);
     final StorageUploadTask uploadTask = storageReference.putFile(file);
     debugPrint("Upload ${uploadTask.isComplete}");
     StorageTaskSnapshot snapshot =  await uploadTask.onComplete;
     var downloadUrl = await snapshot.ref.getDownloadURL();
     debugPrint("UUURRRLLL $downloadUrl");
     return downloadUrl;
   }
   catch(e){
     debugPrint("Exception : (uploadToStorage)-> $e");
   }
  }

  Widget bottomButton(context){
    return Container(
      height: 70,
      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              height: 50,
              child: RaisedButton(
                color: Color(CommonStyle().lightYellowColor),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)
                ),
                onPressed: (){
                },
                child: Text("Visit Website",
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
            width: 10,
          ),
          Expanded(
            child: Container(
              height: 50,
              child: RaisedButton(
                color: Color(CommonStyle().lightYellowColor),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)
                ),
                onPressed: (){
                  FocusScope.of(context).unfocus();
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
          )
        ],
      ),
    );
  }

  Widget header() {
    return Container(
      height: 500,
      decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage("assets/icons/list.png")
          )
      ),
    );
  }

  Future<void> applyPostService() async {
    try {
      bool islocalAplied = false;
      CommonFunction().showProgressDialog(isShowDialog: true, context: context);

      List<Map<String,String>> map = new List();
      debugPrint("HO");
     String resumeUri =  await uploadToStorage(resumeFile);
     debugPrint("RRRR $resumeUri");
      List userTaskList = widget.snapshot["appliedBy"] ?? new List();
      debugPrint("USERRR $userTaskList");

      for(var item in userTaskList) {
        map.add({
          "name" : item["name"]??"",
          "emailId" : item["emailId"]??"",
          "uploadWorkUri" : item["uploadWorkUri"]??"",
          "userId":item["userId"] ??"",
          "phoneNo" :item["phoneNo"] ??"",
          "resumeUri" : item["resumenUri"] ?? ""
        });
      }
      map.add({
        "name" : name,
        "emailId" :emailCont.text,
        "phoneNo" : phoneNo,
        "userId" : userId,
        "resumeUri" :resumeUri
      });

      Map<String,dynamic> updatedPost = {
        "appliedBy" : map
      };
      internshipList[widget.snapshot.documentID] = false;
      await _firestore.collection("Users").document(phoneNo).setData({
        "internshipList" : internshipList
      });
      await _firestore.collection("Posts").document("Internship").collection("Internship").document(widget.snapshot.documentID)
          .setData(updatedPost,merge: true)
          .whenComplete(() {
        appliedInternship.add(widget.snapshot.documentID);
        prefs.setStringList("appliedInternship", appliedInternship);
        islocalAplied = true;
      })
          .catchError((error){
        islocalAplied = false;
      });
      if(islocalAplied == true) {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: "Applied successfully",
        backgroundColor: Colors.green,textColor: Colors.white
        );
      }
      else {
        Fluttertoast.showToast(msg: "getting some error",
            backgroundColor: Colors.red,textColor: Colors.white
        );
      }
    }
    catch(e) {
      debugPrint("Exception : (applyPostService) -> $e");
    }
    CommonFunction().showProgressDialog(isShowDialog: false, context: context);
  }

}

