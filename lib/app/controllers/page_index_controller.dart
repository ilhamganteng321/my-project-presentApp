import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:present_app/app/routes/app_pages.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';

class PageIndexController extends GetxController {
  RxInt indexPage = 0.obs;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void changePage(int i) async {
    switch (i) {
      case 1:
        print("absensi");
        Map<String, dynamic> dataResponse = await determinePosition();
        if (dataResponse['error'] != true) {
          Position position = await dataResponse['position'];
          List<Placemark> placemarks = await placemarkFromCoordinates(
              position.latitude, position.longitude);
          String address =
              "${placemarks[0].name} ,${placemarks[0].subLocality}, ${placemarks[0].locality}";
          await updatePosition(position, address);

          double jarak = Geolocator.distanceBetween(-6.8745447,107.5710864, position.latitude, position.longitude);

          await presensi(position, address,jarak);
        } else {
          Get.snackbar("error", dataResponse['message']);
        }
        break;
      case 2:
        indexPage.value = i;
        Get.offAllNamed(Routes.PROFILE);
        break;
      default:
        indexPage.value = i;
        Get.offAllNamed(Routes.HOME);
    }
  }

  Future<void> presensi(Position position, String address,double jarak) async {
    String uid = await auth.currentUser!.uid;
    CollectionReference<Map<String, dynamic>> colpresensi =
        await firestore.collection("pegawai").doc(uid).collection("presensi");
    QuerySnapshot<Map<String, dynamic>> snapPresensi = await colpresensi.get();
    var now = DateTime.now();
    String todayNow =
        DateFormat.yMd().format(DateTime.now()).replaceAll('/', '-');

    String status = "Diluar area";
    if(jarak <= 100){
      status = "Didalam area";
    }

    if (snapPresensi.docs.length == 0){
      await Get.defaultDialog(
        title: "Konfirmasi",
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Apa kamu yakin ingin absen masuk?",
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    colpresensi.doc(todayNow).set({
                      "masuk": {
                        "date": now.toIso8601String(),
                        "address": address,
                        "latitude": position.latitude,
                        "longitude": position.longitude,
                        "status": status,
                        "jarak" : jarak
                      },
                      "date": now.toIso8601String()
                    });
                    Get.back();
                  },
                  child: Text("Ya"),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      );
      Get.snackbar("Berhasil", "Kamu berhasil absen masuk",
          colorText: Colors.white,backgroundColor: Colors.green,snackPosition: SnackPosition.TOP);
    } else {
      DocumentSnapshot<Map<String, dynamic>> docPresensi =
          await colpresensi.doc(todayNow).get();
      if (docPresensi.exists == true) {
        Map<String, dynamic>? dataPresensiToday = docPresensi.data();
        if (dataPresensiToday?['keluar'] != null) {
          Get.snackbar("Maaf", "Kamu sudah absen baik masuk ataupun keluar",
              colorText: Colors.white,backgroundColor: Colors.red,snackPosition: SnackPosition.TOP);
        } else {
          await Get.defaultDialog(
            title: "Konfirmasi",
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Apa kamu yakin ingin absen keluar?",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        colpresensi.doc(todayNow).update({
                          "keluar": {
                            "date": now.toIso8601String(),
                            "address": address,
                            "latitude": position.latitude,
                            "longitude": position.longitude,
                            "status": status,
                            "jarak" : jarak
                          },
                        });
                        Get.back();
                       },
                      child: Text("Ya"),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
          Get.snackbar("Berhasil", "Kamu berhasil absen keluar",
              colorText: Colors.white,backgroundColor: Colors.green,snackPosition: SnackPosition.TOP);
        }
      } else {
        await Get.defaultDialog(
          title: "Konfirmasi",
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Apa kamu yakin ingin absen masuk?",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      colpresensi.doc(todayNow).set({
                        "masuk": {
                          "date": now.toIso8601String(),
                          "address": address,
                          "latitude": position.latitude,
                          "longitude": position.longitude,
                          "status": status,
                          "jarak" : jarak
                        },
                        "date": now.toIso8601String()
                      });
                      Get.back();
                    },
                    child: Text("Ya"),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
        Get.snackbar("Berhasil", "Kamu berhasil absen masuk",
            colorText: Colors.white,backgroundColor: Colors.green,snackPosition: SnackPosition.TOP);
      }
    }
  }

  Future<void> updatePosition(Position position, String address) async {
    String uid = await auth.currentUser!.uid;
    await firestore.collection("pegawai").doc(uid).update({
      "position": {
        "latitude": position.latitude,
        "longitude": position.longitude
      },
      "address": address
    });
  }

  Future<Map<String, dynamic>> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return {
        "message": "Tidak dapat mengambil gps dari device ini",
        "error": true
      };
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return {"message": "Izin menggunakan gps ditolak", "error": true};
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return {
        "message":
            "Setingan hp mu tidak memperbolehkan untuk mengakses gps , ubah pada settingan pada hpmu",
        "error": true
      };
    }
    Position position = await Geolocator.getCurrentPosition();
    return {
      "position": position,
      "message": "berhasil mendapatkan posisi device",
      "error": false
    };
  }
}
