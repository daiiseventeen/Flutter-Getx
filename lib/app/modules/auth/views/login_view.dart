import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../../../routes/app_pages.dart';

class LoginView extends StatelessWidget {
  final AuthController c = Get.put(AuthController());

  final emailC = TextEditingController();
  final passC = TextEditingController();

  LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailC,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passC,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            Obx(
              () => c.isLoading.value
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () => c.login(emailC.text, passC.text),
                      child: Text("Login"),
                    ),
            ),
            TextButton(
              onPressed: () => Get.toNamed(Routes.REGISTER),
              child: Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}