import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UpdatePasswordController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController CurrentPassC = TextEditingController();
  TextEditingController newPassC = TextEditingController();
  TextEditingController confirmPassC = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  Future <void> updatePassword() async {
    if(confirmPassC.text.isNotEmpty && CurrentPassC.text.isNotEmpty && newPassC.text.isNotEmpty ){
      if(newPassC.text == confirmPassC.text) {
        isLoading.value = true;
        try {
          String emailUser = auth.currentUser!.email!;
          await auth.signInWithEmailAndPassword(email: emailUser, password: CurrentPassC.text);

          await auth.currentUser!.updatePassword(newPassC.text);

          await auth.signOut();

          await auth.signInWithEmailAndPassword(email: emailUser, password: newPassC.text);

          Get.back();
          Get.snackbar("Berhasil", " berhasil ganti password",colorText: Colors.white,snackPosition: SnackPosition.TOP,backgroundColor: Colors.green);
        } on FirebaseException catch (e) {
          if(e.code == 'wrong-password') {
            Get.snackbar("Error", "Password sekarang salah",colorText: Colors.white,snackPosition: SnackPosition.TOP,backgroundColor: Colors.red);
          }else{
            Get.snackbar("Error", "${e.message.toString()}",colorText: Colors.white,snackPosition: SnackPosition.TOP,backgroundColor: Colors.red);
          }
        } catch (e) {
          Get.snackbar("Error", "Tidak dapat update password",colorText: Colors.white,snackPosition: SnackPosition.TOP,backgroundColor: Colors.red);
        }finally{
          isLoading.value = false;
        }
      }else{
        Get.snackbar("Error", "New password dan confirm password harus sama",colorText: Colors.white,snackPosition: SnackPosition.TOP,backgroundColor: Colors.red);
      }
    }else{
      Get.snackbar("Error", "Semua input harus diisi",colorText: Colors.white,snackPosition: SnackPosition.TOP,backgroundColor: Colors.red);
    }
  }
}
