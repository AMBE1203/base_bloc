const kVi = 'VI';
const kEn = 'EN';

enum LanguageCode { vi, en }

extension LanguageCodeValue on LanguageCode {
  String get code {
    switch (this) {
      case LanguageCode.en:
        return kEn;
      default:
        return kVi;
    }
  }
}

LanguageCode getLanguageCodeFromString({required String code}) {
  return code == kEn ? LanguageCode.en : LanguageCode.vi;
}
