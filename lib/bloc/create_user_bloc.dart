import 'package:amigos/model/user.dart';
import 'package:amigos/repository/repository.dart';
import 'package:flutter/material.dart';

class CreateUserBloc {

  final AmigosRepository _repository = AmigosRepository();

  addAmigosUserToFirestore(BuildContext context, AmigosUser user) async {
    await _repository.addUserDataToFirestore(context, user);
  }

  setAmigosUserCustomUsername(BuildContext context, String userId, String username) async {
    await _repository.setAmigosUserCustomUsername(context, userId, username);
  }

}