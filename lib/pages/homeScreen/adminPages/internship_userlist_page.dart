import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:markBoot/common/commonFunc.dart';
import 'package:markBoot/common/style.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InternshipUserListPage extends StatefulWidget {

  List internshipUserList ;
  String docId;
  InternshipUserListPage({this.internshipUserList,this.docId});


  @override
  _InternshipUserListPageState createState() => _InternshipUserListPageState();
}

class _InternshipUserListPageState extends State<InternshipUserListPage> with WidgetsBindingObserver{

  String _localPath;
  bool isShowDownloadBar = false;
  String phoneNo;
  SharedPreferences prefs ;

  Future<String> _findLocalPath() async {
    final directory = await getExternalStorageDirectory();
    return directory.path;
  }



  init() async {
    prefs = await SharedPreferences.getInstance();
    phoneNo = prefs.getString("userPhoneNo") ??"";
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
        backgroundColor: Color(CommonStyle().appbarColor),
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(80),
            child: Container(
              color: Color(CommonStyle().appbarColor),
              margin: EdgeInsets.only(top: 30,left: 10),
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(Icons.arrow_back,color: Colors.white,)),
                  ),

                  Text("User List",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18
                    ),
                  ),
                ],
              ),
            )
        ),
        body: widget.internshipUserList.length> 0 ? Container(
          margin: EdgeInsets.only(top: 10),
          padding: EdgeInsets.symmetric(horizontal: 10,),
          child: ListView.builder(
              itemCount: widget.internshipUserList.length,
              itemBuilder: (context,index){
                return taskUserCard(widget.internshipUserList[index]);
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
    return GestureDetector(
      onTap: (){
        debugPrint("TAP verify");
      },
      child: Container(
        width: 120,
        height: 30,
          child:RaisedButton(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)
            ),
            onPressed: (){
              debugPrint("VVVV ${userData["isVerify"] }");
              if(!(userData["isVerify"] ==true? true : false) ?? false){
//                internshipService(userData);
              debugPrint("UUUUSSEERRDATA $userData");
                downloadTaskImg(userData["resumeUri"] ?? "",userData["phoneNo"]??"");
              }
            },
            child:  Row(
              children: <Widget>[
                Text("Resume",
                  style: TextStyle(
                      color: (userData["isVerify"] ==true? Colors.green : Colors.red) ?? Colors.red,
                      fontSize: 15
                  ),
                ),
                SizedBox(width: 2,),
                Icon(Icons.file_download),
              ],
            )
          )
      ),
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
                  width: 200,
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

  Future<void> downloadTaskImg(imgUri,phoneNo)async {
    try {
      debugPrint("IIMMGG URI ${imgUri}");
      if(imgUri == null) return;
      isShowDownloadBar = true;
      showDownloadingBar();
      // Saved with this method.
      final taskId = await FlutterDownloader.enqueue(
        fileName:"Resume_$phoneNo",
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

  Future<void>internshipService(clickUserData) async {
    try{

      debugPrint("CALL INTERNSHIP");
      CommonFunction().showProgressDialog(isShowDialog: true, context: context);
      List localList = widget.internshipUserList;
      int index = 0;
      for(var item in localList) {
        if(item["phoneNo"] == clickUserData["phoneNo"]) {
          item["isVerify"] = true;
          widget.internshipUserList[index] = item;
          break;
        }
        index++;
      }
      Firestore.instance.collection("Posts").document("Internship").collection("Internship")
      .document(widget.docId).setData({
        "appliedBy" : widget.internshipUserList
      },merge: true);
      debugPrint("PHONE $phoneNo");
      String userPhoneNo = clickUserData["phoneNo"];
      DocumentSnapshot snapshot = await Firestore.instance.collection("Users").document(userPhoneNo).get();
      if(snapshot!=null) {
        Map appliedInternshipList = snapshot.data["internshipList"] ?? Map();
        debugPrint("LLn $appliedInternshipList ${widget.docId}");
        appliedInternshipList[widget.docId] = true;
        snapshot.data["internshipList"] = appliedInternshipList;
        debugPrint("LLIUUUSSSTT ${snapshot.data}");
        await Firestore.instance.collection("Users").document(phoneNo).setData(
          {
            "internshipList" : appliedInternshipList
          },merge: true);
      }
    }
    catch(e) {
      debugPrint("Exception : (InternshipService) -> $e");
    }
    CommonFunction().showProgressDialog(isShowDialog: false, context: context);
  }

}
