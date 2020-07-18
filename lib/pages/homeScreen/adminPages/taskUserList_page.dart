import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:markBoot/common/style.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'admin_homepage.dart';

class TaskUserListPage extends StatefulWidget {

  List taskUserList ;
  String reward;
  String docId;
  TaskUserListPage({this.taskUserList,this.reward,this.docId});

  @override
  _TaskUserListPageState createState() => _TaskUserListPageState();
}

class _TaskUserListPageState extends State<TaskUserListPage> with WidgetsBindingObserver{

  String _localPath;
  bool isShowDownloadBar = false;

  Future<String> _findLocalPath() async {
    final directory = await getExternalStorageDirectory();
    return directory.path;
  }


  init() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    _localPath = (await _findLocalPath()) + Platform.pathSeparator + 'Download';

    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }

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
      backgroundColor: Color(CommonStyle().backgroundColor),
      appBar: AppBar(
        backgroundColor: Color(CommonStyle().appbarColor),
        title:  Text("User List",
          style: TextStyle(
              color: Colors.white,
              fontSize: 18
          ),
        ),
      ),
      body: widget.taskUserList.length> 0 ? Container(
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.symmetric(horizontal: 10,),
        child: ListView.builder(
            itemCount: widget.taskUserList.length,
            itemBuilder: (context,index){
              return taskUserCard(widget.taskUserList[index]);
            }),
      ) :
          Center(
            child: Container(
              height: 30,
              child: Text("No user found",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20
              ),
              ),
            ),
          )
    );
  }
  Widget taskUserCard(Map<String,dynamic> userData) {
    return Container(
      height: 100,
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Color(0xff294073)
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          leftWidget(userData),
          rightWidget(userData)
        ],
      ),
    );
  }

  Widget leftWidget(Map<String,dynamic> userData) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(userData["name"] ?? "",
          style: TextStyle(
            color: Colors.green,
            fontSize: 18
          ),
          ),
          Text(userData["emailId"] ?? "",
          style: TextStyle(
              color: Colors.white,
              fontSize: 12
          ),
          ),
          Text(userData["phoneNo"] ?? "",
            style: TextStyle(
                color: Colors.white,
                fontSize: 12
            ),
          )
        ],
      ),
    );
  }

  Widget rightWidget(Map<String,dynamic> userData) {
    return Row(
      children: <Widget>[
        Container(
          height: 40,
          child: RaisedButton(
            onPressed: (){
              approvedAmount(userData["userId"],widget.reward,userData["phoneNo"],userData);
            },
            child: Row(
              children: <Widget>[
                Text(widget.reward+"Rs."??""),
                SizedBox(
                  width: 4,
                ),
                Text("Verify",
                  style: TextStyle(
                      color: Colors.green
                  ),
                )
              ],
            ),
          ),
        ),
        Container(
            child: IconButton(
              onPressed: (){
                downloadTaskImg(userData["uploadWorkUri"]);
              },
              icon: Icon(Icons.file_download,
                size: 20,color: Colors.white,
              ),
            )
        )
      ],
    );
  }

  showDownloadingBar() async {
    if(isShowDownloadBar == true) {
      return showDialog(context: context,
      builder: (context){
        return Material(
          color: Colors.transparent,
          child: Center(
            child: Container(
              width: 100,
              height: 50,
              child: Row(
                children: <Widget>[
                  Container(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(),
                  ),
                  SizedBox(width: 10,),
                  Text("Downloading...",
                   style: TextStyle(
                     color: Color(CommonStyle().darkBlueColor)
                   ),
                  )
                ],
              ),
            ),
          ),
        );
      }
      );
    }
    else {
      if(Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    }
  }

  Future<void> downloadTaskImg(imgUri)async {
    try {
      isShowDownloadBar = true;
      showDownloadingBar();
      // Saved with this method.
      final taskId = await FlutterDownloader.enqueue(
        url: imgUri,
        savedDir: _localPath,
        showNotification: true, // show download progress in status bar (for Android)
        openFileFromNotification: true, // click on notification to open downloaded file (for Android)
      );
      if(taskId!=null&&taskId.isNotEmpty) {
        Fluttertoast.showToast(msg: "Download successfully",
        backgroundColor: Colors.green,textColor: Colors.white
        );
      }
      else {
        Fluttertoast.showToast(msg: "Download failed",
            backgroundColor: Colors.green,textColor: Colors.white
        );
      }
    } on PlatformException catch (error) {
      print(error);
    }
    isShowDownloadBar = false;
    showDownloadingBar();
  }

  approvedAmount(String userId,approveAmount,userPhoneNo,userData)async{
    debugPrint("DOCID ${widget.docId}");

    try{
      bool isApproved= false;
     QuerySnapshot querySnapshot = await Firestore.instance.collection("Users").getDocuments();
     DocumentSnapshot userDocumentSnapshot;

     if(querySnapshot!=null) {
       for(DocumentSnapshot snapshot in querySnapshot.documents){
         if(snapshot.data["userId"] == userId) {
           userDocumentSnapshot = snapshot;
           break;
         }
       }

       if(userDocumentSnapshot !=null){
         String pendingAmount = userDocumentSnapshot.data["pendingAmount"]??"0";
         debugPrint("PendingAmount : $pendingAmount");
         String approvedAmount = userDocumentSnapshot.data["approvedAmount"]??"0";
         if(int.parse(pendingAmount) > 0) {
           pendingAmount = (int.parse(pendingAmount)-int.parse(approvedAmount)).toString();
           approvedAmount = (int.parse(approvedAmount)+int.parse(approveAmount)).toString();
           debugPrint("RemainPendingAmount $pendingAmount");
           if(int.parse(pendingAmount)<0){
              Fluttertoast.showToast(msg: "try again or contact to admin",
              backgroundColor: Colors.red,textColor: Colors.white
              );
           }
           else {
             isApproved = true;
             Firestore.instance.collection("Users").document(userPhoneNo).setData({
               "approvedAmount" : approvedAmount,
               "pendingAmount" : pendingAmount
             },
                 merge: true
             );
           }
           if(isApproved == true) {
             widget.taskUserList.remove(userData);
             Firestore.instance.collection("Posts").document("Gigs").collection("Tasks").document(widget.docId).
    setData({
               "submittedBy" : widget.taskUserList
             },
             merge: true
             );
             Fluttertoast.showToast(msg: "approved successfully",
             backgroundColor: Colors.green,textColor: Colors.white
             );
             Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
               builder: (context)=>AdminHomePage()
             ), (route) => false);
           }
         }
         else {
           Fluttertoast.showToast(msg: "please contact to admin or try again",
           backgroundColor: Colors.red,textColor: Colors.white
           );
         }
       }
       else {
         Fluttertoast.showToast(msg: "Getting some error,try again or contact to admin",
         textColor: Colors.white,backgroundColor: Colors.red
         );
       }
     }


    }
    catch(e) {
      Fluttertoast.showToast(msg: "Please try again",
      backgroundColor: Colors.red,
        textColor: Colors.white
      );
    }
  }

}
