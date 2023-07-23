class Member{
  String? uid;
  String? fullname;
  String? email;

  Member(this.fullname,this.email);
  Member.fromJson(Map<String,dynamic> json):
      fullname = json['fullname'],
  email = json['email'];
  Map <String,dynamic> toJson()=>{
    "fullname":fullname,
    "email": email,
  };
}