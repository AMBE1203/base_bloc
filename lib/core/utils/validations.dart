import 'dart:async';

const onlyNumberRegex = r'^[0-9]+$';
const emailRegex =
    r'[a-zA-Z0-9\+\.\_\%\-]{1,256}\@[a-zA-Z0-9][a-zA-Z0-9\-]{0,64}(\.[a-zA-Z0-9][a-zA-Z0-9\-]{0,25}){1,2}';

const passwordRegex =
    r"^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[\!\@\#\&\(\)\-\[\{\}\]\:\;\'\,\?\/\*\~\$\^\+\=\<\>]).{8,20}";

typedef ValidatorFunction = bool Function(String, String?);

const int minLengthPassword = 8;
const int maxLengthPassword = 20;
const int maxLengthName = 256;
const int maxLengthAddress = 256;
const int maxLengthPhone = 11;
const int maxLengthEmail = 256;

class Validators {
  final validatePasswordTransformer =
      StreamTransformer<String, bool>.fromHandlers(
          handleData: (password, sink) {
    RegExp regex = RegExp(passwordRegex);
    sink.add(regex.hasMatch(password));
  });
  final validateEmailTransformer =
      StreamTransformer<String, bool>.fromHandlers(handleData: (email, sink) {
    sink.add(email.isNotEmpty ? isEmailValid(email) : true);
  });

  final validateOTPCodeTransformer =
      StreamTransformer<String, bool>.fromHandlers(handleData: (otp, sink) {
    sink.add(otp.length == 4);
  });

  static bool isPasswordValid(String inputPassword) {
    RegExp regex = RegExp(passwordRegex);
    return regex.hasMatch(inputPassword);
  }

  static bool isEmailValid(String email) {
    RegExp regex = RegExp(emailRegex);
    return regex.hasMatch(email);
  }

  static bool isTheSameText(String password, String? passwordConfirm) {
    return password == passwordConfirm;
  }

  static bool isFullNameValid(String inputFullName, String? text) {
    return inputFullName.isNotEmpty;
  }
}
