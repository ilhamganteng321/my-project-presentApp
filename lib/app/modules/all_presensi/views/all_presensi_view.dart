import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../routes/app_pages.dart';
import '../controllers/all_presensi_controller.dart';

class AllPresensiView extends GetView<AllPresensiController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Presensi'.toUpperCase()),
        centerTitle: true,
      ),
      body: GetBuilder<AllPresensiController>(
          builder: (c) => FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
              future: controller.getAllpresensi(),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (!snap.hasData || snap.data?.docs.isEmpty == true) {
                  return SizedBox(
                    height: 150,
                    child: Center(child: Text("belum ada history absen")),
                  );
                }
                return ListView.builder(
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  itemBuilder: (context, index) {
                    Map<String, dynamic> data = snap.data!.docs[index].data();
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Material(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey.withOpacity(0.2),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            Get.toNamed(Routes.DETAIL_PRESENSI,
                                arguments: data);
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "masuk",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      data['date'] != null
                                          ? DateFormat.yMMMMEEEEd().format(
                                              DateTime.parse(data['date']))
                                          : "Belum ada tanggal",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Text(
                                  data['masuk'] != null &&
                                          data['masuk']['date'] != null
                                      ? DateFormat.jms().format(
                                          DateTime.parse(data['masuk']['date']))
                                      : "Belum absen masuk",
                                ),
                                SizedBox(height: 20),
                                Text(
                                  "keluar",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  data['keluar'] != null &&
                                          data['keluar']['date'] != null
                                      ? DateFormat.jms().format(DateTime.parse(
                                          data['keluar']['date']))
                                      : "Belum absen keluar",
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: snap.data!.docs.length,
                );
              })),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.dialog(Dialog(
            child: Container(
              padding: EdgeInsets.all(15),
              height: 400,
              child: SfDateRangePicker(
                selectionMode: DateRangePickerSelectionMode.range,
                showActionButtons: true,
                onCancel: () => Get.back(),
                onSubmit: (object) {
                  if (object != null) {
                    if ((object as PickerDateRange).endDate != null) {
                      controller.pickDate(
                          object.startDate!,
                          object.endDate!
                      );
                    }
                  } else {
                    Get.snackbar(
                        "error", "mohon pilih jarak tanggal dengan benar",
                        backgroundColor: Colors.red, colorText: Colors.white);
                  }
                },
              ),
            ),
          ));
        },
        child: Icon(Icons.format_list_bulleted_rounded),
      ),
    );
  }
}
