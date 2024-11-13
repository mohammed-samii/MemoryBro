import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 3)
class User {
  @HiveField(0)
  final String username;  // The user’s name or unique identifier

  User({required this.username});
}
