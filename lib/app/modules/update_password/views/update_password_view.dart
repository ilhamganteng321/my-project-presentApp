import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/update_password_controller.dart';

class UpdatePasswordView extends GetView<UpdatePasswordController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UpdatePasswordView'),
        centerTitle: true,
      ),
      body: ListView(padding: EdgeInsets.all(20), children: [
        TextField(
          controller: controller.CurrentPassC,
          autocorrect: false,
          obscureText: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            labelText: 'Current password',
          ),
        ),
        SizedBox(
          height: 20,
        ),
        TextField(
          controller: controller.newPassC,
          autocorrect: false,
          obscureText: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            labelText: 'New password ',
          ),
        ),
        SizedBox(
          height: 20,
        ),
        TextField(
          controller: controller.confirmPassC,
          autocorrect: false,
          obscureText: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            labelText: 'Confirm password ',
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Obx(
          () => ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(20),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () async {
                if (controller.isLoading.isFalse) {
                  await controller.updatePassword();
                }
              },
              child: Text(controller.isLoading.isFalse ? 'Update password' : 'Loading...')),
        )
      ]),
    );
  }
}
