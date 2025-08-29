import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class RegisterView extends StatelessWidget {
  final AuthController c = Get.find();

  final nameC = TextEditingController();
  final emailC = TextEditingController();
  final passC = TextEditingController();

  RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameC,
              decoration: InputDecoration(labelText: "Name"),
            ),
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
                      onPressed: () =>
                          c.register(nameC.text, emailC.text, passC.text),
                      child: Text("Register"),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}