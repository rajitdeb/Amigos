import 'package:amigos/repository/repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GetUserBloc {

  final AmigosRepository _repository = AmigosRepository();

  Future<DocumentSnapshot> getUserById(String userId) async {
    return await _repository.getUserById(userId);
  }

}