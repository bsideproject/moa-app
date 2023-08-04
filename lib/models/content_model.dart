import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moa_app/models/hashtag_model.dart';

part 'content_model.freezed.dart';
part 'content_model.g.dart';

@freezed
class ContentModel with _$ContentModel {
  const ContentModel._();
  factory ContentModel({
    required String contentId,
    required String contentImageUrl,
    String? contentUrl,
    String? contentMemo,
    required String contentName,
    String? folderName,
    required List<HashtagModel> contentHashTag,
  }) = _ContentModel;

  factory ContentModel.fromJson(Map<String, dynamic> json) =>
      _$ContentModelFromJson(json);
}
