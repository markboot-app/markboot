import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:markBoot/common/commonFunc.dart';
import 'package:markBoot/common/common_widget.dart';
import 'package:markBoot/common/style.dart';

class PostListUIPage extends StatefulWidget {
  @override
  
  Map<String,dynamic> docMap= new Map<String,dynamic>();
  Map<String,dynamic> campaignMap= new Map<String,dynamic>();
  String path;
  String type;
  String subType;
  PostListUIPage({this.docMap,this.path,this.type,this.subType,this.campaignMap});
  
  _PostListUIPageState createState() => _PostListUIPageState();
}

class _PostListUIPageState extends State<PostListUIPage>with SingleTickerProviderStateMixin {

  List<DocumentSnapshot> taskDocumentList ;
  List<DocumentSnapshot> campaignDocumentList ;
  TabController _tabController ;

  List<DocumentSnapshot> appliedSnapshot ;
  List<DocumentSnapshot> appliedCampaign = new List();



  init() async {
    try {
      taskDocumentList = await CommonFunction().getPost(widget.path) ?? new List();
      if(widget.type.contains("Gigs")) {
        campaignDocumentList =
        await CommonFunction().getPost("Posts/Gigs/Campaign");
        for(DocumentSnapshot snapshot in campaignDocumentList) {
          if(widget.campaignMap.containsKey(snapshot.documentID)) {
            appliedCampaign.add(snapshot);
          }
        }

      }
      if(taskDocumentList.length>0) appliedSnapshot = new List();
      for(DocumentSnapshot snapshot in taskDocumentList) {
        if(widget.docMap.containsKey(snapshot.documentID)) {
          appliedSnapshot.add(snapshot);
        }
      }
      setState(() {

      });
    }
    catch(e) {
      debugPrint("Exception : (init)-> $e");
    }
  }

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
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
            title: Text("Applied",

            ),
            bottom:widget.type.contains("Gigs") ?  TabBar(
              controller: _tabController,
              tabs: <Widget>[
                Tab(
                  child: Text("Gigs"),
                ),
                Tab(
                    child: Text("Campaigns")
                ),
              ],
            ) :null
        ),
        body: widget.type.contains("Gigs") == false ?
            postUI()
            : TabBarView(
          controller: _tabController,
          children: <Widget>[
            postUI(),
            campaignsWidget(),
          ],
        )

    );
  }

  campaignsWidget() {
    return  CustomScrollView(
      primary: false,
      slivers: <Widget>[
        appliedCampaign !=null && appliedCampaign.length >0 ?
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverGrid.count(
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 2,
            childAspectRatio: 2/3,
            children: appliedCampaign.map((item) {
              return CommonWidget().commonCard(item,context,"Gigs",subtype: "Campaign");
            }).toList(),
          ),
        ) :
        (
            appliedCampaign == null ?
            SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.only(top: 50),
                  child: Center(
                    child: Container(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator()),
                  ),
                )
            )
                : SliverToBoxAdapter(
              child: Container(
                height: MediaQuery.of(context).size.height-200,
                child: Center(
                  child: Container(
                    child: Text("No Data Found",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight:FontWeight.bold,
                          fontSize: 18
                      ),
                    ),
                  ),
                ),
              ),
            )
        ),
      ],
    );
  }
  postUI() {
    return  CustomScrollView(
      primary: false,
      slivers: <Widget>[
        appliedSnapshot !=null && appliedSnapshot.length >0 ?
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverGrid.count(
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 2,
            childAspectRatio: 2/3,
            children: appliedSnapshot.map((item) {
              return CommonWidget().commonCard(item,context,widget.type,subtype: widget.subType,disable:true);
            }).toList(),
          ),
        ) :
        (
            appliedSnapshot == null ?
            SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.only(top: 50),
                  child: Center(
                    child: Container(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator()),
                  ),
                )
            )
                : SliverToBoxAdapter(
              child: Container(
                height: MediaQuery.of(context).size.height-200,
                child: Center(
                  child: Container(
                    child: Text("No Data Found",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight:FontWeight.bold,
                          fontSize: 18
                      ),
                    ),
                  ),
                ),
              ),
            )
        ),
      ],
    );
  }
}
