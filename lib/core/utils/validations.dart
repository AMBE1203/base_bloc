import 'dart:async';

const onlyNumberRegex = r'^[0-9]+$';
const emailRegex =
    r'^[_A-Za-z0-9-\\+]+(\.[_A-Za-z0-9-]+)*@[A-Za-z0-9-]+(\.[A-Za-z0-9]+)*(\.[A-Za-z]{2,})$';
const tiktokUrlPattern = 'tiktok.com';
const vnNumberPhoneRegex = r'(84|0[3|5|7|8|9])+([0-9]{8})\b';
const krNumberPhoneRegex = r'^010[0-9]{8}$';

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

  static bool isValidTiktokUrl(String? tiktokUrl) {
    return tiktokUrl?.contains(tiktokUrlPattern) ?? false;
  }
}
