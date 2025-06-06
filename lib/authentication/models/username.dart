import 'package:formz/formz.dart';

enum UsernameValidationError { 
  empty, 
  tooShort, 
  tooLong 
}
class Username extends FormzInput<String, UsernameValidationError> {
  const Username.pure() : super.pure('');
  const Username.dirty([super.value = '']) : super.dirty();

  @override
  UsernameValidationError? validator(String value) {
    if (value.isEmpty) {
      return UsernameValidationError.empty;
    } else if (value.length < 3) {
      return UsernameValidationError.tooShort;
    } else if (value.length > 20) {
      return UsernameValidationError.tooLong;
    }
    return null;
  }
}