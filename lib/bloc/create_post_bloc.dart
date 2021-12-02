import 'package:amigos/model/user.dart';
import 'package:amigos/repository/repository.dart';

class CreatePostBloc {

  final AmigosRepository _repository = AmigosRepository();

  createPost(AmigosUserPosts post) async {
    await _repository.createPost(post);
  }

  Future<String> uploadPostImgToFirebaseStorage(String imgPath) async {
    return await _repository.uploadPostImgToFirebaseStorage(imgPath);
  }

}