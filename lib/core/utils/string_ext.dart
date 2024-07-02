import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

extension StringToBool on String {
  bool toBoolValue() {
    if (isNotEmpty) {
      return toLowerCase() == 'true' ||
          toLowerCase() == '1' ||
          toLowerCase() == 'on';
    }
    return false;
  }

  double? toDoubleValue() {
    if (isNotEmpty) {
      return double.tryParse(this);
    }
    return null;
  }

  int? toIntValue() {
    if (isNotEmpty) {
      return int.tryParse(this);
    }
    return null;
  }
}

extension DateTimeToString on DateTime {
  String formatToDayMonthYearString() {
    final stringToDateTime = DateFormat('dd/MM/yyyy');
    return stringToDateTime.format(this).toString();
  }

  String dateTimeString() {
    final stringToDateTime = DateFormat('dd-MM-yyyy HH:mm');
    return stringToDateTime.format(this).toString();
  }

  String dateTimeEventString() {
    final stringToDateTime = DateFormat('HH:mm dd/MM/yyyy');
    return stringToDateTime.format(this).toString();
  }

}

extension DurationToStrign on Duration {
  format() => toString().split('.').first.padLeft(8, "0");
}

extension StringToDateTime on String {
  DateTime toDateTimeFromISO() {
    try {
      return DateTime.parse(this);
    } catch (e) {}
    return DateTime.now();
  }

  DateTime fromInsertDateTime({bool? toLocal}) {
    String pattern = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
    return DateFormat(pattern).parse(this, toLocal ?? false);
  }

  DateTime toDateTimeLocal() {
    var dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(this, true);
    return dateTime.toLocal();
  }

  DateTime convertToDateTime() {
    final stringToDateTime = DateFormat('yyyy-MM-dd HH:mm:ss');
    return stringToDateTime.parse(this);
  }

  DateTime convertToDateTimeddMMYY() {
    final stringToDateTime = DateFormat('dd/MM/yyyy');
    return stringToDateTime.parse(this);
  }

  DateTime convertToYearMonthDay() {
    final stringToDateTime = DateFormat('yyyy-MM-dd');
    return stringToDateTime.parse(this);
  }

  String formatToYearMonthDayString() {
    final stringToDateTime = DateFormat('yyyy/MM/dd');
    return stringToDateTime.format(DateTime.parse(this)).toString();
  }

  String formatToTimeString() {
    final stringToTime = DateFormat('HH:mm');
    return stringToTime.format(DateTime.parse(this)).toString();
  }

  DateTime convertToTime() {
    final stringToTime = DateFormat('HH:mm');
    return stringToTime.parse(this);
  }
}

extension LongToDateString on int {
  String formatLongToDateTimeString() {
    var dt = DateTime.fromMillisecondsSinceEpoch(this * 1000);
    return DateFormat('dd/MM/yyyy HH:mm').format(dt); // 31/12/2000, 22:00
  }
}

extension FormartMoney on int {
  String formatMoney() {
    final formatCurrency =
    NumberFormat.decimalPattern('en').format(this).replaceAll(",", '.');
    return formatCurrency;
  }



  String toShortFormNumber() {
    bool isGreater = this >= 1000;
    final double value = isGreater ? (this / 1000.0) : toDouble();
    var res = value.toStringAsFixed((this < 1000 || this % 1000 == 0) ? 0 : 1);
    return isGreater ? '$res k' : res;
  }

}

extension MoneyFormatToInt on String {
  int moneyFormatToInt() {
    return replaceAll(',', '').toIntValue() ?? 0;
  }
}

String getFileExtension(String fileName) {
  return fileName.split('.').last;
}

Future<void> launchSocialMediaAppIfInstalled({
  required String url,
}) async {
  try {
    bool launched = await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalApplication); // Launch the app if installed!

    if (!launched) {
      launchUrl(Uri.parse(url), mode: LaunchMode.inAppWebView);
    }
  } catch (e) {
    launchUrl(Uri.parse(url), mode: LaunchMode.inAppWebView);
  }
}




extension HexColor on Color {
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    var color = Colors.white;
    try {
      color = Color(int.parse(buffer.toString(), radix: 16));
    } catch (e) {
      color = Colors.white;
    }
    return color;
  }

  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

extension CountFormat on int {
  String toCountFormat() {
    bool isGreater = this > 1000;
    double value = this / 1000.0;
    return isGreater
        ? '${value.toStringAsFixed(this % 1000 == 0 ? 0 : 1)} k'
        : '$this';
  }

  String toLiveStreamProductFormat() {
    return '+$this';
  }
}
