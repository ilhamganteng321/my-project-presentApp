import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../controllers/forgot_password_controller.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
        centerTitle: true,
      ),
      body: ListView(padding: EdgeInsets.all(20), children: [
        TextField(
          controller: controller.emailC,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            labelText: 'Email',
          ),
        ),
        SizedBox(height: 20),
        Obx(
          () => ElevatedButton(
            onPressed: () {
              if(controller.isLoading.isFalse){
                controller.sendEmail();
              }
              controller.isLoading.value = true;
            },
            child: Text(controller.isLoading.isFalse?
              "SEND RESET PASSWORD" : "Loading....",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(20),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
