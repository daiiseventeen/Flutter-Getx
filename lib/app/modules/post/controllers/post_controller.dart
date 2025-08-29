// lib/app/modules/post/controllers/post_controller.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx1/app/data/models/post.dart';
import 'package:getx1/app/services/post_service.dart';
import 'package:image_picker/image_picker.dart';

class PostController extends GetxController {
  final PostService _postService = PostService();
  
  // Observable variables
  final RxList<PostModel> posts = <PostModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingDetail = false.obs;
  final Rx<PostModel?> selectedPost = Rx<PostModel?>(null);
  final Rx<File?> imageFile = Rx<File?>(null);

  // Form controllers
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final slugController = TextEditingController();
  final RxInt status = 1.obs;

  @override
  void onInit() {
    super.onInit();
    getAllPosts();
  }

  @override
  void onClose() {
    titleController.dispose();
    contentController.dispose();
    slugController.dispose();
    super.onClose();
  }

  // Get all posts
  Future<void> getAllPosts() async {
    try {
      isLoading.value = true;
      
      final response = await _postService.getAllPosts();
      if (response != null && response.data != null) {
        posts.value = response.data!;
      } else {
        posts.value = [];
      }
    } catch (e) {
      posts.value = [];
      Get.snackbar('Error', 'Failed to load posts');
    } finally {
      isLoading.value = false;
    }
  }

  // Get single post
  Future<void> getPost(int id) async {
    try {
      isLoadingDetail.value = true;
      imageFile.value = null;
      
      final post = await _postService.getPost(id);
      if (post != null) {
        selectedPost.value = post;
        // Fill form for editing
        titleController.text = post.title ?? '';
        contentController.text = post.content ?? '';
        slugController.text = post.slug ?? '';
        status.value = post.status ?? 1;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load post details');
    } finally {
      isLoadingDetail.value = false;
    }
  }

  // Create post
  Future<void> createPost() async {
    if (!validateForm()) return;

    try {
      isLoading.value = true;
      
      final data = {
        'title': titleController.text.trim(),
        'content': contentController.text.trim(),
        'slug': slugController.text.trim(),
        'status': status.value.toString(),
      };
      
      final success = await _postService.createPost(data, imagePath: imageFile.value?.path);
      if (success) {
        clearForm();
        await getAllPosts();
        Get.back();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to create post');
    } finally {
      isLoading.value = false;
    }
  }

  // Update post
  Future<void> updatePost(int id) async {
    if (!validateForm()) return;

    try {
      isLoading.value = true;
      
      final data = {
        'title': titleController.text.trim(),
        'content': contentController.text.trim(),
        'slug': slugController.text.trim(),
        'status': status.value.toString(),
      };
      
      final success = await _postService.updatePost(id, data, imagePath: imageFile.value?.path);
      if (success) {
        clearForm();
        await getAllPosts();
        Get.back();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update post');
    } finally {
      isLoading.value = false;
    }
  }

  // Delete post
  Future<void> deletePost(int id) async {
    try {
      final confirm = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Delete Post'),
          content: const Text('Are you sure you want to delete this post? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Get.back(result: true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        ),
      );

      if (confirm == true) {
        isLoading.value = true;
        
        final success = await _postService.deletePost(id);
        if (success) {
          await getAllPosts();
        }
        
        isLoading.value = false;
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Failed to delete post');
    }
  }

  // Validate form
  bool validateForm() {
    if (titleController.text.trim().isEmpty) {
      Get.snackbar('Validation Error', 'Title is required');
      return false;
    }
    if (contentController.text.trim().isEmpty) {
      Get.snackbar('Validation Error', 'Content is required');
      return false;
    }
    if (slugController.text.trim().isEmpty) {
      Get.snackbar('Validation Error', 'Slug is required');
      return false;
    }
    return true;
  }

  // Clear form
  void clearForm() {
    titleController.clear();
    contentController.clear();
    slugController.clear();
    status.value = 1;
    selectedPost.value = null;
    imageFile.value = null;
  }

  // Generate slug from title
  void generateSlug() {
    final title = titleController.text.trim();
    if (title.isNotEmpty) {
      final slug = title
          .toLowerCase()
          .replaceAll(RegExp(r'[^a-z0-9\s]'), '')
          .replaceAll(RegExp(r'\s+'), '-');
      slugController.text = slug;
    }
  }

  // Pick image
  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path);
    }
  }
}