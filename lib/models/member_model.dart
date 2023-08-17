class Member{
  String? uid;
  String? fullname;
  String? email;
  String? password;
  String? img_url;

  String? device_id;
  String? device_type;
  String? device_token;

  bool followed=true;
  int? followers_count;
  int? following_count;

  Member(this.fullname,this.email);
  Member.fromJson(Map<String,dynamic> json):
        uid= json['uid'],
        fullname = json['fullname'],
        email = json['email'],
        password= json['password'],
        img_url= json['img_url'],
        device_id= json['device_id'],
        device_type= json['device_type'],
        device_token= json['device_token'],
        followed=json["followed"],
        followers_count=json["followers_count"],
        following_count=json["following_count"];
  Map <String,dynamic> toJson()=>{
    "uid": uid,
    "fullname": fullname,
    "email": email,
    "password": password,
    "img_url": img_url,
    "device_id": device_id,
    "device_type": device_type,
    "device_token": device_token,
    "followed":followed,
    "followers_count":followers_count,
    'following_count':following_count,
  };
}