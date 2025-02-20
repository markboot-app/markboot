import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:markBoot/common/commonFunc.dart';
import 'package:markBoot/common/common_widget.dart';
import 'package:markBoot/common/style.dart';

class GigsPageTab extends StatefulWidget {
  @override
  _GigsPageTabState createState() => _GigsPageTabState();
}

class _GigsPageTabState extends State<GigsPageTab>with SingleTickerProviderStateMixin {

  List<DocumentSnapshot> taskDocumentList ;
  List<DocumentSnapshot> campaignDocumentList ;
  TabController _tabController ;
  List<int> cardColor = [CommonStyle().cardColor1,CommonStyle().cardColor2,CommonStyle().cardColor3,CommonStyle().cardColor4];


  Future<void> _onTaskRefresh() async{
    taskDocumentList = await CommonFunction().getPost("Posts/Gigs/Tasks");
    setState(() {

    });
    return;
  }
  Future<void> _onCampaignRefresh() async{
    taskDocumentList = await CommonFunction().getPost("Posts/Gigs/Campaign");
    setState(() {

    });
    return;
  }

  init() async {
    try {
      taskDocumentList = await CommonFunction().getPost("Posts/Gigs/Tasks");
      campaignDocumentList = await CommonFunction().getPost("Posts/Gigs/Campaign");
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
            title: Text("Gigs",
            ),
            bottom: TabBar(
              labelColor:Colors.white,
              unselectedLabelColor: Colors.black,
              controller: _tabController,
              tabs: <Widget>[
                Tab(
                  child: Text("Gigs"),
                ),
                Tab(
                    child: Text("Campaigns")
                ),
              ],
            )
        ),
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            taskWidget(),
            campaignsWidget()
          ],
        )
    );
  }

  campaignsWidget() {
    int index = 0;
    return RefreshIndicator(
      onRefresh: _onCampaignRefresh,
      child: CustomScrollView(
        primary: false,
        slivers: <Widget>[
          campaignDocumentList !=null && campaignDocumentList.length >0 ?
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverGrid.count(
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              childAspectRatio: 2/3.5,
              children: campaignDocumentList.map((item) {
                index++;
                return CommonWidget().commonCard(item,context,"Gigs",subtype: "Campaign",cardColor:cardColor[(index-1)%4] );
              }).toList(),
            ),
          ) :
          (
              campaignDocumentList == null ?
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
      ),
    );
  }

  taskWidget() {
    int index = 0;
    return RefreshIndicator(
      onRefresh: _onTaskRefresh,
      child: CustomScrollView(
        primary: false,
        slivers: <Widget>[
          taskDocumentList !=null && taskDocumentList.length >0 ?
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverGrid.count(
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              childAspectRatio: 2/3.5,
              children: taskDocumentList.map((item) {
                index++;
                return CommonWidget().commonCard(item,context,"Gigs",subtype: "Tasks",cardColor: cardColor[(index-1)%4]);
              }).toList(),
            ),
          ) :
          (
              taskDocumentList == null ?
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
      ),
    );
  }
}

