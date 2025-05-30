import 'package:yummyhouse/authentication/models/term.dart';

String termError(TermofServiceVallidationError displayError) {
  return switch (displayError) {
    TermofServiceVallidationError.decline => 'You must accept the terms of service and privacy policy',
  };
}
