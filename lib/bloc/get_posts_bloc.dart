import 'package:amigos/repository/repository.dart';

class GetPostsBloc {

  final AmigosRepository _repository = AmigosRepository();

  getAllPosts() async {
    await _repository.getAllPosts();
  }

  updateLikes(postId) async {
    await _repository.updateLikes(postId);
  }

}