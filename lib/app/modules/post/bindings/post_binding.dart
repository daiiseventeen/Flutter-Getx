import 'package:get/get.dart';
import 'package:getx1/app/services/post__service.dart';
import '../controllers/post_controller.dart';

class PostBinding extends Bindings {
  @override
  void dependencies() {
    // Inject service
    Get.lazyPut<PostService>(() => PostService());
    
    // Inject controller
    Get.lazyPut<PostController>(() => PostController());
  }
}

// Alternative binding untuk permanent injection
class PostPermanentBinding extends Bindings {
  @override
  void dependencies() {
    // Permanent injection - won't be disposed when not in use
    Get.put<PostService>(PostService(), permanent: true);
    Get.put<PostController>(PostController(), permanent: true);
  }
}

// Smart management binding - automatically manages lifecycle
class PostSmartBinding extends Bindings {
  @override
  void dependencies() {
    // Smart management - GetX will handle disposal automatically
    Get.lazyPut<PostService>(() => PostService(), fenix: true);
    Get.lazyPut<PostController>(() => PostController(), fenix: true);
  }
}