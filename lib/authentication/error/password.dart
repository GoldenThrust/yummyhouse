import 'package:yummyhouse/authentication/authentication.dart';

String passwordError(PasswordValidationError displayError) {
  return switch (displayError) {
    PasswordValidationError.empty => 'Password can\'t be empty',
    PasswordValidationError.noDigit =>
      'Password must include at least one digit',
    PasswordValidationError.noLowercase =>
      'Password must include a lowercase letter',
    PasswordValidationError.noUppercase =>
      'Password must include an uppercase letter',
    PasswordValidationError.tooShort =>
      'Password must be at least 8 characters long',
    PasswordValidationError.noSpecialCharacter =>
      'Password must include a special character',
  };
}
