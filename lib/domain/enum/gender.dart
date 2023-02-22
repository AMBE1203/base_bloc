const kMale = "MALE";
const kFemale = "FEMALE";

enum Gender { male, female }

extension GenderValue on Gender {
  String get value {
    switch (this) {
      case Gender.female:
        return kFemale;
      default:
        return kMale;
    }
  }
}

Gender getGenderFromString({required String gender}) {
  return gender == kMale ? Gender.male : Gender.female;
}
