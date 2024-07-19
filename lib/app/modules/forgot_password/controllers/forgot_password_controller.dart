import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordController extends GetxController {
  TextEditingController emailC = TextEditingController();
  RxBool isLoading = false.obs;
  FirebaseAuth auth = FirebaseAuth.instance;
  void sendEmail()async{
      isLoading.value = true;
      if(emailC.text.isNotEmpty) {
        try {
          await auth.sendPasswordResetEmail(email: emailC.text);
          Get.snackbar(
              "Email Sent", "Please check your email to reset your password");
          Get.back();
        } catch (e) {
          Get.snackbar("Error", e.toString());
        }finally{
          isLoading.value = false;
        }
      }else{
        Get.snackbar("Error", "Please enter your email");
        isLoading.value = false;
      }
  }
}
