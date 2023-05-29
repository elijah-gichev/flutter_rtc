import 'package:firebase_database/firebase_database.dart';

class User {
  final String id;
  final String name;
  final bool isOnline;

  const User({
    required this.id,
    required this.name,
    required this.isOnline,
  });

  factory User.fromFirebase(DataSnapshot snapshot) {
    final data = snapshot.value as Map<Object?, Object?>;

    return User(
      id: data['account_id'] as String,
      name: data['name'] as String,
      isOnline: data['is_online'] as bool,
    );
  }

  User copyWith({
    String? id,
    String? name,
    bool? isOnline,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      isOnline: isOnline ?? this.isOnline,
    );
  }
}
