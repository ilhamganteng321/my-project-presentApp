import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/add_pegawai_controller.dart';
class AddPegawaiView extends GetView<AddPegawaiController> {
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AddPegawaiView'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: controller.nipC,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              labelText: 'Nip',
            ),
          ),
          SizedBox(height: 20,),
          TextField(
            controller: controller.namaC,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              labelText: 'Name',
            ),
          ),
          SizedBox(height: 20,),
          TextField(
            controller: controller.jobC,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              labelText: 'Job',
            ),
          ),
          SizedBox(height: 20,),
          TextField(
            controller: controller.emailC,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              labelText: 'Email',
            ),
          ),
          SizedBox(height: 20,),
          Obx(
              ()=> ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(20),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
              if(controller.isLoading.isFalse){
                await controller.addPegawai();
              }
            }, child: Text(controller.isLoading.isFalse ?'Add Pegawai' : 'Loading...')
            ),
          )
        ],
      )
    );
  }
}
