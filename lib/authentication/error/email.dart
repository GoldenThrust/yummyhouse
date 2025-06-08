import 'package:yummyhouse/authentication/authentication.dart';

String emailError(EmailValidationError displayError) {
  return switch (displayError) {
    EmailValidationError.empty => 'Email can\'t be empty',
    EmailValidationError.invalid => "Invalid email format",
  };
}
