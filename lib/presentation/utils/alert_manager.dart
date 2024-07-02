import 'package:auto_size_text/auto_size_text.dart';
import 'package:base_bloc/presentation/styles/index.dart';
import 'package:base_bloc/presentation/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:focus_detector_v2/focus_detector_v2.dart';

class AlertManager {
  static int alertShowingCount = 0;
  static final List<String> _showingMessages = [];

  static bool _sameMessageIsShowing(String checkMsg) {
    final index = _showingMessages.indexWhere((element) => checkMsg == element);
    return index >= 0;
  }

  static _onMessageShow(String msg) {
    _showingMessages.add(msg);
  }

  static _onMessageHide(String msg) {
    final index = _showingMessages.indexWhere((element) => msg == element);
    if (index >= 0) {
      _showingMessages.removeAt(index);
    }
  }

  static Future<dynamic> showWidgetDialog(
      {required BuildContext context,
        required Widget child,
        Color? barrierColor,
        Color? parentColor,
        bool? barrierDismissible,
        Function? onDismiss,
        EdgeInsets padding = const EdgeInsets.all(30.0),
        EdgeInsets contentMargin = const EdgeInsets.only(
          top: 15,
          left: 22,
          right: 22,
          bottom: 25,
        )}) async {
    return showGeneralDialog(
        pageBuilder: (context, animation1, animation2) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: FocusDetector(
                child: Padding(
                  padding: padding,
                  child: RoundContainer(
                    allRadius: 16,
                    color: parentColor ?? Colors.white,
                    child: Padding(
                      padding: contentMargin,
                      child: child,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        barrierColor: barrierColor ?? Colors.black.withOpacity(0.5),
        context: context,
        barrierLabel: (barrierDismissible ?? false) ? "" : null,
        transitionDuration: const Duration(milliseconds: 200),
        barrierDismissible: barrierDismissible ?? false,
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: widget,
            ),
          );
        }).then((value) {
      if (onDismiss != null) {
        onDismiss();
      }
    });
  }

  static Future<bool> showAlert(
      {required BuildContext context,
        String? title,
        required String message,
        String? okActionTitle,
        String? cancelTitle,
        TextStyle? titleStyle,
        TextStyle? messageStyle,
        bool? dismissWithBackPress,
        bool? barrierDismissible,
        bool? isRichText,
        String? image,
        Color primaryColor = AppColors.primaryBtnColor,
        bool allowShowSameMessageTogether = false}) async {
    if (!allowShowSameMessageTogether && _sameMessageIsShowing(message)) {
      return false;
    }
    List<Widget> actions = [];
    if (cancelTitle?.isNotEmpty ?? false) {
      final cancelWidget = Padding(
        padding: const EdgeInsets.all(10),
        child: RoundContainer(
          allRadius: 3,
          height: 44,
          borderColor: AppColors.greyE1,
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.3,
            child: TextButton(
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              child: AutoSizeText(cancelTitle!,
                  textAlign: TextAlign.center,
                  style: titleMedium.copyWith(
                      color: AppColors.textColorGray,
                      fontSize: 13,
                      fontWeight: FontWeight.w700)),
              onPressed: () {
                return Navigator.of(context).pop(false);
              },
            ),
          ),
        ),
      );
      actions.add(cancelWidget);
    }

    final okWidget = Padding(
      padding: const EdgeInsets.all(10),
      child: RoundContainer(
        allRadius: 3,
        height: 44,
        color: primaryColor,
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.3,
          child: TextButton(
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
            child: AutoSizeText(okActionTitle ?? "OK",
                textAlign: TextAlign.center,
                style: titleMedium.copyWith(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700)),
            onPressed: () {
              return Navigator.of(context).pop(true);
            },
          ),
        ),
      ),
    );
    actions.add(okWidget);
    AlertManager._onMessageShow(message);
    final result = await showGeneralDialog<bool>(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: widget,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 200),
        barrierDismissible: false,
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return FocusDetector(
            onFocusGained: () {
              alertShowingCount++;
            },
            onFocusLost: () {
              alertShowingCount--;
              AlertManager._onMessageHide(message);
            },
            child: WillPopScope(
              onWillPop: () async {
                return dismissWithBackPress ?? true;
              },
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: RoundContainer(
                          allRadius: 10,
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: (image != null) ? 30 : 0,
                              ),
                              Visibility(
                                visible: image != null,
                                child: SvgPicture.asset(image ?? ''),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 22.0),
                                child: Text(
                                  title ?? '',
                                  textAlign: TextAlign.center,
                                  style: titleStyle ??
                                      titleMedium.copyWith(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 22.0),
                                child: isRichText == true
                                    ? RichText(
                                    text: TextSpan(
                                        style: messageStyle ??
                                            titleMedium.copyWith(
                                              height: 1.4,
                                              fontSize: 14,
                                              color:
                                              AppColors.textColorGray,
                                            ),
                                        children: [
                                          const TextSpan(
                                            text:
                                            'Để GongU365 có thể xác nhận đơn hàng nhanh và chính xác nhất. Khi chuyển khoản khách hàng vui lòng đổi tên',
                                          ),
                                          TextSpan(
                                              text: ' NGƯỜI CHUYỂN KHOẢN ',
                                              style: titleStyle ??
                                                  titleMedium.copyWith(
                                                    fontSize: 18,
                                                    fontWeight:
                                                    FontWeight.w700,
                                                    color: Colors.black,
                                                  )),
                                          const TextSpan(
                                            text: 'thành ',
                                          ),
                                          TextSpan(
                                              text: 'MÃ ĐƠN HÀNG.',
                                              style: titleStyle ??
                                                  titleMedium.copyWith(
                                                    fontSize: 18,
                                                    fontWeight:
                                                    FontWeight.w700,
                                                    color: Colors.black,
                                                  )),
                                        ]))
                                    : Text(message,
                                    textAlign: TextAlign.center,
                                    style: messageStyle ??
                                        titleMedium.copyWith(
                                          height: 1.4,
                                          fontSize: 14,
                                          color: AppColors.textColorGray,
                                        )),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: actions,
                              ),
                              const SizedBox(
                                height: 20,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
    return result ?? false;
  }
}
