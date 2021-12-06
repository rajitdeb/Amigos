import 'package:amigos/model/user.dart';
import 'package:amigos/repository/repository.dart';
import 'package:flutter/material.dart';

class FollowUserBloc {

  final AmigosRepository _repository = AmigosRepository();

  followUser(BuildContext context, String destinationUserId, AmigosFollowRequestUser user) async {
    await _repository.followUser(context, destinationUserId, user);
  }

}