// lib/app/data/services/post_service.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getx1/app/data/models/post.dart';
import 'package:getx1/app/routes/app_pages.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PostService extends GetConnect {
  final String _baseUrl = 'http://127.0.0.1:8000/api';
  final box = GetStorage();

  // Get default headers
  Map<String, String> get _headers {
    final token = box.read('token');
    final headers = {
      'Accept': 'application/json',
    };

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }


  // Get all posts
  Future<PostResponse?> getAllPosts() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/posts'),
        headers: _headers,
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 401) {
        box.remove('token');
        Get.offAllNamed(Routes.LOGIN);
        return null;
      }

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          return null;
        }

        final trimmedBody = response.body.trim();
        if (!trimmedBody.startsWith('{') && !trimmedBody.startsWith('[')) {
          Get.snackbar('Error', 'Invalid response from server');
          return null;
        }

        try {
          final jsonData = json.decode(response.body);
          return PostResponse.fromJson(jsonData);
        } catch (jsonError) {
          Get.snackbar('Error', 'Failed to load posts');
          return null;
        }
      } else {
        Get.snackbar('Error', 'Failed to load posts');
        return null;
      }
    } on SocketException {
      Get.snackbar('Connection Error', 'Please check your internet connection');
      return null;
    } on HttpException {
      Get.snackbar('Error', 'Network request failed');
      return null;
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong');
      return null;
    }
  }

  // Get single post
  Future<PostModel?> getPost(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/posts/$id'),
        headers: _headers,
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 401) {
        box.remove('token');
        Get.offAllNamed(Routes.LOGIN);
        return null;
      }

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          return null;
        }

        final trimmedBody = response.body.trim();
        if (!trimmedBody.startsWith('{') && !trimmedBody.startsWith('[')) {
          return null;
        }

        try {
          final data = json.decode(response.body);
          if (data is Map<String, dynamic> && data.containsKey('data')) {
            return PostModel.fromJson(data['data'] as Map<String, dynamic>);
          } else if (data is Map<String, dynamic>) {
            return PostModel.fromJson(data);
          }
          return null;
        } catch (jsonError) {
          Get.snackbar('Error', 'Failed to load post');
          return null;
        }
      } else {
        Get.snackbar('Error', 'Post not found');
        return null;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load post');
      return null;
    }
  }

  // Create post
  Future<bool> createPost(Map<String, String> data, {String? imagePath}) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$_baseUrl/posts'));
      request.headers.addAll(_headers);
      request.fields.addAll(data);

      if (imagePath != null) {
        request.files.add(await http.MultipartFile.fromPath('foto', imagePath));
      }

      var response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 401) {
        box.remove('token');
        Get.offAllNamed(Routes.LOGIN);
        return false;
      }

      if (response.statusCode == 201 || response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'Post created successfully',
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade800,
        );
        return true;
      } else {
        try {
          final errorData = json.decode(responseBody);
          final errorMessage = errorData['message'] ?? 'Failed to create post';
          Get.snackbar('Error', errorMessage);
        } catch (e) {
          Get.snackbar('Error', 'Failed to create post: ${response.statusCode}');
        }
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to create post');
      return false;
    }
  }

  // Update post
  Future<bool> updatePost(int id, Map<String, String> data, {String? imagePath}) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$_baseUrl/posts/$id'));
      request.headers.addAll(_headers);
      request.fields['_method'] = 'PUT'; // For Laravel to handle PUT with multipart
      request.fields.addAll(data);

      if (imagePath != null) {
        request.files.add(await http.MultipartFile.fromPath('foto', imagePath));
      }

      var response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 401) {
        box.remove('token');
        Get.offAllNamed(Routes.LOGIN);
        return false;
      }

      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'Post updated successfully',
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade800,
        );
        return true;
      } else {
        try {
          final errorData = json.decode(responseBody);
          final errorMessage = errorData['message'] ?? 'Failed to update post';
          Get.snackbar('Error', errorMessage);
        } catch (e) {
          Get.snackbar('Error', 'Failed to update post: ${response.statusCode}');
        }
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update post');
      return false;
    }
  }

  // Delete post
  Future<bool> deletePost(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/posts/$id'),
        headers: _headers,
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 401) {
        box.remove('token');
        Get.offAllNamed(Routes.LOGIN);
        return false;
      }

      if (response.statusCode == 200 || response.statusCode == 204) {
        Get.snackbar(
          'Success', 
          'Post deleted successfully',
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade800,
        );
        return true;
      } else {
        try {
          final errorData = json.decode(response.body);
          final errorMessage = errorData['message'] ?? 'Failed to delete post';
          Get.snackbar('Error', errorMessage);
        } catch (e) {
          Get.snackbar('Error', 'Failed to delete post');
        }
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete post');
      return false;
    }
  }
}