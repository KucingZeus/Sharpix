import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sharpix/screens/result_screen.dart';
import 'package:sharpix/services/api_service.dart';

class HomeController extends GetxController {
  Rxn<XFile> imagePicked = Rxn<XFile>();

  final ApiService apiService = ApiService(Dio());

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final img = await picker.pickImage(source: ImageSource.gallery);

    if (img == null) {
      return;
    }

    imagePicked.value = img;
  }

  Future<void> sendImage() async {
    if (imagePicked.value == null) {
      return;
    }

    Get.defaultDialog(
        title: '',
        content: const Center(
          child: Column(
            children: [
              CircularProgressIndicator(),
              SizedBox(
                height: 12,
              ),
              Text('Processing')
            ],
          ),
        ));

    final res = await apiService.sendImage(imagePicked.value!);

    Get.back();

    if (res != null) {
      await Get.to(() => ResultScreen(
            oldImg: imagePicked.value!,
            repairedImg: res,
          ));

      deleteImage();
    } else {
      Get.defaultDialog(
          title: 'Error!',
          content: const Text(
            'The server might temporarily closed or check your internet connection. Please try again',
            textAlign: TextAlign.center,
          ));
    }
  }

  void deleteImage() => imagePicked.value = null;
}
