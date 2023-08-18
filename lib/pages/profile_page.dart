import 'dart:io';
import 'dart:core';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clone_insta/services/auth_service.dart';
import 'package:clone_insta/services/db_service.dart';
import 'package:clone_insta/services/file_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/member_model.dart';
import '../models/post_model.dart';
import '../services/utils_servise.dart';
class MyProfilePage extends StatefulWidget {
  final PageController? pageController;
  const MyProfilePage({Key? key,this.pageController}):super(key:key);
  static final String id = 'myprofile_page';

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {

  bool isLoading = false;
  List <Post> items = [];
  File? _image;
  int axisCount = 1;
  String fullname ='', email ='', img_url='';
  int count_post= 0,cout_followers=0, count_following=0;


  final ImagePicker _picker = ImagePicker();
  _imageFromGallary()async {
    XFile? image = await _picker.pickImage(
        imageQuality: 50, source: ImageSource.gallery);
    setState(() {
      _image = File(image!.path);
    });
    _apiChangePhoto();
  }

  _imageFromCamera() async {
    XFile? image = await _picker.pickImage(
        imageQuality: 50, source: ImageSource.camera);
    setState(() {
      _image = File(image!.path);
    });
    _apiChangePhoto();
  }


  void _apiChangePhoto(){
    if(_image == null)return;
    setState(() {
      isLoading =true;
    });
    FileService.uploadUserImages(_image!).then((downloadUrl) => {
      _apiUpdateUser(downloadUrl),
    });
  }


  _apiUpdateUser(String downloadUrl)async{
    Member member = await DBService.loadMember();
    member.img_url = downloadUrl;
    await DBService.updateMember(member);
    _apiloadMember();
  }

  void _apiloadMember(){
    setState(() {
      isLoading =true;
    });
    DBService.loadMember().then((value) => {
      _showMemberInfo(value),
    });
  }

   void _showMemberInfo(Member member) {
     setState(() {
       isLoading = true;
       this.fullname = member.fullname!;
       this.email = member.email!;
       this.img_url = member.img_url!;
       this.count_following =member.following_count!;
       this.cout_followers =member.followers_count!;

     });
   }


  void _apiloadFeeds() {
    setState(() {
      isLoading = true;
    });
    DBService.loadPosts().then((value) => {
      _resLoadPosts(value),
    });
  }

  void _resLoadPosts(List<Post> posts){
    items = posts;
    count_post = posts.length;
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


  void _showPicker(context){
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context){
          return SafeArea(
            child: Container(
              child: Wrap(
                children: [
                  ListTile(
                    leading: Icon(Icons.photo_library,color: Colors.grey,),
                    title: Text("Image from gallery"),
                    onTap: (){
                      _imageFromGallary();
                      Navigator.of(context).pop;
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.camera_alt_outlined,color: Colors.grey,),
                    title: Text("Image from Camera"),
                    onTap: (){
                      _imageFromCamera();
                      Navigator.of(context).pop;
                    },
                  )
                ],
              ),
            ),
          );
        }
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiloadMember();
    _apiloadFeeds();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Profile",style: TextStyle(color: Colors.black,fontSize: 25,fontFamily: "Billabong"),),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
          onPressed: (){
            AuthService.signOutUser(context);
          },
              icon: Icon(Icons.exit_to_app,color:Color.fromRGBO(193, 53, 132,1),),
          ),
          SizedBox(width: 10,),
        ],
      ),
      body:
            Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height:3,),
                        //profile pick
                        GestureDetector(
                            onTap: () {
                              _showPicker(context);
                            },
                            child: Stack(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(70),
                                    border: Border.all(
                                      width: 1.5,
                                      color: Color.fromRGBO(193, 53, 132, 1),
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(35),
                                    child: img_url.isEmpty
                                        ? Image(
                                      image: AssetImage(
                                          "assets/images/ic_person.png"),
                                      width: 70,
                                      height: 70,
                                      fit: BoxFit.cover,
                                    )
                                        : Image.network(img_url,
                                      height: 70,
                                      width: 70,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 80,
                                  height: 80,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Icon(
                                        Icons.add_circle,
                                        color: Colors.purple,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            )),

                        SizedBox(height: 3,),
                        //person info
                        Text('${fullname.toLowerCase()}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.black),),
                        SizedBox(height: 3,),
                        Text('${email}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.grey.shade800),),
                        SizedBox(height: 3,),
                        //My Counts
                        Container(
                          margin: EdgeInsets.only(top: 3),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Text("${count_post}",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),),
                                    Text("POSTS",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),),
                                  ],
                                ),
                              ),
                              Container(height: 25,width: 1,color: Colors.black,),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text("${cout_followers}",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),),
                                    Text("FOLLOWERS",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),),
                                  ],
                                ),
                              ),
                              Container(height: 25,width: 1,color: Colors.black,),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text("${count_following}",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),),
                                    Text("FOLLOWING",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        Row(
                          children: [
                            Expanded(child: IconButton(onPressed: (){
                              setState(() {
                                axisCount = 1;
                              });
                            },
                                icon: Icon(Icons.list_alt,color: Colors.grey.withOpacity(0.7),)), ),
                            Expanded(child: IconButton(onPressed: (){
                              setState(() {
                                axisCount = 2;
                              });
                            },
                                icon: Icon(Icons.grid_view_sharp,color: Colors.grey.withOpacity(0.7),)), ),
                          ],
                        ),

                        //my posts
                       Expanded(
                            child: GridView.builder(
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: axisCount,
                                ),
                                itemCount: items.length,
                                itemBuilder: (ctx,index){
                                  return _itemOfPosts(items[index]);
                                }
                            ),

                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),

    );
  }
  Widget _itemOfPosts(Post post){
    return GestureDetector(
      onLongPress: (){
        _dialogRemovePosts(post);
      },
      child: Container(
        margin: EdgeInsets.all(3),
        child: Column(
          children: [
            Expanded(
              child:  Container(

                width: double.infinity,
                child: CachedNetworkImage(
                  width: double.infinity,
                  imageUrl: post.img_post.toString(),
                  placeholder: (context,url,) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context,url,error){
                    return Icon(Icons.error);
                  },
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 3,),
            Text(post.caption.toString(),style: TextStyle(color: Colors.black.withOpacity(0.7),),maxLines: 2,),
          ],
        ),
      ),
    );
  }
}
