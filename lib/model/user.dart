class AmigosUser {
  String? profileImg;
  String userId;
  String username;
  String fullName;
  String email;
  String? bio;
  int postsCount;
  List<AmigosUserPosts>? posts;
  int followersCount;
  int followingCount;
  List<AmigosUserDetail>? userDetails;

  AmigosUser(
      this.profileImg,
      this.userId,
      this.username,
      this.fullName,
      this.email,
      this.bio,
      this.postsCount,
      this.posts,
      this.followersCount,
      this.followingCount,
      this.userDetails);

  AmigosUser.fromJson(Map<String, dynamic> json)
      : profileImg = json["profileImg"],
        userId = json["userId"],
        username = json["username"],
        fullName = json["fullName"],
        email = json["email"],
        bio = json["bio"],
        postsCount = json["postsCount"],
        posts = (json["posts"] as List)
            .map((e) => AmigosUserPosts.fromJson(json))
            .toList(),
        followersCount = json["followersCount"],
        followingCount = json["followingCount"],
        userDetails = json["userDetails"];
}

class AmigosUserDetail {
  List<AmigosUser>? followers;
  List<AmigosUser>? following;

  AmigosUserDetail.fromJson(Map<String, dynamic> json)
      : followers = (json["followers"] as List)
            .map((e) => AmigosUser.fromJson(json))
            .toList(),
        following = (json["following"] as List)
            .map((e) => AmigosUser.fromJson(json))
            .toList();
}

class AmigosUserPosts {
  int postId;
  String? postCaption;
  String? postImgLink;

  AmigosUserPosts(this.postId, this.postCaption, this.postImgLink);

  AmigosUserPosts.fromJson(Map<String, dynamic> json)
      : postId = json["postId"],
        postCaption = json["postCaption"],
        postImgLink = json["postImgLink"];
}
