import 'package:get/get.dart';
import 'package:getx1/app/data/models/post.dart';

class PostDetailController extends GetxController {
  late Post post;

  @override
  void onInit() {
    super.onInit();
    post = Get.arguments as Post;
  }
}