import 'dart:io';

import 'package:clone_insta/services/auth_service.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FileService {
  static final _storage = FirebaseStorage.instance.ref();
  static final folder_user = "user_images";
  static final folder_post = "post_images";

  static Future<String> uploadUserImages(File _image) async {
    String uid = AuthService.currentUserId();
    String image_name =uid;
    var firebaStorageRef = _storage.child(folder_user).child(image_name);
    var uploadTask =firebaStorageRef.putFile(_image);
    final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => {});
    final String downloadUrl =  await firebaStorageRef.getDownloadURL();
    print(downloadUrl);
    return downloadUrl;
  }

  static Future<String> uploadPostImages(File _image) async {
    String uid = AuthService.currentUserId();
    String image_name =uid + "_"+ DateTime.now.toString();
    var firebaStorageRef = _storage.child(folder_post).child(image_name);
    var uploadTask =firebaStorageRef.putFile(_image);
    final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => {});
    final String downloadUrl =  await firebaStorageRef.getDownloadURL();
    print(downloadUrl);
    return downloadUrl;
  }

}