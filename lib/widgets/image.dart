import 'dart:async';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:moa_app/constants/color_constants.dart';

class ImagePlaceholder extends StatelessWidget {
  const ImagePlaceholder(
      {super.key, this.borderRadius = 25, this.width = 50, this.height = 50});
  final double borderRadius;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: const Material(
          clipBehavior: Clip.hardEdge,
          color: AppColors.disabled,
          // child: Icon(Icons.person, color: Colors.white),
        ),
      ),
    );
  }
}

class ImageOnNetwork extends HookWidget {
  const ImageOnNetwork({
    super.key,
    required this.imageURL,
    this.borderRadius = 25,
    this.height = 50,
    this.width = 50,
  });
  final String imageURL;
  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return imageURL.isEmpty
        ? ImagePlaceholder(
            borderRadius: borderRadius, width: width, height: height)
        : CachedNetworkImage(
            placeholder: (context, url) => const ImagePlaceholder(),
            imageUrl: imageURL,
            imageBuilder: (context, imageProvider) => Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            errorWidget: (context, url, error) => const ImagePlaceholder(),
            width: width,
            height: height,
          );
  }
}

class ImageCompleter extends HookWidget {
  const ImageCompleter({super.key, required this.imageURL});
  final String imageURL;

  @override
  Widget build(BuildContext context) {
    Image image = Image.network(imageURL);
    Completer<ui.Image> completer = Completer<ui.Image>();
    image.image.resolve(const ImageConfiguration()).addListener(
        ImageStreamListener((info, _) => completer.complete(info.image)));

    return ListView(
      children: [
        FutureBuilder<ui.Image>(
          future: completer.future,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(
                '${snapshot.data!.width}x${snapshot.data!.height}',
                style: Theme.of(context).textTheme.displayMedium,
              );
            } else {
              return const Text('Loading...');
            }
          },
        ),
        image,
      ],
    );
  }
}
