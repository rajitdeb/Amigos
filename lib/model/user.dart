class AmigosUser {
  String? profileImg;
  String userId;
  String username;
  String fullName;
  String email;
  String? bio;
  int postsCount;
  List<dynamic> posts;
  int followersCount;
  int followingCount;
  List<dynamic> userDetails;

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
  List<dynamic> followers;
  List<dynamic> following;

  AmigosUserDetail.fromJson(Map<String, dynamic> json)
      : followers = (json["followers"] as List)
            .map((e) => AmigosUser.fromJson(json))
            .toList(),
        following = (json["following"] as List)
            .map((e) => AmigosUser.fromJson(json))
            .toList();
}

class AmigosUserPosts {
  String? postCaption;
  String? postImgLink;
  String authorFullName;
  String authorUserId;
  String? authorProfileImg;
  String authorUsername;
  int createdAt;
  List<dynamic> likedBy;


  AmigosUserPosts(this.postCaption, this.postImgLink, this.authorFullName,
      this.authorUserId, this.authorProfileImg, this.authorUsername,
      this.createdAt, this.likedBy);

  AmigosUserPosts.fromJson(Map<String, dynamic> json)
      : postCaption = json["postCaption"],
        postImgLink = json["postImgLink"],
        authorFullName = json["authorFullName"],
        authorUserId = json["authorUserId"],
        authorProfileImg = json["authorProfileImg"],
        authorUsername = json["authorUsername"],
        createdAt = json["createdAt"],
        likedBy = json["likedBy"];
}
