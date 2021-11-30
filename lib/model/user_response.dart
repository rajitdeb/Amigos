import 'package:amigos/model/user.dart';

class AmigosUserResponse {

  AmigosUser? user;
  String? error;

  AmigosUserResponse(this.user, this.error);

  AmigosUserResponse.fromJson(Map<String, dynamic> json)
  : user = AmigosUser.fromJson(json),
    error = null;

  AmigosUserResponse.withError(String errorValue)
    : user = null,
      error = errorValue;
}