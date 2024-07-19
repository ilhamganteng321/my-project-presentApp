import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/update_profile_controller.dart';

class UpdateProfileView extends GetView<UpdateProfileController>{
  final Map<String, dynamic> user = Get.arguments;
  @override
  Widget build(BuildContext context) {
    controller.nipC.text = user['nip'];
    controller.namaC.text = user['nama'];
    controller.emailC.text = user['email'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Update profile'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            readOnly: true,
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
            readOnly: true,
            controller: controller.emailC,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              labelText: 'Email',
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
          Text("Photo profile", style: TextStyle(fontWeight: FontWeight.bold),),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GetBuilder<UpdateProfileController>
                (builder: (controller) {
                  if(controller.image != null){
                    return ClipOval(
                      child: Container(
                        height: 100,
                        width: 100,
                        child: Image.file(File(controller.image!.path),fit: BoxFit.cover,),
                      ),
                    );
                  }else{
                    if(user['profile'] != null){
                      return Column(
                        children: [
                          ClipOval(
                            child: Container(
                              height: 100,
                              width: 100,
                              child: Image.network(user['profile'],fit: BoxFit.cover,),
                            ),
                          ),
                          TextButton(onPressed: () {
                            controller.deleteProfile(user['uid']).then((_){
                              controller.image;
                              controller.update();
                            });
                          }, child: Text("Delete"))
                        ],
                      );
                    }else {
                      return Text("belum ada photo");
                    }
                  }
                },),
              TextButton(onPressed: () {
                controller.pickImage();
              }, child: Text("pilih gambar"))
            ],
          ),
          SizedBox(height: 20,),
          Obx(
                () =>
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(20),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    if (controller.isLoading.isFalse) {
                      controller.isLoading.value = true;
                      await controller.updateProfile(user['uid']);
                      controller.isLoading.value = false;
                    }
                  },
                  child: Text(controller.isLoading.isFalse
                      ? 'Update profile'
                      : 'Loading...'),
                ),
          )
        ],
      ),
    );
  }
}
