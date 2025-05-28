import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'error.g.dart';

@JsonSerializable()
class ErrorMessage extends Equatable {
  final String message;
  const ErrorMessage({
    required this.message,
  });


  factory ErrorMessage.fromJson(Map<String, dynamic> json) => _$ErrorMessageFromJson(json);
  Map<String, dynamic> toJson() => _$ErrorMessageToJson(this);

  @override
  List<Object> get props => [message];
}
