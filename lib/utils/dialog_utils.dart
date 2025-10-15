import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

/// Dialog utility class to simplify QuickAlert usage and provide
/// common dialog patterns used throughout the PosX application.
/// 
/// This utility class replaces AwesomeDialog patterns with QuickAlert
/// equivalents, maintaining the same visual consistency while fixing
/// Windows build issues caused by rive dependencies.
class DialogUtils {
  DialogUtils._(); // Private constructor to prevent instantiation

  /// Shows a success dialog with green checkmark icon
  /// 
  /// Used for: Successful operations, confirmations, completed actions
  static Future<void> showSuccess({
    required BuildContext context,
    required String title,
    String? message,
    String confirmText = 'OK',
    VoidCallback? onConfirm,
    double? width,
    bool barrierDismissible = true,
  }) async {
    await QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      title: title,
      text: message,
      confirmBtnText: confirmText,
      confirmBtnColor: const Color(0xFF006A35), // PosX green color
      onConfirmBtnTap: onConfirm,
      width: width,
      barrierDismissible: barrierDismissible,
    );
  }

  /// Shows an error dialog with red X icon
  /// 
  /// Used for: Login failures, validation errors, operation failures
  static Future<void> showError({
    required BuildContext context,
    required String title,
    String? message,
    String confirmText = 'OK',
    VoidCallback? onConfirm,
    double? width,
    bool barrierDismissible = true,
  }) async {
    await QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: title,
      text: message,
      confirmBtnText: confirmText,
      confirmBtnColor: const Color(0xFFD32F2F), // Error red color
      onConfirmBtnTap: onConfirm,
      width: width,
      barrierDismissible: barrierDismissible,
    );
  }

  /// Shows a warning dialog with yellow triangle icon
  /// 
  /// Used for: Confirmations, limits exceeded, important notices
  static Future<void> showWarning({
    required BuildContext context,
    required String title,
    String? message,
    String confirmText = 'OK',
    VoidCallback? onConfirm,
    double? width,
    bool barrierDismissible = true,
  }) async {
    await QuickAlert.show(
      context: context,
      type: QuickAlertType.warning,
      title: title,
      text: message,
      confirmBtnText: confirmText,
      confirmBtnColor: const Color(0xFF006A35), // PosX green color
      onConfirmBtnTap: onConfirm,
      width: width,
      barrierDismissible: barrierDismissible,
    );
  }

  /// Shows an info dialog with blue info icon
  /// 
  /// Used for: Information messages, tips, general notifications
  static Future<void> showInfo({
    required BuildContext context,
    required String title,
    String? message,
    String confirmText = 'OK',
    VoidCallback? onConfirm,
    double? width,
    bool barrierDismissible = true,
  }) async {
    await QuickAlert.show(
      context: context,
      type: QuickAlertType.info,
      title: title,
      text: message,
      confirmBtnText: confirmText,
      confirmBtnColor: const Color(0xFF006A35), // PosX green color
      onConfirmBtnTap: onConfirm,
      width: width,
      barrierDismissible: barrierDismissible,
    );
  }

  /// Shows a confirmation dialog with Yes/No buttons
  /// 
  /// Used for: User confirmations, delete actions, important decisions
  static Future<void> showConfirm({
    required BuildContext context,
    required String title,
    String? message,
    String confirmText = 'Yes',
    String cancelText = 'No',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    double? width,
    bool barrierDismissible = true,
  }) async {
    await QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      title: title,
      text: message,
      confirmBtnText: confirmText,
      cancelBtnText: cancelText,
      confirmBtnColor: const Color(0xFF006A35), // PosX green color
      onConfirmBtnTap: onConfirm,
      onCancelBtnTap: onCancel,
      width: width,
      barrierDismissible: barrierDismissible,
    );
  }

  /// Shows a loading dialog with spinner
  /// 
  /// Used for: API calls, processing operations, waiting states
  static Future<void> showLoading({
    required BuildContext context,
    String title = 'Please wait...',
    String? message,
    double? width,
    bool barrierDismissible = false,
  }) async {
    await QuickAlert.show(
      context: context,
      type: QuickAlertType.loading,
      title: title,
      text: message,
      width: width ?? 600,
      barrierDismissible: barrierDismissible,
      disableBackBtn: true, // Prevent back button dismissal during loading
    );
  }

  /// Shows a custom dialog with user-defined widget content
  /// 
  /// Used for: Complex forms, custom layouts, specialized UI
  static Future<void> showCustom({
    required BuildContext context,
    required Widget widget,
    String? title,
    String confirmText = 'OK',
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    double? width,
    bool barrierDismissible = true,
  }) async {
    await QuickAlert.show(
      context: context,
      type: QuickAlertType.custom,
      title: title,
      widget: widget,
      confirmBtnText: confirmText,
      cancelBtnText: cancelText ?? 'Cancel',
      confirmBtnColor: const Color(0xFF006A35), // PosX green color
      onConfirmBtnTap: onConfirm,
      onCancelBtnTap: onCancel,
      showCancelBtn: cancelText != null,
      width: width,
      barrierDismissible: barrierDismissible,
    );
  }

  /// Convenience method for discount validation errors
  /// 
  /// Common pattern in PosX for discount-related validation messages
  static Future<void> showDiscountError({
    required BuildContext context,
    required String message,
    double? width,
  }) async {
    await showError(
      context: context,
      title: 'Discount Error',
      message: message,
      width: width ?? MediaQuery.of(context).size.width * 0.4,
    );
  }

  /// Convenience method for loyalty points validation
  /// 
  /// Common pattern in PosX for loyalty points validation
  static Future<void> showLoyaltyPointsError({
    required BuildContext context,
    required String message,
    double? width,
  }) async {
    await showWarning(
      context: context,
      title: 'Loyalty Points Exceeded',
      message: message,
      width: width ?? MediaQuery.of(context).size.width * 0.4,
    );
  }

  /// Convenience method for login-related dialogs
  /// 
  /// Used specifically for authentication flows
  static Future<void> showLoginError({
    required BuildContext context,
    required String message,
  }) async {
    await showError(
      context: context,
      title: 'Login Failed',
      message: message,
      width: 600,
    );
  }

  /// Shows a loading dialog specifically for login process
  /// 
  /// Non-dismissible loading state during authentication
  static Future<void> showLoginLoading({
    required BuildContext context,
  }) async {
    await showLoading(
      context: context,
      title: 'Please wait...',
      message: 'Authenticating user credentials',
      width: 600,
      barrierDismissible: false,
    );
  }
}

/// Extension methods for easy dialog access from any widget
extension DialogExtensions on BuildContext {
  /// Quick access to success dialog
  Future<void> showSuccessDialog(String title, {String? message}) {
    return DialogUtils.showSuccess(
      context: this,
      title: title,
      message: message,
    );
  }

  /// Quick access to error dialog
  Future<void> showErrorDialog(String title, {String? message}) {
    return DialogUtils.showError(
      context: this,
      title: title,
      message: message,
    );
  }

  /// Quick access to warning dialog
  Future<void> showWarningDialog(String title, {String? message}) {
    return DialogUtils.showWarning(
      context: this,
      title: title,
      message: message,
    );
  }

  /// Quick access to info dialog
  Future<void> showInfoDialog(String title, {String? message}) {
    return DialogUtils.showInfo(
      context: this,
      title: title,
      message: message,
    );
  }
}