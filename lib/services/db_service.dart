import 'dart:async';
import 'package:clone_insta/models/member_model.dart';
import 'package:clone_insta/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/post_model.dart';
import 'utils_servise.dart';

class DBService {
  static final firestore_db = FirebaseFirestore.instance;

  static String folder_users = 'users';
  static String folder_posts = 'posts';
  static String folder_feeds = 'feeds';

  /*
  * Member Related
  * */

  static Future storeMember(Member member) async {
    member.uid = AuthService.currentUserId();
    Map<String, String> params = await Utils.deviceParams();
    print(params);

    member.device_id = params['device_id'];
    member.device_type = params['device_type'];
    member.device_token = params['device_token'];

    return firestore_db
        .collection(folder_users)
        .doc(member.uid)
        .set(member.toJson());
  }

  static Future<Member> loadMember() async {
    String uid = AuthService.currentUserId();
    var value = await firestore_db.collection(folder_users).doc(uid).get();
    Member member = Member.fromJson(value.data()!);

    return member;
  }

  static Future updateMember(Member member) async {
    String uid = AuthService.currentUserId();
    return firestore_db
        .collection(folder_users)
        .doc(uid)
        .update(member.toJson());
  }

  static Future<List<Member>> searchMembers(String keyword) async {
    List<Member> members = [];
    String uid = AuthService.currentUserId();

    var querySnapshot = await firestore_db
        .collection(folder_users)
        .orderBy("email")
        .startAt([keyword]).get();
    print(querySnapshot.docs.length);

    querySnapshot.docs.forEach((result) {
      Member newMember = Member.fromJson(result.data());
      if (newMember.uid != uid) {
        members.add(newMember);
      }
    });
    return members;
  }

  /*
  * Posts Related
  * */

  static Future<Post> storePost(Post post) async {
    Member me = await loadMember();
    post.uid = me.uid;
    post.fullname = me.fullname;
    post.img_user = me.img_url;
    post.date = Utils.currentDate();

    String postId = firestore_db
        .collection(folder_users)
        .doc(me.uid)
        .collection(folder_posts)
        .doc()
        .id;
    post.id = postId;

    await firestore_db
        .collection(folder_users)
        .doc(me.uid)
        .collection(folder_posts)
        .doc(postId)
        .set(post.toJson());
    return post;
  }

  static Future<Post> storeFeeds(Post post) async {
    String uid = AuthService.currentUserId();
    await firestore_db
        .collection(folder_users)
        .doc(uid)
        .collection(folder_feeds)
        .doc(post.id)
        .set(post.toJson());
    return post;
  }

  static Future<List<Post>> loadPosts() async {
    List<Post> posts = [];
    String uid = AuthService.currentUserId();

    var querySnapshot = await firestore_db
        .collection(folder_users)
        .doc(uid)
        .collection(folder_posts)
        .get();

    querySnapshot.docs.forEach((result) {
      posts.add(Post.fromJson(result.data()));
    });
    return posts;
  }
  static Future<List<Post>> loadFeeds() async {
    List<Post> posts = [];
    String uid = AuthService.currentUserId();
    var querySnapshot = await firestore_db
        .collection(folder_users)
        .doc(uid)
        .collection(folder_feeds)
        .get();
    querySnapshot.docs.forEach((result) {
      posts.add(Post.fromJson(result.data()));
    });

    return posts;
  }
}
