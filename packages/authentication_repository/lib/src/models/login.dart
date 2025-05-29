import 'package:json_annotation/json_annotation.dart';

part 'login.g.dart';

@JsonSerializable(explicitToJson: true)
class Login {
  final String user;
  final String token;

  const Login({
    required this.user,
    required this.token,
  });

  factory Login.fromJson(Map<String, dynamic> json) => _$LoginFromJson(json);
  
  Map<String, dynamic> toJson() => _$LoginToJson(this);
}
