import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:markBoot/common/commonFunc.dart';
import 'package:markBoot/common/common_widget.dart';
import 'package:markBoot/common/style.dart';
import 'package:markBoot/pages/homeScreen/adminPages/taskUserList_page.dart';

class OffersPageTab extends StatefulWidget {

  bool isRedirectFromProfile;
  Map<String,dynamic> docList ;

  OffersPageTab({this.docList,this.isRedirectFromProfile});

  @override
  _OffersPageTabState createState() => _OffersPageTabState();
}

class _OffersPageTabState extends State<OffersPageTab>with SingleTickerProviderStateMixin {

  List<DocumentSnapshot> cashbackDocumentList ;
  List<DocumentSnapshot> on500DocumentList ;
  List<DocumentSnapshot> couponsDocumentList ;
  TabController _tabController ;
  List<Map<String,dynamic>> cashbackMapList = new List();
  List<Map<String,dynamic>> on500MapList = new List();
  List<Map<String,dynamic>> couponsMapList = new List();

  List<int> cardColor = [CommonStyle().cardColor1,CommonStyle().cardColor2,CommonStyle().cardColor3,CommonStyle().cardColor4];



  Future<void> _onCashbackRefresh() async{
    cashbackDocumentList = await CommonFunction().getPost("Posts/Offers/Cashbacks");

    return;
  }
  Future<void> _on500Refresh() async{
    on500DocumentList = await CommonFunction().getPost("Posts/Offers/50 on 500");
    setState(() {

    });
    return;
  }
  Future<void> _onCouponsRefresh() async{
    on500DocumentList = await CommonFunction().getPost("Posts/Offers/Coupons");
    setState(() {

    });
    return;
  }

  init() async {
    try {
      cashbackDocumentList = await CommonFunction().getPost("Posts/Offers/Cashbacks");
      setState(() {

      });
      on500DocumentList = await CommonFunction().getPost("Posts/Offers/50 on 500");

      setState(() {

      });
      couponsDocumentList = await CommonFunction().getPost("Posts/Offers/Coupons");
      setState(() {

      });
    }
    catch(e) {
      debugPrint("Exception : (init)-> $e");
    }
  }

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
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
            title: Text(widget.isRedirectFromProfile == true ?"Applied" : "Offers",
              style: TextStyle(color: Colors.white),
            ),
            bottom: TabBar(
              labelColor:Color(CommonStyle().lightYellowColor),
              unselectedLabelColor: Colors.grey,
              controller: _tabController,
              tabs: <Widget>[
                // moneyback- cashbacks ,wow offers-50 on 500,top offers - coupons
                Tab(
                  child: Text("Moneyback"),
                ),
                Tab(
                    child: Text("Wow Offers")
                ),
                Tab(
                    child: Text("Top Offers")
                ),
              ],
            )
        ),
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            cashbackWidget(),
            on500Widget(),
            couponsWidget(),
          ],
        )
    );
  }

  cashbackWidget() {
    int index =0;
    return RefreshIndicator(
      onRefresh: _onCashbackRefresh,
      child: CustomScrollView(
        primary: false,
        slivers: <Widget>[
          cashbackDocumentList !=null && cashbackDocumentList.length >0 ?
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverGrid.count(
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              childAspectRatio: 2/3,
              children: cashbackDocumentList.map((item) {
                index++;
                return  singleCard(item,context,"Admin",path: "Posts/Offers/Cashbacks",snapshots: cashbackDocumentList);
              }).toList(),
            ),
          ) :
          (
              cashbackDocumentList == null ?
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
  on500Widget() {
    int index =0;
    return RefreshIndicator(
      onRefresh: _onCashbackRefresh,
      child: CustomScrollView(
        primary: false,
        slivers: <Widget>[
          on500DocumentList !=null && on500DocumentList.length >0 ?
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverGrid.count(
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              childAspectRatio: 2/3,
              children: on500DocumentList.map((item) {
                index++;
                return  singleCard(item,context,"Admin",path : "Posts/Offers/50 on 500",snapshots: on500DocumentList);
              }).toList(),
            ),
          ) :
          (
              on500DocumentList == null ?
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
  couponsWidget() {
    int index =0;
    return RefreshIndicator(
      onRefresh: _onCashbackRefresh,
      child: CustomScrollView(
        primary: false,
        slivers: <Widget>[
          couponsDocumentList !=null && couponsDocumentList.length >0 ?
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverGrid.count(
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              childAspectRatio: 2/3,
              children: couponsDocumentList.map((item) {
                index++;
                return  singleCard(item,context,"Admin",path: "Posts/Offers/Coupons",snapshots: couponsDocumentList);
              }).toList(),
            ),
          ) :
          (
              couponsDocumentList == null ?
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

  Widget singleCard(DocumentSnapshot snapshot,context,postType,{subtype,path,snapshots} ) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10)
          ),
          child: Material(
              borderRadius: BorderRadius.circular(10),
              color: Colors.blue,
              child: InkWell(
                onTap: (){
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context)=>TaskUserListPage(taskUserList: snapshot["offersSubmittedBy"] ?? new List(),)
                    ));

                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Color(CommonStyle().blueCardColor),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(snapshot["imgUri"])
                              )
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4,right: 2,top: 2,bottom: 2),
                        child: Text(snapshot["companyName"] ?? "",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                        height: 50,
                        child: Text(snapshot["taskTitle"],
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 10
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
          ),
        ),
        Positioned(
            top: 5,
            right: 8,
            child: CircleAvatar(
              backgroundColor:Colors.green,
              radius: 18,
              child: Text(snapshot["offersSubmittedBy"] == null ? "0" : snapshot["offersSubmittedBy"].length.toString(),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15
                ),
              ),
            )
        ),
        Positioned(
            top: 5,
            left: 8,
            child: CircleAvatar(
              backgroundColor:Colors.grey,
              radius: 18,
              child: IconButton(
                icon: Icon(Icons.delete,size: 20,color: Colors.red,),
                onPressed: ()async{
                  try{
                    CommonFunction().showProgressDialog(isShowDialog: true, context: context);
                    await Firestore.instance.collection(path).document(snapshot.documentID).delete();
                    Fluttertoast.showToast(msg: "delete successfully",
                        textColor: Colors.white,backgroundColor: Colors.green
                    );
                    CommonFunction().showProgressDialog(isShowDialog: false, context: context);
                    snapshots.remove(snapshot);
                    setState(() {

                    });
                  }
                  catch(e){

                  }
                },
              ),
            )
        )
      ],
    );
  }

}
