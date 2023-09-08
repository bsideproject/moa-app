import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moa_app/utils/converter.dart';

part 'folder_model.freezed.dart';
part 'folder_model.g.dart';

@freezed
class FolderModel with _$FolderModel {
  const factory FolderModel({
    required String folderId,
    required String folderName,
    @ColorConverter() required Color folderColor,
    String? thumbnailUrl,
    required int count,
    String? updatedDate,
  }) = _FolderModel;

  factory FolderModel.fromJson(Map<String, dynamic> json) =>
      _$FolderModelFromJson(json);
}
