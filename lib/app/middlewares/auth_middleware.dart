import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../routes/app_pages.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final box = GetStorage();
    final token = box.read('token');

    if (token == null && route != Routes.LOGIN && route != Routes.REGISTER) {
      return const RouteSettings(name: Routes.LOGIN);
    } else if (token != null && (route == Routes.LOGIN || route == Routes.REGISTER)) {
      return const RouteSettings(name: Routes.HOME);
    }
    return null;
  }
}
