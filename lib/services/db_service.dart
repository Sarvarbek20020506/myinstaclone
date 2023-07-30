import 'package:clone_insta/models/member_model.dart';
import 'package:clone_insta/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'utils_servise.dart';

class DBService{
  static final _firestore = FirebaseFirestore.instance;

  static String folder_users = 'users';
  static  Future storeMember(Member member)async{
    member.uid = AuthService.currentUserId();
    Map<String,String> params = await Utils.deviceParams();
    print(params);

    member.device_id = params['device_id'];
    member.device_type = params['device_type'];
    member.device_token = params['device_token'];

    return _firestore.collection(folder_users).doc(member.uid).set(member.toJson());
  }

}