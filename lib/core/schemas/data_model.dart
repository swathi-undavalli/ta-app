import 'package:isar/isar.dart';
part 'data_model.g.dart';

@collection
class DataModel {
  Id id = Isar.autoIncrement;

  final String data;
  final DateTime? updatedAt;
  final DateTime createdAt;
  final String firebasePath;

  DataModel({
    required this.data,
    required this.updatedAt,
    required this.firebasePath,
    required this.createdAt,
  });

  DataModel copyWith({DateTime? updatedAt}) {
    return DataModel(
      data: data,
      updatedAt: updatedAt ?? this.updatedAt,
      firebasePath: firebasePath,
      createdAt: createdAt,
    );
  }
}
