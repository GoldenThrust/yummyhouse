import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'users.g.dart';

@JsonSerializable()
class User extends Equatable {
  final int id;
  final String name;
  final String email;
  final String? message;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.message
  });


  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  List<Object> get props => [id, name, email];

  static const empty = User(id: 0, name: '-', email: '-');
}
