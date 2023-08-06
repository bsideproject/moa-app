import 'package:freezed_annotation/freezed_annotation.dart';

part 'hashtag_model.freezed.dart';
part 'hashtag_model.g.dart';

@freezed
class HashtagModel with _$HashtagModel {
  const HashtagModel._();
  factory HashtagModel({
    required String tagId,
    required String hashTag,
    int? count,
  }) = _HashtagModel;

  factory HashtagModel.fromJson(Map<String, dynamic> json) =>
      _$HashtagModelFromJson(json);
}
