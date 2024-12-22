import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ResultScreen extends StatelessWidget {
  final Uint8List repairedImg;
  final XFile oldImg;

  const ResultScreen(
      {super.key, required this.repairedImg, required this.oldImg});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Result'),
          centerTitle: true,
          scrolledUnderElevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Text('BEFORE'),
              const SizedBox(
                height: 6,
              ),
              SizedBox(
                  height: 350, width: 400, child: Image.file(File(oldImg.path))),
              const SizedBox(
                height: 20,
              ),
              const Text('AFTER'),
              const SizedBox(
                height: 6,
              ),
              SizedBox(height: 350, width: 400, child: Image.memory(repairedImg))
            ],
          ),
        ));
  }
}
