import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

Future<String> xFileToBase64(XFile xFile) async {
  Uint8List bytes = await xFile.readAsBytes();
  return base64Encode(bytes);
}

Future<double> getImageSize({required String imageURL}) async {
  if (imageURL == '') {
    return 1.4;
  }
  Image image = Image.network(imageURL);
  Completer<ui.Image> completer = Completer<ui.Image>();
  image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((info, _) => completer.complete(info.image)));

  var size = await completer.future;
  var imageRate = size.width / size.height;

  return imageRate > 1.9
      ? 1
      : imageRate < 1.2
          ? 0.8
          : 1.2;
}

bool isStringEncoded(String value) {
  try {
    Uri.decodeFull(value);
    return true;
  } catch (e) {
    return false;
  }
}
