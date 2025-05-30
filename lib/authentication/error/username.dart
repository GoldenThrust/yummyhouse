import 'package:yummyhouse/authentication/authentication.dart';

String usernameError(UsernameValidationError displayError) {
  return switch (displayError) {
    UsernameValidationError.empty => 'Username can\'t be empty',
    UsernameValidationError.tooShort => 'Username is too short',
    UsernameValidationError.tooLong => 'Username is too long',
  };
}
