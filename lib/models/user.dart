import 'package:floor/floor.dart';

@entity
class User {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String name;
  User({this.id, required this.name});

  User copyWith({String? name}) {
    return User(name: name ?? this.name, id: id);
  }
}
