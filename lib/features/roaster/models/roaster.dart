import 'package:freezed_annotation/freezed_annotation.dart';
part 'roaster.freezed.dart';
part 'roaster.g.dart';

@freezed
class Roaster with _$Roaster {
  const factory Roaster({
    required String firstName,
    required String lastName,
    required int age,
  }) = _Roaster;

  factory Roaster.fromJson(Map<String, Object?> json)
  => _$RoasterFromJson(json);
}
