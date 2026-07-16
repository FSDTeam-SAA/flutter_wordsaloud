// import 'package:json_annotation/json_annotation.dart';
// import 'package:equatable/equatable.dart';

// part 'user_components.g.dart';

// @JsonSerializable()
// class ProfileImage extends Equatable {
//   @JsonKey(name: 'public_id', defaultValue: '')
//   final String publicId;
//   @JsonKey(defaultValue: '')
//   final String url;

//   const ProfileImage({required this.publicId, required this.url});

//   factory ProfileImage.fromJson(Map<String, dynamic> json) =>
//       _$ProfileImageFromJson(json);

//   Map<String, dynamic> toJson() => _$ProfileImageToJson(this);

//   @override
//   List<Object?> get props => [publicId, url];
// }

// @JsonSerializable()
// class CoverImage extends Equatable {
//   @JsonKey(name: 'public_id', defaultValue: '')
//   final String publicId;
//   @JsonKey(defaultValue: '')
//   final String url;

//   const CoverImage({required this.publicId, required this.url});

//   factory CoverImage.fromJson(Map<String, dynamic> json) =>
//       _$CoverImageFromJson(json);

//   Map<String, dynamic> toJson() => _$CoverImageToJson(this);

//   @override
//   List<Object?> get props => [publicId, url];
// }
