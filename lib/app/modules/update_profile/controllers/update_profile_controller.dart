import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as s;
class UpdateProfileController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController namaC = TextEditingController();
  TextEditingController nipC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final ImagePicker picker = ImagePicker();
  XFile? image;
  s.FirebaseStorage storage = s.FirebaseStorage.instance;
  void pickImage()async{
    image = await picker.pickImage(source: ImageSource.gallery);
    if(image != null){

    }else{

    }
    update();
  }

  Future<void> deleteProfile (String uid) async{
    try {
      await firestore.collection('pegawai').doc(uid).update({
        "profile": FieldValue.delete()
      });
      image = null;
      update();
    }catch (e) {
      Get.snackbar("error", "Tidak dapat menghapus profil",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<void> updateProfile(String uid) async {
    if (namaC.text.isNotEmpty &&
        nipC.text.isNotEmpty &&
        emailC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        Map <String,dynamic> data = {
          "nama": namaC.text
        };
        if(image != null) {
          String extensi = image!.name.split('.').last;
          File file = File(image!.path);
          await storage.ref("${uid}/${extensi}").putFile(file);
          String urlImage = await storage.ref("${uid}/${extensi}").getDownloadURL();
          data.addAll({"profile": urlImage});
        }
        await firestore
            .collection('pegawai')
            .doc(uid)
            .update(data);
        Get.back();
        Get.snackbar("Berhasil", "Update profile berhasil dilakukan}",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      } catch (e) {
        Get.snackbar("error", "Tidak dapat update profile}",
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
        );
      } finally {
        isLoading.value = false;
      }
    } else {
      Get.snackbar("error", "mohon isi nama dengan benar");
    }
  }


}
