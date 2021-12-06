class AmigosUser {
  String? profileImg;
  String userId;
  String username;
  String fullName;
  String email;
  String? bio;
  List<dynamic> followers;
  List<dynamic> following;

  AmigosUser(
      this.profileImg,
      this.userId,
      this.username,
      this.fullName,
      this.email,
      this.bio,
      this.followers,
      this.following);

  AmigosUser.fromJson(Map<String, dynamic> json)
      : profileImg = json["profileImg"],
        userId = json["userId"],
        username = json["username"],
        fullName = json["fullName"],
        email = json["email"],
        bio = json["bio"],
        followers = json["followers"],
        following = json["following"];
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

class AmigosUserFollowRequests {

  List<dynamic> followRequestsList;

  AmigosUserFollowRequests(this.followRequestsList);

  AmigosUserFollowRequests.fromJson(Map<String, dynamic> json)
    : followRequestsList = json['followRequestList'];
}

class AmigosFollowRequestUser {

  String? userId;
  String? fullName;
  String? username;
  String? profileImg;

  AmigosFollowRequestUser(
      this.userId, this.fullName, this.username, this.profileImg);

  AmigosFollowRequestUser.fromJson(Map<String, dynamic> json)
    : userId = json['userId'],
      fullName = json['fullName'],
      username = json['username'],
      profileImg = json['profileImg'];
}

class FollowerDetails {

  String? userId;
  String? fullName;
  String? username;
  String? profileImg;

  FollowerDetails(
      this.userId, this.fullName, this.username, this.profileImg);

  Map<String, dynamic> toJson() => {

    'userId': userId,
    'fullName': fullName,
    'username': username,
    'profileImg': profileImg,

  };

}

class FollowingDetails {

  String? userId;
  String? fullName;
  String? username;
  String? profileImg;

  FollowingDetails(
      this.userId, this.fullName, this.username, this.profileImg);

  FollowingDetails.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        fullName = json['fullName'],
        username = json['username'],
        profileImg = json['profileImg'];

  Map<String, dynamic> toJson() => {

    'userId': userId,
    'fullName': fullName,
    'username': username,
    'profileImg': profileImg,

  };

}
