import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import '../models/post_model.dart';


class MyFeedPage extends StatefulWidget {
  final PageController? pageController;
  const MyFeedPage({Key? key, this.pageController}):super(key : key);
  static final String id= "myfeed_page";
  @override
  State<MyFeedPage> createState() => _MyFeedPageState();
}
class _MyFeedPageState extends State<MyFeedPage> {

   String img1 = "https://images.unsplash.com/photo-1625397982479-20bdac63537b";
   String img2 = "https://images.unsplash.com/photo-1650285313450-39cd35418322";
   String img3 = "https://images.unsplash.com/photo-1618091171668-e1c3cf1ffce2";
   bool isLoading = false;
   List <Post> items = [];


     @override
  void initState() {
    // TODO: implement initState
    super.initState();
    items.add(Post(img1, "new car"));
    items.add(Post(img2, "This is my old car style"));
    items.add(Post(img3, "This is my after car style"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Instagram",style: TextStyle(color: Colors.black,fontFamily: 'Billabong',fontSize: 30),),
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: (){
                widget.pageController!.animateToPage(2, duration: Duration(microseconds: 200), curve: Curves.easeIn);
              },
              icon:Icon(Icons.camera_alt,color:  Color.fromRGBO(193, 53, 132,1),),
          ),
          SizedBox(width: 10,),
        ],
      ),

      body: Stack(
        children: [
          ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: items.length,
            itemBuilder: (ctx,index){
              return _itemOfPost(items[index]);
            },
          ),
          isLoading? Center(child: CircularProgressIndicator(),):SizedBox.shrink(),
        ],
      ),
    );
  }
  Widget _itemOfPost (Post post){
     return Container(
       color: Colors.white,
       child: Column(
         children: [
           Divider(),
           //user info
           Container(
             padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Image(
                        height: 40,
                        width: 40,
                        image: AssetImage("assets/images/ic_person.png"),
                      ),
                    ),
                    SizedBox(width: 4,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Ganiyev Sarvarbek",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 14),),
                        Text("2023-06-25 20:05",style: TextStyle(fontSize: 10),)
                      ],
                    ),
                  ],
                ),
                IconButton(
                    onPressed: (){},
                    icon: Icon(Icons.more_horiz_rounded,color: Colors.black,)),
              ],
            ),
          ),
           SizedBox(height: 8,),
           CachedNetworkImage(
               imageUrl: post.imgpost.toString(),
             placeholder: (context,url){
                 return CircularProgressIndicator();
             },
             errorWidget: (context,url,error){
                 return Icon(Icons.error,);
             },
             fit: BoxFit.cover,
           ),
           SizedBox(height: 3,),
           //Like and Share Buttons
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               Row(
                 children: [
                   IconButton(
                       onPressed: (){},
                       icon: Icon(EvaIcons.heartOutline,color: Colors.grey,),
                   ),

                   IconButton(
                     onPressed: (){},
                     icon: Icon(EvaIcons.shareOutline,color: Colors.blueAccent,),
                   ),
                 ],
               ),
               IconButton(
                   onPressed: (){},
                   icon: Icon(
                     EvaIcons.bookmark,
                     color: Colors.grey,
                   ),),
             ],
           ),
           //Captions
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(left: 10,right: 10,bottom: 10),
            child:  RichText(
              softWrap: true,
              overflow: TextOverflow.visible,
              text: TextSpan(
                  text: "${post.caption}",
                  style: TextStyle(color: Colors.black,)

              ),
            ),
          ),
         ],
       ),
     );
  }
}
