import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'error.g.dart';

@JsonSerializable()
class Message extends Equatable {
  final String message;
  const Message({
    required this.message,
  });


  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);
  Map<String, dynamic> toJson() => _$MessageToJson(this);

  @override
  List<Object> get props => [message];
}
