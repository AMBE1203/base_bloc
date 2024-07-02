import 'package:base_bloc/presentation/resource/index.dart';
import 'package:base_bloc/presentation/styles/index.dart';
import 'package:base_bloc/presentation/utils/index.dart';
import 'package:base_bloc/presentation/widgets/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

mixin BasePageMixin {
  Future<void> showSnackBarMessage(
      String msg, BuildContext context, VoidCallback callback) async {
    final snackBar = SnackBar(
      backgroundColor: AppColors.primaryColor,
      content: Container(
        height: 50,
        color: AppColors.primaryColor,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(msg,
              style: bodyMedium.copyWith(
                  color: Colors.white, fontWeight: FontWeight.w500)),
        ),
      ),
    );
    ScaffoldMessenger.of(context)
        .showSnackBar(snackBar)
        .closed
        .then((value) => callback);
  }

  hideKeyboard(context) {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  showKeyboard(context, inputNode) {
    FocusScope.of(context).requestFocus(inputNode);
  }

  Future<bool?> share(
      {String? title,
      String? text,
      String? linkUrl,
      String? filePath,
      String? chooserTitle}) async {
    final res = await FlutterShare.share(
        title: title ?? AppLocalizations.shared.appName,
        text: text ?? '',
        linkUrl: linkUrl,
        chooserTitle: chooserTitle ?? AppLocalizations.shared.shareTitleDialog);
    return res;
  }

  showToast(
      {required String content,
      Color? bgrColor,
      double? fontSize,
      Color? textColor,
      Toast? toastLength,
      ToastGravity? gravity}) {
    Fluttertoast.showToast(
        msg: content,
        toastLength: toastLength ?? Toast.LENGTH_LONG,
        gravity: gravity ?? ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: bgrColor ?? const Color.fromARGB(150, 0, 0, 0),
        textColor: textColor ?? Colors.white,
        fontSize: fontSize ?? 16.0);
  }

  Future<bool> showAlert(
      {required BuildContext context,
      String? title,
      required String message,
      String? okActionTitle,
      String? cancelTitle,
      TextStyle? titleStyle,
      TextStyle? messageStyle,
      String? image,
      bool? dismissWithBackPress,
      bool? isRichText,
      Color primaryColor = AppColors.primaryBtnColor}) async {
    final result = await AlertManager.showAlert(
        context: context,
        message: message,
        title: title,
        okActionTitle: okActionTitle,
        cancelTitle: cancelTitle,
        image: image,
        isRichText: isRichText,
        titleStyle: titleStyle,
        dismissWithBackPress: dismissWithBackPress,
        messageStyle: messageStyle,
        primaryColor: primaryColor);
    return result;
  }

  Widget buildLoading() {
    return const Center(
        child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
    ));
  }

  buildBottomLoadMore({Color? backgroundColor, Alignment? alignment}) {
    return Container(
      alignment: alignment ?? Alignment.center,
      color: backgroundColor ?? AppColors.gray.withAlpha(150),
      child: const Center(
        child: SizedBox(
          width: 32,
          height: 32,
          child: CupertinoActivityIndicator(),
        ),
      ),
    );
  }

  showBottomSheetMenu<T>(
      {required Widget child,
      required BuildContext context,
      double? height,
      double? radius,
      bool isDismissible = false}) {
    return showModalBottomSheet<T>(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        isScrollControlled: true,
        enableDrag: true,
        isDismissible: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Wrap(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(radius ?? 3),
                    topLeft: Radius.circular(radius ?? 3)),
                child: Container(
                    color: Colors.white,
                    alignment: Alignment.center,
                    child: Center(child: child)),
              )
            ],
          );
        });
  }

  Widget buildShimmer({int count = 20}) {
    final children = List.generate(count, (index) => const ShimmerWidget());
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: children,
    );
  }

  openUrl({
    required String url,
  }) async {
    String encodedUrl = Uri.encodeFull(url);
    Uri uri = Uri.parse(encodedUrl);
    if (await canLaunchUrl(uri)) {
      launchUrl(
        uri,
        mode: LaunchMode.inAppWebView,
      );
    }
  }
}
