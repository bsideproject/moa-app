import 'package:freezed_annotation/freezed_annotation.dart';

part 'content_model.freezed.dart';
part 'content_model.g.dart';

@freezed
class ContentModel with _$ContentModel {
  const ContentModel._();
  factory ContentModel({
    required String title,
    required String description,
    required String image,
    required String url,
  }) = _ContentModel;

  factory ContentModel.fromJson(Map<String, dynamic> json) =>
      _$ContentModelFromJson(json);
}
