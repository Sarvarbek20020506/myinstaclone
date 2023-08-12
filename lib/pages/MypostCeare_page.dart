import 'dart:io';
import 'package:clone_insta/services/db_service.dart';
import 'package:clone_insta/services/file_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/post_model.dart';
class MyPostCreatePage extends StatefulWidget {
  final PageController? pageController;
  const MyPostCreatePage({Key? key,this.pageController}):super(key:key);
  static final String id = "mypostcreate_page";

  @override
  State<MyPostCreatePage> createState() => _MyPostCreatePageState();
}

class _MyPostCreatePageState extends State<MyPostCreatePage> {
  bool isLoading = false;
  File? _image;
  var captionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  _imageFromGallary()async {
    XFile? image = await _picker.pickImage(
        imageQuality: 50, source: ImageSource.gallery);
    setState(() {
      _image = File(image!.path);
    });
  }
  _imageFromCamera() async {
    XFile? image = await _picker.pickImage(
        imageQuality: 50, source: ImageSource.camera);
    setState(() {
      _image = File(image!.path);
    });
  }

  _upLoadNewPost(){
    print('no problem1');
    //String caption = captionController.text.toString().trim();
   // if(caption.isEmpty)return;
    if(_image == null)return;
    _apiPostImg();
  }

  _moveFeed(){
    setState(() {
      isLoading = false;
    });
    print("mowe");
    captionController.text = "";
    _image = null;
    widget.pageController!.animateToPage(0, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
  }

  void _apiPostImg()async{
    setState(() {
      isLoading = false;
    });
    FileService.uploadPostImages(_image!).then((dawnloadUrl) => {
      _resPostImage(dawnloadUrl),
    });
  }

  void _resPostImage(String dawnloadUrl){
     String caption = captionController.text.toString().trim();
     Post post = Post(caption,dawnloadUrl);
     _apiStorePost(post);
  }

  void _apiStorePost(Post post)async{
    //Posted

    Post posted = await DBService.storePost(post);
    //feeded
    DBService.storeFeeds(posted).then((value) => {
      _moveFeed(),
    });

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
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white,
        title: Text("Upload",style: TextStyle(fontFamily: "Billabong",color: Colors.black,fontSize: 30),),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: (){
                _upLoadNewPost();
                setState(() {
                  isLoading = true;
                });
              },
              icon: Icon(Icons.drive_folder_upload,color: Color.fromRGBO(193, 53, 132,1),)),
          SizedBox(width: 10,),
        ],
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: (){
                      _showPicker(context);
                    },
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.width,
                      color: Colors.grey.withOpacity(0.4),
                      child: _image == null? Center(
                        child: Icon(Icons.add_a_photo,color: Colors.grey,size: 35,),
                      ):Stack(
                        children: [
                          Image.file(_image!,
                           width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: (){
                                    setState(() {
                                      _image = null;
                                    });
                                  },
                                  icon: Icon(Icons.highlight_remove,color: Colors.red,),),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),


                  Container(
                    child: TextField(
                      controller: captionController,
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: "Captions",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          isLoading
              ? Center(
            child: CircularProgressIndicator(),
          )
              : SizedBox.shrink(),
        ],
      )
    );
  }
}
