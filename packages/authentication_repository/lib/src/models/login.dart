import 'package:authentication_repository/src/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login.g.dart';

@JsonSerializable(explicitToJson: true)
class Login {
  final User user;
  final String token;

  const Login({
    required this.user,
    required this.token,
  });

  factory Login.fromJson(Map<String, dynamic> json) => _$LoginFromJson(json);
  
  Map<String, dynamic> toJson() => _$LoginToJson(this);
}
