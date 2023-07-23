import 'package:flutter/material.dart';

import '../models/member_model.dart';
class MySearchPage extends StatefulWidget {
  const MySearchPage({super.key});
  static final String id ="search_page";

  @override
  State<MySearchPage> createState() => _MySearchPageState();
}

class _MySearchPageState extends State<MySearchPage> {
   bool isLoading = false;
   List <Member> items = [];
   var searchController = TextEditingController();

   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    items.add(Member('Sarvarbek', "ganiyevs@mail.com"));
    items.add(Member('Sardorbek', "aliyevs@mail.com"));
    items.add(Member('Alijon', "valijonovs@mail.com"));
    items.add(Member('Salim', "shukurovs@mail.com"));
    items.add(Member('Nuriddin', "abdumannopovs@mail.com"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search',
          style: TextStyle(
              fontFamily: 'Billabong',
              fontSize: 25),
        ),
      ),
      body: Stack(
        children: [
          Container(
            //height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  margin: EdgeInsets.only(left: 10,top: 10,bottom: 10),
                  height: 45,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 1,color: Colors.grey.withOpacity(0.2)),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search',
                      hintStyle: TextStyle(color: Colors.grey),
                      icon: Icon(Icons.search),
                    ),
                  ),
                ),
                SizedBox(height: 15),
               Expanded(child:  ListView.builder(
                 itemCount: items.length,
                 itemBuilder: (ctx,index){
                   return _itemOfMember(items[index]);
                 },
               ),),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _itemOfMember(Member member){
    return Container(
     height: 65,
      child:Row(
        children: [
         Container(
           child:  ClipRRect(
             borderRadius: BorderRadius.circular(22.5),
             child: Image(image: AssetImage("assets/images/ic_person.png",),
             height: 45,
             width: 45,
             ),
           ),
         ),
          SizedBox(width: 10,),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${member.fullname}",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
              SizedBox(height: 3,),
              Text("${member.email}",style: TextStyle(color: Colors.black54),),
            ],
          ),
          Expanded(
            child: Row(
              //crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 30,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(width: 1,color: Colors.grey),
                  ),
                  child: Center(
                    child: Text("Follow"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget mail(){
     return Container(
       height: 90,
       width: 90,
       child:  Column(
         mainAxisAlignment: MainAxisAlignment.end,
         crossAxisAlignment: CrossAxisAlignment.end,
         children: [
           Icon(Icons.add_circle_outline_outlined,color: Color.fromRGBO(193, 53, 132,1),),
         ],
       ),
     );
  }
}
