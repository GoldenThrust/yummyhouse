import 'package:authentication_repository/src/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'register.g.dart';

@JsonSerializable(explicitToJson: true)
class Register {
  final String message;
  final User user;
  final String token;

  const Register({
    required this.message,
    required this.user,
    required this.token,
  });

  factory Register.fromJson(Map<String, dynamic> json) => _$RegisterFromJson(json);
  
  Map<String, dynamic> toJson() => _$RegisterToJson(this);
}
