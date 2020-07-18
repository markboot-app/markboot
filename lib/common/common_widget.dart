import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:markBoot/pages/homeScreen/tab/gigs/tasks_page.dart';
import 'package:markBoot/pages/homeScreen/tab/internship/internship_details.dart';
import 'package:markBoot/pages/homeScreen/tab/offers/cashbacks_page.dart';
import 'package:markBoot/pages/homeScreen/tab/offers/offers_page_details.dart';
import 'package:markBoot/pages/homeScreen/tab/tournament/tournament_details_page.dart';

import 'style.dart';

class CommonWidget {

  List<int> colors = [0xff11232D,0xff1C2D41,0Xff343A4D,0xff4F4641,0xff434343,0xff2A2A28
  ];

  List<int> textColors = [0xff00E676,0xffEEFF41,0xffE0E0E0,0xffffffff];
  List<int> cardColor = [CommonStyle().cardColor1,CommonStyle().cardColor2,CommonStyle().cardColor3,CommonStyle().cardColor4];


  Random random = Random();

  Widget commonTextField({@required TextEditingController controller,String hintText,
    keyboardType = TextInputType.text,obscureText = false,String inputText= "",int lines}){
    return
      Container(
        margin: EdgeInsets.only(top: 8),
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(hintText ?? "",
              style: TextStyle(
                  color: Colors.black
              ),
            ),
            Center(
              child: Container(
                alignment: Alignment.center,
                height: lines==null ? 50 : 100,
                decoration: BoxDecoration(
                  border: Border(

                    bottom: BorderSide(
                      width: 1,
                      color: Colors.white
                    )
                  )
                ),
                child: TextField(
                  maxLines: lines??1,
                  obscureText: obscureText,
                  keyboardType: keyboardType,
                  controller: controller,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18
                  ),
                  decoration: InputDecoration(
                    border:OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey)
                    ),
                    hintText: inputText,
                    hintStyle: TextStyle(
                      color: Colors.grey
                    )
                  ),
                ),
              ),
            )
          ],
        ),
      );
  }

  Widget commonCard(DocumentSnapshot snapshot,context,postType,{subtype,disable = false,int cardColor = 0xff294073} ) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10)
      ),
      child: Material(
        borderRadius: BorderRadius.circular(10),
          color: Color(CommonStyle().blueCardColor),
          child: InkWell(
            onTap: (){
             if(postType.contains("Admin")) {

             }
             else if(subtype.toLowerCase().toString().contains("cashback")) {
               Navigator.push(context, MaterialPageRoute(
                 builder: (context) =>CashbacksPageDetails(snapshot: snapshot,type: "Offers",subType: "Cashbacks",)
               ));
             }
             else if(subtype.toLowerCase().toString().contains("50")) {
               Navigator.push(context, MaterialPageRoute(
                   builder: (context) =>CashbacksPageDetails(snapshot: snapshot,type: "Offers",subType: "50 on 500",)
               ));
             }
             else if(subtype.toLowerCase().toString().contains("coupons")) {
               Navigator.push(context, MaterialPageRoute(
                   builder: (context) =>CashbacksPageDetails(snapshot: snapshot,type: "Offers",subType: "Coupons",)
               ));
             }
             else if(subtype.toLowerCase().toString().contains("internship")) {
               Navigator.push(context, MaterialPageRoute(
                 builder: (context) => InternshipPageDetails(snapshot: snapshot,type: "Internship",subType: "Internship",)
               ));
             }
             else if(subtype.contains("Tournament")) {
               Navigator.push(context, MaterialPageRoute(
                   builder: (context) => TournamentDetailsPage(snapshot: snapshot,type:postType,subType:subtype)
               )).then((value) {
                 if(value == true) {

                 }
               });
             }
             else {
               Navigator.push(context, MaterialPageRoute(
                   builder: (context) => TasksPageDetails(snapshot: snapshot,type:postType,subType:subtype,isDisabled: disable,)
               )).then((value) {
                 if(value == true) {

                 }
               });
             }
            },
            child: Container(
              decoration: BoxDecoration(
                  color:  Color(cardColor),
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
                              fit: BoxFit.fill,
                              image: NetworkImage(snapshot["logoUri"])
                          )
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4,right: 2,top: 2,bottom: 2),
                    child: Text(snapshot["companyName"] ?? "",
                    style: TextStyle(
                      color: Color(CommonStyle().lightYellowColor),
                      fontSize: 18,
                    ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10,vertical: 4),
                    height: 40,
                    child: Text(snapshot["taskTitle"]??"",
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 12
                      ),
                    ),
                  ),
                  Visibility(
                    visible: (postType.contains("Internship"))? false :true,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 10,left: 10,right: 4),
                      child: Row(
                        children: <Widget>[
                          Image.asset("assets/icons/bank.png",width: 20,height: 20,),
                          Text((postType.contains("Offers")?snapshot["cashbackAmount"]:snapshot["reward"])??"0",
                          style: TextStyle(
                            color: Colors.yellow
                          ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
      ),
    );
  }
}
