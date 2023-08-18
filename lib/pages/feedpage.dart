import 'package:cached_network_image/cached_network_image.dart';
import 'package:clone_insta/services/db_service.dart';
import 'package:clone_insta/services/utils_servise.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import '../models/post_model.dart';

class MyFeedPage extends StatefulWidget {
  final PageController? pageController;

  const MyFeedPage({Key? key, this.pageController}) : super(key: key);
  static final String id = "myfeed_page";

  @override
  State<MyFeedPage> createState() => _MyFeedPageState();
}

class _MyFeedPageState extends State<MyFeedPage> {
  bool isLoading = false;
  List<Post> items = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiloadFeeds();
  }

  void _apiloadFeeds() {
    setState(() {
      isLoading = true;
    });
    DBService.loadFeeds().then((value) => {
          _resLoadFeeds(value),
        });
  }


  void _apiPostLike(Post post)async{
    setState(() {
      isLoading = true;
    });

    await DBService.likePost(post ,true);
    setState(() {
      isLoading = false;
      post.liked = true;
    });

  }

  void _apiPostUnLike(Post post)async{
    setState(() {
      isLoading = true;
    });

    await DBService.likePost(post ,false);
    setState(() {
      isLoading = false;
      post.liked = false;
    });
  }

  void _dialogRemovePosts(Post post)async{
    var result = await Utils.dialogCommon(context, "Insta Clone", "Do you want delete this post", false);
    if(result != null && result){
      setState(() {
        isLoading=true;
      });
      DBService.removePost(post).then((value) => (){
        _apiloadFeeds();
      });
    }
  }


  _resLoadFeeds(List<Post> posts) {
    setState(() {
      items = posts;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Instagram",
          style: TextStyle(
              color: Colors.black, fontFamily: 'Billabong', fontSize: 30),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              widget.pageController!.animateToPage(2,
                  duration: Duration(microseconds: 200), curve: Curves.easeIn);
            },
            icon: Icon(
              Icons.camera_alt,
              color: Color.fromRGBO(193, 53, 132, 1),
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: items.length,
            itemBuilder: (ctx, index) {
              return _itemOfPost(items[index]);
            },
          ),

          isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _itemOfPost(Post post) {
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
                      child: post.img_user.isEmpty
                          ? Image(
                              height: 40,
                              width: 40,
                              image: AssetImage("assets/images/ic_person.png"),
                            )
                          : Image.network(
                              post.img_user,
                              height: 40,
                              width: 40,
                              fit: BoxFit.cover,
                            ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${post.fullname}",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                        Text(
                          "${post.date}",
                          style: TextStyle(fontSize: 10),
                        )
                      ],
                    ),
                  ],
                ),
              post.mine ?IconButton(
                    onPressed: () {
                      _dialogRemovePosts(post);
                    },
                    icon: Icon(
                      Icons.more_horiz_rounded,
                      color: Colors.black,
                    )):SizedBox.shrink(),
              ],
            ),
          ),
          SizedBox(
            height: 8,
          ),
          //Image
          CachedNetworkImage(
            imageUrl: post.img_post.toString(),
            placeholder: (context, url) {
              return CircularProgressIndicator();
            },
            errorWidget: (context, url, error) {
              return Icon(
                Icons.error,
              );
            },
            fit: BoxFit.cover,
          ),
          SizedBox(
            height: 3,
          ),
          //Like and Share Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if(!post.liked){
                        _apiPostLike(post);
                      }else{
                        _apiPostUnLike(post);
                      }
                    },
                    icon: post.liked? Icon(
                      EvaIcons.heart,
                      color: Colors.red,
                    ):
                    Icon(
                      EvaIcons.heartOutline,
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      EvaIcons.shareOutline,
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  EvaIcons.bookmark,
                  color: Colors.grey,
                ),
              ),
            ],
          ),

          //Captions
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: RichText(
              softWrap: true,
              overflow: TextOverflow.visible,
              text: TextSpan(
                  text: "${post.caption}",
                  style: TextStyle(
                    color: Colors.black,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
