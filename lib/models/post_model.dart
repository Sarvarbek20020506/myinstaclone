class Post {
  String? imgpost;
  String? caption;

  Post(this.imgpost,this.caption);

  Post.fromJson(Map<String,dynamic>json):
      imgpost = json["imgpost"],
      caption = json['caption'];


  Map <String,dynamic> toJson()=>{
    "imgpost": imgpost,
    "caption": caption,
  };

}