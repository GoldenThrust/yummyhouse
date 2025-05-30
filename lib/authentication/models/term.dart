import 'package:formz/formz.dart';

enum TermofServiceVallidationError {
  decline,
}

class Term extends FormzInput<bool, TermofServiceVallidationError> {
  const Term.pure() : super.pure(false);
  const Term.dirty([super.value = false]) : super.dirty();

  @override
  TermofServiceVallidationError? validator(bool value) {
    if (value == false) {
      return TermofServiceVallidationError.decline;
    }
    return null;
  }
}