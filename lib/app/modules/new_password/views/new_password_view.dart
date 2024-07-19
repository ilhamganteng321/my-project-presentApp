import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/new_password_controller.dart';

class NewPasswordView extends GetView<NewPasswordController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Password'),
        centerTitle: true,
      ),
      body: ListView(padding: EdgeInsets.all(20),
      children: [
        TextField(
          autocorrect: false,
          obscureText: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            labelText: 'New Password',
          ),
          controller: controller.newpassC,
        ),
        SizedBox(height: 20,),
        ElevatedButton(onPressed: (){
          controller.newpass();
        }, child: Text("new password"))
      ],)
    );
  }
}
