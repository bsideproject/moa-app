import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:http/http.dart' as http;
import 'package:moa_app/models/content_model.dart';
import 'package:moa_app/widgets/common/button.dart';
import 'package:moa_app/widgets/common/image.dart';
import 'package:moa_app/widgets/common/styles.dart';

class UserListingScreen extends HookWidget {
  const UserListingScreen({super.key, this.files, this.text});
  final List<File>? files;
  final String? text;

  @override
  Widget build(BuildContext context) {
    var content = useState(ContentModel(
      title: '',
      image: '',
      url: '',
      description: '',
    ));

    void getCrawlUrl(String text) async {
      await http.get(Uri.parse(text)).then((response) {
        var document = html_parser.parse(response.body);

        var title = document.head
            ?.querySelector("meta[property='og:title']")
            ?.attributes['content'];
        var description = document.head
            ?.querySelector("meta[property='og:description']")
            ?.attributes['content'];
        var image = document.head
            ?.querySelector("meta[property='og:image']")
            ?.attributes['content'];
        var url = document.head
            ?.querySelector("meta[property='og:url']")
            ?.attributes['content'];

        content.value = content.value.copyWith(
          title: title ?? '',
          description: description ?? '',
          image: image ?? '',
          url: url ?? '',
        );
      });
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'receive url',
            style: TitleTextStyle(),
          ),
          const SizedBox(height: 10),
          Text('$text'),
          const SizedBox(height: 10),
          Button(
            text: 'Crawl',
            onPress: () {
              if (text != null) {
                getCrawlUrl(text!);
              }
            },
          ),
          const SizedBox(height: 20),
          content.value.image.isEmpty
              ? const SizedBox()
              : ImageOnNetwork(
                  width: double.infinity,
                  height: 200,
                  imageURL: content.value.image),
          const SizedBox(height: 20),
          Text(
            content.value.title,
            style: const TitleTextStyle(),
          ),
          const SizedBox(height: 5),
          Text(
            content.value.description,
            style: const SubTitleTextStyle(),
          ),
          const SizedBox(height: 5),
          Text(
            content.value.url,
            style: const SubTitleTextStyle(),
          ),
        ],
      ),
    );
  }
}
