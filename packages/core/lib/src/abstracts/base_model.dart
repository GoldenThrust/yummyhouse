import 'package:equatable/equatable.dart';

/// A base class that all models should extend.
abstract class BaseModel extends Equatable  {
  /// Parses a JSON map into an instance of the subclass.
  const BaseModel();

  @override
  List<Object> get props => [];
}