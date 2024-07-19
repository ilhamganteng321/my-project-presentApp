import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../../controllers/page_index_controller.dart';
import '../../../routes/app_pages.dart';
import '../controllers/profile_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileView extends GetView<ProfileController> {
  final pageC = Get.find<PageIndexController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'.toUpperCase()),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: controller.streamUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData && snapshot.data?.data() != null) {
            Map<String, dynamic> user = snapshot.data!.data()!;
            String defaultImage = "https://ui-avatars.com/api/?name=${user['nama']}";
            print(user);
            return ListView(
              padding: EdgeInsets.all(20),
              children: [
                Image.network(
                    user['profile'] == null ? user['profile'] =='' ? defaultImage : defaultImage : user['profile'],fit: BoxFit.cover,),
                SizedBox(height: 10),
                Text(
                  "${user['nama'].toString().toUpperCase()}",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 10),
                Text(
                  "${user['email']}",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(height: 20),
                ListTile(
                  onTap: () {
                    Get.toNamed(Routes.UPDATE_PROFILE, arguments: user);
                  },
                  leading: Icon(Icons.edit),
                  title: Text("Update profile"),
                ),
                SizedBox(height: 5),
                if (user['role'] == "admin")
                  ListTile(
                    onTap: () {
                      Get.toNamed(Routes.ADD_PEGAWAI);
                    },
                    leading: Icon(Icons.person),
                    title: Text("Add Pegawai"),
                  ),
                SizedBox(height: 5),
                ListTile(
                  onTap: () {
                    Get.toNamed(Routes.UPDATE_PASSWORD);
                  },
                  leading: Icon(Icons.vpn_key),
                  title: Text("Ganti password"),
                ),
                ListTile(
                  onTap: () async {
                    return Get.defaultDialog(
                      title: "Konfirmasi",
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Apa kamu yakin ingin logout?",
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
                                  await FirebaseAuth.instance.signOut();
                                  Get.offAllNamed(Routes.LOGIN);
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
                  },
                  leading: Icon(Icons.logout),
                  title: Text("Logout"),
                ),
              ],
            );
          } else {
            return Center(
              child: Text("Tidak dapat memuat data"),
            );
          }
        },
      ),
        bottomNavigationBar: ConvexAppBar(
          style: TabStyle.fixedCircle,
          items: [
            TabItem(icon: Icons.home, title: 'Home'),
            TabItem(icon: Icons.fingerprint, title: 'Add'),
            TabItem(icon: Icons.add, title: 'profile'),
          ],
          initialActiveIndex: pageC.indexPage.value,
          onTap: (int i) => pageC.changePage(i),
        )
    );
  }
}
