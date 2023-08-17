import 'package:cached_network_image/cached_network_image.dart';
import 'package:clone_insta/services/db_service.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import '../models/post_model.dart';
class MyLikesPage extends StatefulWidget {
  final PageController? pageController;
  const MyLikesPage({Key? key, this.pageController}):super(key : key);
  static final String id = 'mylikes_page';

  @override
  State<MyLikesPage> createState() => _MyLikesPageState();
}

class _MyLikesPageState extends State<MyLikesPage> {
  bool isLoading = false;
  List<Post> items = [];


  void _apiLoadLike()async {
    setState(() {
      isLoading = true;
    });
    DBService.loadLikes().then((value) => {
      _resLoadPost(value),
    });
  }

   void _resLoadPost(List<Post> posts) {
    setState(() {
      items = posts;
      isLoading = false;
    });
  }

  void _apiUnlikePosts(Post post){
    setState(() {
      isLoading =true;
          post.liked = false;
    });
    DBService.likePost(post, false).then((value) => {
      _apiLoadLike(),
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiLoadLike();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Likes", style: TextStyle(color: Colors.black,fontFamily: 'Billabong',fontSize: 30)),

        elevation: 0,
        backgroundColor: Colors.white,

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
                      child: post.img_user.isEmpty ? Image(
                        height: 40,
                        width: 40,
                        image: AssetImage("assets/images/ic_person.png"),
                      ):Image.network( post.img_user, height: 40,width: 40,fit: BoxFit.cover,),
                    ),
                    SizedBox(width: 4,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${post.fullname}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 14),),
                        Text("${post.date}",style: TextStyle(fontSize: 10),)
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
            width: MediaQuery.of(context).size.width,
            imageUrl: post.img_post,
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
                    onPressed: (){
                      _apiUnlikePosts(post);
                    },
                    icon: post.liked?Icon(EvaIcons.heart,color: Colors.red,):Icon(EvaIcons.heart,color: Colors.black,)
                  ),
                  SizedBox(width: 10,),
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
