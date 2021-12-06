import 'package:amigos/repository/repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class SearchUsersBloc {

  final AmigosRepository _repository = AmigosRepository();

  searchUsers(String searchQuery) async {
    await _repository.searchUsers(searchQuery);
  }

}