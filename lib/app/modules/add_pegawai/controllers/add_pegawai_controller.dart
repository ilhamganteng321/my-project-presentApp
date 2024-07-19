import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class AddPegawaiController extends GetxController {
  TextEditingController namaC = TextEditingController();
  TextEditingController nipC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController jobC = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController passAdminC = TextEditingController();

  var isLoading = false.obs;
  var isLoadingPegawai = false.obs;
  Future<void> prosesAddPegawai() async {

    if (passAdminC.text.isNotEmpty) {
      isLoadingPegawai.value = true;
      try {
        isLoading.value = true;
        String emailAdmin = auth.currentUser!.email!;
        UserCredential userCredentialAdmin = await auth.signInWithEmailAndPassword(
            email: emailAdmin, password: passAdminC.text);

        UserCredential credential = await auth.createUserWithEmailAndPassword(
          email: emailC.text,
          password: "password",
        );

        if (credential.user != null) {
          String uid = credential.user!.uid;
          await firestore.collection('pegawai').doc(uid).set({
            'nip': nipC.text,
            'job' : jobC.text,
            'nama': namaC.text,
            'email': emailC.text,
            'role': 'pegawai',
            'uid': uid,
            'created_at': DateTime.now().toIso8601String(),
          });

          await credential.user!.sendEmailVerification();
          await auth.signOut();
          await auth.signInWithEmailAndPassword(email: emailAdmin, password: passAdminC.text);

          Get.back();
          Get.back();
          Get.snackbar(
            "Berhasil",
            "Menambahkan pegawai",
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
          );
        }
        isLoadingPegawai.value = false;
      } on FirebaseAuthException catch (e) {
        isLoadingPegawai.value = false;
        String errorMessage;
        if (e.code == 'weak-password') {
          errorMessage = "Password terlalu lemah";
        } else if (e.code == 'email-already-in-use') {
          errorMessage = "Email sudah terdaftar oleh akun lain";
        } else if (e.code == 'wrong-password') {
          errorMessage = "Admin tidak dapat login, Password salah";
        } else {
          errorMessage = e.message ?? "Terjadi kesalahan";
        }
        Get.snackbar("Error", errorMessage);
      } catch (e) {
        Get.snackbar("Error", "Tidak dapat menambahkan pegawai");
      } finally {
        isLoading.value = false;
      }
    } else {
      Get.snackbar("Error", "Password harus diisi");
    }
  }

  Future<void> addPegawai() async {
    if (jobC.text.isEmpty||namaC.text.isEmpty || nipC.text.isEmpty || emailC.text.isEmpty) {
      Get.snackbar("Error", "Semua form field wajib diisi");
      return;
    } else {
      isLoading.value = true;
      Get.defaultDialog(
        contentPadding: EdgeInsets.all(20),
        title: "Validasi",
        content: Column(
          children: [
            Text("Masukan password untuk validasi admin!"),
            SizedBox(height: 10),
            TextField(
              controller: passAdminC,
              obscureText: true,
              autocorrect: false,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                label: Text("Password"),
              ),
            ),
          ],
        ),
        actions: [
          SizedBox(height: 10,),
          OutlinedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              isLoading.value = false;
              Get.back();
            },
            child: Text("Cancel"),
          ),
          SizedBox(width: 10,),
          Obx(
              ()=>ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              onPressed: () async {
                if(isLoadingPegawai.isFalse){
                  await prosesAddPegawai();
                }
                isLoading.value = false;
              },
              child: isLoadingPegawai.isTrue
                  ? Text("Loading...")
                  : Text("Submit")),
            ),
        ],
      );
    }
  }
}
