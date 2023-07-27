import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<String> xFileToBase64(XFile xFile) async {
  Uint8List bytes = await xFile.readAsBytes();
  return base64Encode(bytes);
}

Future<num> getImageSize({required String imageURL}) async {
  Image image = Image.network(imageURL);
  Completer<ui.Image> completer = Completer<ui.Image>();
  image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((info, _) => completer.complete(info.image)));

  var size = await completer.future;
  var imageRate = size.width / size.height;

  return imageRate > 1.9
      ? 1.9
      : imageRate < 1.2
          ? 1.2
          : imageRate;
}

bool isStringEncoded(String value) {
  try {
    Uri.decodeFull(value);
    return true;
  } catch (e) {
    return false;
  }
}
