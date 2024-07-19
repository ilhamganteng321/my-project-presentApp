import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../routes/app_pages.dart';

class NewPasswordController extends GetxController {
  TextEditingController newpassC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  void newpass()async{
    if(newpassC.text.isNotEmpty){
      if(newpassC.text != "password") {
        try{
          String email = auth.currentUser!.email!;

          await auth.currentUser!.updatePassword(newpassC.text);
          await auth.signOut();
          await auth.signInWithEmailAndPassword(
            email: email,
            password: newpassC.text,
          );
          Get.offAllNamed(Routes.HOME);
        }on FirebaseAuthException catch(e){
          if(e.code == "weak-password"){
            Get.snackbar("error", "password minimal 6 characters");
          }
          Get.snackbar("error",e.message.toString());
        }catch (e){
          Get.snackbar("error","tidak dapat membuat passwword baru");
        }

      }else{
        Get.snackbar(
          "Error",
          "Password harus diubah",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
        );
      }
    }else{
      Get.snackbar(
        "Error",
        "Password harus diisni lebih dari 6 character",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
      );
    }
  }
}
