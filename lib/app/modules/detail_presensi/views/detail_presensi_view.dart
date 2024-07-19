import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/detail_presensi_controller.dart';

class DetailPresensiView extends GetView<DetailPresensiController> {
  Map<String,dynamic> data = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Detail Presensi'.toUpperCase()),
          centerTitle: true,
        ),
        body: ListView(padding: EdgeInsets.all(20), children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "${DateFormat.yMMMMEEEEd().format(DateTime.parse(data['date']))}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Masuk",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(data?['masuk']['date'] != null
                    ? "jam :${DateFormat.jms().format(DateTime.parse
                    (data?['masuk']['date']))}" :"jam : - "),
                Text(data?['masuk']['status'] != null
                   ? "status :${data?['masuk']['status']}" :"status : - ",),
                Text(data?['masuk']['address'] != null
                    ? "lokasi :${data?['masuk']['address']}" :"lokasi : - ",),
                SizedBox(height: 20),
                Text(
                  "keluar",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(data?['keluar']['date'] != null
                    ? "jam :${DateFormat.jms().format(DateTime.parse
                    (data?['keluar']['date']))}" :"jam : - "),
                Text(data?['keluar']['status'] != null
                    ? "status :${data?['keluar']['status']}" :"status : - ",),
                Text(data?['keluar']['address'] != null
                    ? "laoksi :${data?['keluar']['address']}" :"lokasi : - ",),
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
          ),
        ]));
  }
}
