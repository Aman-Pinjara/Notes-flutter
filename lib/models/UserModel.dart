import '../database/UserDb.dart';

class UserModel {
  final int? id;
  final String name;
  final double totalBalance;
  final String? description;

  UserModel({
    this.id,
    required this.name,
    required this.totalBalance,
    this.description,
  });

  static UserModel fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json[UserTableName.id],
      name: json[UserTableName.name],
      totalBalance: json[UserTableName.totalBalance].toDouble(),
      description: json[UserTableName.description],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data[UserTableName.id] = id;
    data[UserTableName.name] = name;
    data[UserTableName.totalBalance] = totalBalance;
    data[UserTableName.description] = description;

    return data;
  }

  UserModel copy({
    int? id,
    String? name,
    double? totalBalance,
    String? description,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      totalBalance: totalBalance ?? this.totalBalance,
      description: description ?? this.description,
    );
  }
}
