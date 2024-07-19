import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:present_app/app/controllers/page_index_controller.dart';
import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeView extends GetView<HomeController> {
  final pageC = Get.find<PageIndexController>();
  String todayNow = DateFormat.yMd().format(DateTime.now()).replaceAll('/', '-');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HOME'),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: controller.streamUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data?.data() == null) {
            return Center(child: Text("No user data found"));
          }
          Map<String, dynamic> user = snapshot.data!.data()!;

          return ListView(
            padding: EdgeInsets.all(20),
            children: [
              Row(
                children: [
                  ClipOval(
                    child: Container(
                      width: 75,
                      height: 75,
                      color: Colors.grey[200],
                      child: Image.network(
                        user['profile'] ?? "https://ui-avatars.com/api/?name=${user['nama']}",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        width: 200,
                        child: Text(user['address'] ?? "tidak ada lokasi"),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey[200],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${user['job']}".toUpperCase(),
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "${user['nip']}".toUpperCase(),
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${user['nama']}",
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey[200],
                ),
                child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: controller.streamTodayPresent(),
                  builder: (context, snapshotToday) {
                    if (snapshotToday.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (!snapshotToday.hasData || snapshotToday.data?.data() == null) {
                      return Center(child: Text("No today's presence data found"));
                    }
                    var dataToday = snapshotToday.data!.data()!;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text("masuk"),
                            Text(
                              dataToday['masuk'] != null && dataToday['masuk']['date'] != null
                                  ? DateFormat.jms().format(DateTime.parse(dataToday['masuk']['date']))
                                  : "-",
                            ),
                          ],
                        ),
                        Container(height: 40, width: 2, color: Colors.grey),
                        Column(
                          children: [
                            Text("keluar"),
                            Text(
                              dataToday['keluar'] != null && dataToday['keluar']['date'] != null
                                  ? DateFormat.jms().format(DateTime.parse(dataToday['keluar']['date']))
                                  : "-",
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              Divider(color: Colors.grey[300], thickness: 2),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "5 hari yang lalu",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.toNamed(Routes.ALL_PRESENSI);
                    },
                    child: Text("Lihat lebih lanjut"),
                  ),
                ],
              ),
              SizedBox(height: 10),
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: controller.streamPresensi(),
                builder: (context, snapshotPresent) {
                  if (snapshotPresent.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshotPresent.hasData || snapshotPresent.data?.docs.isEmpty == true) {
                    return SizedBox(
                      height: 150,
                      child: Center(child: Text("belum ada history absen")),
                    );
                  }

                  return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      Map<String, dynamic> data = snapshotPresent.data!.docs[index].data();
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Material(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey.withOpacity(0.2),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              Get.toNamed(Routes.DETAIL_PRESENSI, arguments: data);
                            },
                            child: Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "masuk",
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        data['date'] != null
                                            ? DateFormat.yMMMMEEEEd().format(DateTime.parse(data['date']))
                                            : "Belum ada tanggal",
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    data['masuk'] != null && data['masuk']['date'] != null
                                        ? DateFormat.jms().format(DateTime.parse(data['masuk']['date']))
                                        : "Belum absen masuk",
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    "keluar",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    data['keluar'] != null && data['keluar']['date'] != null
                                        ? DateFormat.jms().format(DateTime.parse(data['keluar']['date']))
                                        : "Belum absen keluar",
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    shrinkWrap: true,
                    itemCount: snapshotPresent.data!.docs.length,
                  );
                },
              ),
            ],
          );
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
      ),
    );
  }
}
