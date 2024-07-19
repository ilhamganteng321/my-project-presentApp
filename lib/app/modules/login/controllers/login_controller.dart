import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_rx/get_rx.dart';

import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> login() async {
    if (emailC.text.isNotEmpty && passC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        final credential = await auth.signInWithEmailAndPassword(
          email: emailC.text,
          password: passC.text,
        );

        if (credential.user != null) {
          if (credential.user!.emailVerified) {
            isLoading.value = false;
            if (passC.text == "password") {
              Get.toNamed(Routes.NEW_PASSWORD);
              return;
            }
            Get.snackbar(
              "Sukses",
              "Login berhasil",
              backgroundColor: Colors.green,
              colorText: Colors.white,
              snackPosition: SnackPosition.TOP,
              snackStyle: SnackStyle.FLOATING,
            );
            Get.offAllNamed(Routes.HOME);
          } else {
            isLoading.value = true;
            Get.defaultDialog(
              title: "Error",
              backgroundColor: Colors.red,
              middleText: "Kamu belum verifikasi email kamu",
              actions: [
                OutlinedButton(
                  onPressed: (){
                    isLoading.value = false;
                    Get.back();
                  },
                  child: Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await credential.user!.sendEmailVerification();
                      Get.back();
                      Get.snackbar(
                        "Sukses",
                        "Berhasil kirim verifikasi email ke akunmu, cek email",
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.TOP,
                        snackStyle: SnackStyle.FLOATING,
                      );
                      isLoading.value = false;
                    } catch (e) {
                      isLoading.value = false;
                      Get.snackbar(
                        "Error",
                        e.toString(),
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.TOP,
                        snackStyle: SnackStyle.GROUNDED,
                      );
                    }
                  },
                  child: Text("Kirim Ulang"),
                ),
              ],
            );
          }
        }
        isLoading.value = false;
      } on FirebaseAuthException catch (e) {
        isLoading.value = false;
        if (e.code == 'user-not-found') {
          Get.snackbar(
            "Error",
            "User tidak terdaftar",
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
            snackStyle: SnackStyle.GROUNDED,
          );
        } else if (e.code == 'wrong-password') {
          Get.snackbar(
            "Error",
            "Password salah",
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
            snackStyle: SnackStyle.GROUNDED,
          );
        }
      } catch (e) {
        isLoading.value = false;
        Get.snackbar(
          "Error",
          e.toString(),
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          snackStyle: SnackStyle.GROUNDED,
        );
      }
    } else {
      Get.snackbar(
        "Error",
        "Email dan password wajib diisi",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        snackStyle: SnackStyle.GROUNDED,
      );
    }
  }
}
