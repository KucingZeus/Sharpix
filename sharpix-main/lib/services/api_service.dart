// ignore_for_file: avoid_print

import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

class ApiService {
  final Dio _dio = Dio();

  ApiService(dio) {
    // AVD
    // _dio.options.baseUrl = 'http://10.0.2.2:5000/';

    // NON AVD
    // _dio.options.baseUrl = 'http://127.0.0.1:5000/';

    // RAILWAY
    _dio.options.baseUrl = 'https://flask-production-1deb.up.railway.app/';
  }

  Future<Uint8List?> sendImage(XFile file) async {
    try {
      FormData formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(file.path, filename: file.name)
      });

      final response = await _dio.post('/upload',
          data: formData, options: Options(responseType: ResponseType.bytes));
      print('File uploaded: ${response.data}');

      return response.data;
    } catch (e) {
      print('Error receiving file: $e');
      return null;
    }
  }
}
