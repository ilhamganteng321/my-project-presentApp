import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AllPresensiController extends GetxController {
  DateTime? startDate;
  DateTime endDate = DateTime.now();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<QuerySnapshot<Map<String, dynamic>>> getAllpresensi() async {
    String uid = auth.currentUser!.uid;
    if(startDate == null){
      return firestore
         .collection('pegawai')
         .doc(uid)
         .collection('presensi')
         .where("date", isGreaterThan: endDate.toIso8601String())
         .orderBy('date', descending: true)
         .get();
    }else{
      return firestore
         .collection('pegawai')
         .doc(uid)
         .collection('presensi')
         .where("date", isGreaterThan: startDate!.toIso8601String())
         .where("date", isLessThan: endDate.add(Duration(days: 1)).toIso8601String())
         .orderBy('date', descending: true)
         .get();
    }
  }

  void pickDate (DateTime startDate, DateTime endDate) async {
    startDate = startDate;
    endDate = endDate;
    update();
    Get.back();
  }
}
