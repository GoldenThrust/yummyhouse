import 'package:formz/formz.dart';

enum PasswordValidationError {
  empty,
  tooShort,
  noUppercase,
  noLowercase,
  noDigit,
  noSpecialCharacter,
}

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure() : super.pure('');
  const Password.dirty([super.value = '']) : super.dirty();

  @override
  PasswordValidationError? validator(String value) {
    if (value.isEmpty) {
      return PasswordValidationError.empty;
    } else if (value.length < 8) {
      return PasswordValidationError.tooShort;
    } else if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return PasswordValidationError.noUppercase;
    } else if (!RegExp(r'[a-z]').hasMatch(value)) {
      return PasswordValidationError.noLowercase;
    } else if (!RegExp(r'\d').hasMatch(value)) {
      return PasswordValidationError.noDigit;
    } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return PasswordValidationError.noSpecialCharacter;
    }
    return null;
  }
}