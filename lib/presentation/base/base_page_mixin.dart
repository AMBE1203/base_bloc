import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:images_picker/images_picker.dart';
import 'package:lunar_calendar/presentation/resources/index.dart';
import 'package:lunar_calendar/presentation/styles/index.dart';
import 'package:lunar_calendar/presentation/utils/index.dart';
import 'package:lunar_calendar/presentation/widgets/index.dart';
import 'package:url_launcher/url_launcher.dart';

mixin BasePageMixin {
  Future<void> showSnackBarMessage(String msg, BuildContext context) async {
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
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  hideKeyboard(context) {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  Future<dynamic> showWidgetDialog(
      {required BuildContext context, required Widget child}) async {
    return AlertManager.showWidgetDialog(context: context, child: child);
  }

  Future<void> share(
      {String? title,
      String? text,
      String? linkUrl,
      String? filePath,
      String? chooserTitle}) async {
    await FlutterShare.share(
        title: title ?? AppLocalizations.shared.appName,
        text: text ?? '',
        linkUrl: linkUrl,
        chooserTitle: chooserTitle ?? AppLocalizations.shared.shareTitleDialog);
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
      Color primaryColor = AppColors.primaryColor}) async {
    final result = await AlertManager.showAlert(
        context: context,
        message: message,
        title: title,
        okActionTitle: okActionTitle,
        cancelTitle: cancelTitle,
        image: image,
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

  buildBottomLoadMore({Color? backgroundColor}) {
    return Container(
      alignment: Alignment.center,
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

        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        // ),
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

  // buildHeaderPageAppBar(
  //     {required BuildContext context,
  //     Key? key,
  //     String? title,
  //     TextStyle? titleStyle,
  //     AssetImage? leftIcon,
  //     Function? leftClicked,
  //     Function(dynamic)? rightClicked,
  //     AssetImage? rightIcon,
  //     Color? backgroundColor,
  //     EdgeInsets? contentPadding,
  //     bool? showLeftIcon,
  //     // generic case
  //     Widget? titleWidget,
  //     Widget? leftWidget,
  //     Widget? rightWidget,
  //     int alpha = 160,
  //     Color colorIconLeft = Colors.black,
  //     Color colorIconRight = Colors.white}) {
  //   return PreferredSize(
  //       key: key,
  //       preferredSize: const Size.fromHeight(50),
  //       child: PageHeaderWidget(
  //         backgroundColor: backgroundColor ?? Colors.transparent,
  //         title: title,
  //         titleStyle: titleStyle,
  //         leftIcon: leftIcon,
  //         rightIcon: rightIcon,
  //         showLeftIcon: showLeftIcon,
  //         leftClicked: leftClicked,
  //         rightClicked: rightClicked,
  //         contentPadding: contentPadding,
  //         titleWidget: titleWidget,
  //         leftWidget: leftWidget,
  //         rightWidget: rightWidget,
  //         colorIconLeft: colorIconLeft,
  //         colorIconRight: colorIconRight,
  //       ));
  // }

  Widget buildShimmer({int count = 20}) {
    final children = List.generate(count, (index) => const ShimmerItemWidget());
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: children,
    );
  }

  Widget buildNoDataMessage() {
    return LayoutBuilder(builder: (context, constrained) {
      return SizedBox(
        height: constrained.maxHeight,
        child: Center(
          child: Text(
            AppLocalizations.shared.commonMessageNoData,
            style: bodyMedium.copyWith(
                color: Colors.white, fontSize: 17, fontWeight: FontWeight.w400),
          ),
        ),
      );
    });
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

  Future<List<Media>?> takePhotoFromCamera(
      {int? maxSize, double? quality}) async {
    List<Media>? images = await ImagesPicker.openCamera(
        pickType: PickType.image,
        maxSize: maxSize ?? 600,
        quality: quality ?? 0.5,
        cropOpt: CropOption(
          aspectRatio: CropAspectRatio.custom,
          cropType: CropType.rect,
        ));
    return images;
  }

  Future<List<Media>?> pickAPhotoFromGallery({
    int count = 1,
    int? maxSize,
    double? quality,
  }) async {
    List<Media>? images = await ImagesPicker.pick(
        count: count,
        pickType: PickType.image,
        maxSize: maxSize ?? 600,
        quality: quality ?? 0.5,
        cropOpt: CropOption(
          aspectRatio: CropAspectRatio.custom,
          cropType: CropType.rect,
        ));
    return images;
  }
}
