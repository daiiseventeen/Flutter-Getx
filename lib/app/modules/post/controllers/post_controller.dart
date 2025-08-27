import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx1/app/data/models/post.dart';
import 'package:getx1/app/services/post__service.dart';

class PostController extends GetxController {
  final PostService postService = Get.put<PostService>(PostService());
  
  RxList<Post> posts = <Post>[].obs;
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPost();
  }

  /// Fetch posts dari service
  Future<void> fetchPost() async {
    try {
      isLoading(true);
      errorMessage('');
      
      final response = await postService.fetchPosts();
      
      if (response.statusCode == 200) {
        var data = response.body!
            .map((postJson) => Post.fromJson(postJson))
            .toList();
        posts.assignAll(data);
        
        // Show success message
        if (data.isNotEmpty) {
          Get.snackbar(
            'Success',
            'Loaded ${data.length} posts',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Get.theme.primaryColor.withOpacity(0.1),
            colorText: Get.theme.primaryColor,
            duration: const Duration(seconds: 2),
            icon: const Icon(Icons.check_circle, color: Colors.green),
          );
        }
      } else {
        errorMessage('Failed to load posts: ${response.statusText}');
        
        // Show error snackbar
        Get.snackbar(
          'Error',
          'Failed to load posts: ${response.statusText}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          icon: const Icon(Icons.error, color: Colors.white),
        );
      }
    } catch (e) {
      errorMessage('Network error: $e');
      
      // Load dummy data when offline or error occurs
      _loadDummyData();
      
      Get.snackbar(
        'Connection Error',
        'Using offline data. Please check your internet connection.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
        icon: const Icon(Icons.wifi_off, color: Colors.white),
      );
    } finally {
      isLoading(false);
    }
  }

  /// Load dummy data ketika tidak ada koneksi
  void _loadDummyData() {
    final dummyPosts = [
      Post(
        id: 1,
        userId: 1,
        title: 'Welcome to Our Amazing App!',
        body: 'This is a sample post to demonstrate the beautiful UI design of our Flutter application. We hope you enjoy the smooth animations and elegant design patterns implemented throughout the app.',
      ),
      Post(
        id: 2,
        userId: 1,
        title: 'Learning Flutter with GetX',
        body: 'GetX is an incredibly powerful state management solution for Flutter. It provides reactive programming, dependency injection, and route management all in one package. The learning curve is gentle and the results are amazing.',
      ),
      Post(
        id: 3,
        userId: 2,
        title: 'Beautiful Animations in Mobile Apps',
        body: 'Animations breathe life into mobile applications. They guide users through the interface, provide feedback for actions, and create delightful experiences that keep users engaged and coming back for more.',
      ),
      Post(
        id: 4,
        userId: 2,
        title: 'The Future of Mobile Development',
        body: 'Mobile development continues to evolve rapidly. With frameworks like Flutter, developers can create beautiful, natively compiled applications for multiple platforms from a single codebase.',
      ),
      Post(
        id: 5,
        userId: 3,
        title: 'Design Principles for Modern Apps',
        body: 'Modern app design focuses on simplicity, accessibility, and user experience. Material Design and Human Interface Guidelines provide excellent foundations for creating intuitive and beautiful applications.',
      ),
    ];

    posts.assignAll(dummyPosts);
  }

  /// Refresh posts
  Future<void> refreshPosts() async {
    await fetchPost();
  }

  /// Search posts by title or body
  void searchPosts(String query) {
    if (query.isEmpty) {
      fetchPost();
      return;
    }

    final filteredPosts = posts.where((post) {
      final titleLower = post.title?.toLowerCase() ?? '';
      final bodyLower = post.body?.toLowerCase() ?? '';
      final queryLower = query.toLowerCase();
      
      return titleLower.contains(queryLower) || bodyLower.contains(queryLower);
    }).toList();

    posts.assignAll(filteredPosts);

    Get.snackbar(
      'Search Results',
      'Found ${filteredPosts.length} posts matching "$query"',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.blue.withOpacity(0.1),
      colorText: Colors.blue,
      duration: const Duration(seconds: 2),
    );
  }

  /// Add new post (untuk simulasi)
  void addPost(String title, String body) {
    final newPost = Post(
      id: DateTime.now().millisecondsSinceEpoch,
      userId: 1,
      title: title,
      body: body,
    );

    posts.insert(0, newPost);

    Get.snackbar(
      'Post Added',
      'Your new post has been added successfully!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      icon: const Icon(Icons.add_circle, color: Colors.white),
    );
  }

  /// Delete post
  void deletePost(int postId) {
    posts.removeWhere((post) => post.id == postId);

    Get.snackbar(
      'Post Deleted',
      'Post has been removed',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      icon: const Icon(Icons.delete, color: Colors.white),
    );
  }

  /// Like post (simulasi)
  void likePost(int postId) {
    // Dalam implementasi nyata, ini akan mengirim request ke server
    Get.snackbar(
      'Liked!',
      'You liked this post',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.pink,
      colorText: Colors.white,
      duration: const Duration(seconds: 1),
      icon: const Icon(Icons.favorite, color: Colors.white),
    );
  }

  /// Share post
  void sharePost(Post post) {
    // Dalam implementasi nyata, ini akan membuka share dialog
    Get.snackbar(
      'Shared!',
      'Post "${post.title}" has been shared',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      icon: const Icon(Icons.share, color: Colors.white),
    );
  }

  /// Get post by ID
  Post? getPostById(int postId) {
    try {
      return posts.firstWhere((post) => post.id == postId);
    } catch (e) {
      return null;
    }
  }

  /// Get posts by user ID
  List<Post> getPostsByUserId(int userId) {
    return posts.where((post) => post.userId == userId).toList();
  }

  @override
  void onClose() {
    // Clean up resources if needed
    super.onClose();
  }
}