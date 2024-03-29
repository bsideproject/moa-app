import 'dart:async';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/widgets/moa_widgets/empty_image.dart';

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
    this.imageURL,
    this.borderRadius = 10,
    this.height = 50,
    this.width = 50,
    this.border,
    this.fit = BoxFit.cover,
    this.aspectRatio,
  });
  final String? imageURL;
  final double width;
  final double height;
  final double borderRadius;
  final Border? border;
  final BoxFit? fit;
  final double? aspectRatio;

  @override
  Widget build(BuildContext context) {
    if (imageURL == null) {
      return AspectRatio(
          aspectRatio: 1, child: ImagePlaceholder(borderRadius: borderRadius));
    }
    return imageURL!.isEmpty
        ? EmptyImage(
            aspectRatio: aspectRatio,
          )
        : Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              border: border ??
                  Border.all(color: AppColors.moaOpacity30, width: 0.5),
              borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
            ),
            child: CachedNetworkImage(
              placeholder: (context, url) =>
                  Image.network(fit: BoxFit.cover, url),
              imageUrl: imageURL!,
              errorWidget: (context, url, error) => ImagePlaceholder(
                borderRadius: borderRadius,
                width: width,
                height: height,
              ),
            ),
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
