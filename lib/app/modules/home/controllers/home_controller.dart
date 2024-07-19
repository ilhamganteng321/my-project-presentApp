import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:intl/intl.dart';
class HomeController extends GetxController {
  RxBool isLoading = false.obs;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUser() async* {
    String uid = auth.currentUser!.uid;
    yield* firestore.collection('pegawai').doc(uid).snapshots();
  }
  Stream<QuerySnapshot<Map<String, dynamic>>> streamPresensi() async* {
    String uid = auth.currentUser!.uid;
    yield* firestore.collection('pegawai').doc(uid).collection('presensi').orderBy('date',descending: true).limitToLast(5).snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamTodayPresent() async* {
    String uid = auth.currentUser!.uid;
    String today = DateFormat.yMd().format(DateTime.now()).replaceAll('/', '-');
    yield* firestore.collection('pegawai').doc(uid).collection('presensi').doc(today).snapshots();
  }
}
