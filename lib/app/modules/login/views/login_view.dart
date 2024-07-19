import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../../../routes/app_pages.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
      ),
      body: ListView(
        padding:  EdgeInsets.all(20),
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue,
            maxRadius: 70,
            child:
            Icon(Icons.person,size: 100,color: Colors.white,),
          ),
          SizedBox(height: 40,),
          TextField(
            controller: controller.emailC,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              labelText: 'Email',
            ),
          ),
          SizedBox(height: 20,),
          TextField(
            controller: controller.passC,
            obscureText: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              labelText: 'Password',
            ),
          ),
          SizedBox(height: 20),
          Obx(
                () => ElevatedButton(onPressed: () async {
              if(controller.isLoading.isFalse){
                await controller.login();
              }
            }, child: Text(controller.isLoading.isFalse ? "LOGIN" :"LOADING....",style: TextStyle(color: Colors.white
                ,fontWeight: FontWeight.bold,fontSize: 20),),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(20),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),),
          ),
          SizedBox(height: 10,),
          TextButton(onPressed: (){
            Get.toNamed(Routes.FORGOT_PASSWORD);
          }, child: Text("lupa password?"),style: TextButton.styleFrom(
            padding: EdgeInsets.all(20),
            backgroundColor: Colors.white,
            foregroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),),
        ],
      )
    );
  }
}
