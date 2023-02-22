const vNLanguageCode = 'VI';
const eNLanguageCode = 'EN';

enum LanguageCode { vi, en }

extension LanguageCodeValue on LanguageCode {
  String get code {
    switch (this) {
      case LanguageCode.en:
        return eNLanguageCode;
      default:
        return vNLanguageCode;
    }
  }
}

LanguageCode getLanguageCodeFromString({required String code}) {
  return code == eNLanguageCode ? LanguageCode.en : LanguageCode.vi;
}
