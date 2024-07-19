import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileController extends GetxController {
  RxBool isLoading = false.obs;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUser() async* {
    User? user = auth.currentUser;
    if (user != null) {
      String uid = user.uid;
      yield* firestore.collection('pegawai').doc(uid).snapshots();
    } else {
      // Return an empty stream if the user is not authenticated
      yield* Stream.empty();
    }
  }
}
