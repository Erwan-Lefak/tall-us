import 'package:flutter/material.dart';

/// Base class for all failures in the app
///
/// All failures should extend this class
abstract class Failure {
  final String message;
  final String code;
  final int? statusCode;

  const Failure({
    required this.message,
    required this.code,
    this.statusCode,
  });

  @override
  String toString() => 'Failure: $message ($code)';
}

/// Server failure - Error from server/API
class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    required super.code,
    super.statusCode,
  });

  factory ServerFailure.fromResponse(int statusCode, String body) {
    return ServerFailure(
      message: _getMessageFromStatus(statusCode, body),
      code: _getCodeFromStatus(statusCode),
      statusCode: statusCode,
    );
  }

  static String _getMessageFromStatus(int statusCode, String body) {
    switch (statusCode) {
      case 400:
        return 'Invalid request. Please check your input.';
      case 401:
        return 'Authentication failed. Please log in again.';
      case 403:
        return 'You don\'t have permission to perform this action.';
      case 404:
        return 'The requested resource was not found.';
      case 409:
        return 'This resource already exists.';
      case 429:
        return 'Too many requests. Please try again later.';
      case 500:
        return 'Server error. Please try again later.';
      case 503:
        return 'Service unavailable. Please try again later.';
      default:
        return body.isNotEmpty ? body : 'An unexpected error occurred.';
    }
  }

  static String _getCodeFromStatus(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'BAD_REQUEST';
      case 401:
        return 'UNAUTHORIZED';
      case 403:
        return 'FORBIDDEN';
      case 404:
        return 'NOT_FOUND';
      case 409:
        return 'CONFLICT';
      case 429:
        return 'RATE_LIMIT_EXCEEDED';
      case 500:
        return 'INTERNAL_SERVER_ERROR';
      case 503:
        return 'SERVICE_UNAVAILABLE';
      default:
        return 'UNKNOWN_ERROR';
    }
  }
}

/// Network failure - No internet connection
class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'No internet connection. Please check your network.',
    super.code = 'NETWORK_ERROR',
  });
}

/// Cache failure - Error reading/writing to local cache
class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Failed to access local storage.',
    super.code = 'CACHE_ERROR',
  });
}

/// Validation failure - Invalid input data
class ValidationFailure extends Failure {
  final Map<String, String>? fieldErrors;

  const ValidationFailure({
    super.message = 'Validation failed. Please check your input.',
    super.code = 'VALIDATION_ERROR',
    this.fieldErrors,
  });
}

/// Authentication failure - Login/register failed
class AuthFailure extends Failure {
  const AuthFailure({
    required super.message,
    super.code = 'AUTH_ERROR',
  });

  factory AuthFailure.wrongCredentials() {
    return const AuthFailure(
      message: 'Invalid email or password.',
      code: 'WRONG_CREDENTIALS',
    );
  }

  factory AuthFailure.emailNotVerified() {
    return const AuthFailure(
      message: 'Please verify your email address.',
      code: 'EMAIL_NOT_VERIFIED',
    );
  }

  factory AuthFailure.userNotFound() {
    return const AuthFailure(
      message: 'User not found.',
      code: 'USER_NOT_FOUND',
    );
  }

  factory AuthFailure.emailAlreadyExists() {
    return const AuthFailure(
      message: 'An account with this email already exists.',
      code: 'EMAIL_ALREADY_EXISTS',
    );
  }

  factory AuthFailure.sessionExpired() {
    return const AuthFailure(
      message: 'Your session has expired. Please log in again.',
      code: 'SESSION_EXPIRED',
    );
  }

  factory AuthFailure.invalidToken() {
    return const AuthFailure(
      message: 'Invalid authentication token.',
      code: 'INVALID_TOKEN',
    );
  }

  factory AuthFailure.passwordTooWeak() {
    return const AuthFailure(
      message:
          'Password is too weak. Use at least 8 characters with uppercase, lowercase, number and special character.',
      code: 'PASSWORD_TOO_WEAK',
    );
  }
}

/// Permission failure - Missing permissions
class PermissionFailure extends Failure {
  const PermissionFailure({
    required super.message,
    super.code = 'PERMISSION_DENIED',
  });

  factory PermissionFailure.camera() {
    return const PermissionFailure(
      message: 'Camera permission is required to take photos.',
      code: 'CAMERA_PERMISSION_DENIED',
    );
  }

  factory PermissionFailure.photos() {
    return const PermissionFailure(
      message: 'Photo library permission is required to select photos.',
      code: 'PHOTOS_PERMISSION_DENIED',
    );
  }

  factory PermissionFailure.location() {
    return const PermissionFailure(
      message: 'Location permission is required to find nearby matches.',
      code: 'LOCATION_PERMISSION_DENIED',
    );
  }

  factory PermissionFailure.notifications() {
    return const PermissionFailure(
      message: 'Notification permission is required to receive match alerts.',
      code: 'NOTIFICATIONS_PERMISSION_DENIED',
    );
  }
}

/// Payment failure - Stripe payment error
class PaymentFailure extends Failure {
  const PaymentFailure({
    required super.message,
    super.code = 'PAYMENT_ERROR',
  });

  factory PaymentFailure.cardDeclined() {
    return const PaymentFailure(
      message: 'Your card was declined. Please try another payment method.',
      code: 'CARD_DECLINED',
    );
  }

  factory PaymentFailure.insufficientFunds() {
    return const PaymentFailure(
      message: 'Insufficient funds. Please try another payment method.',
      code: 'INSUFFICIENT_FUNDS',
    );
  }

  factory PaymentFailure.paymentCanceled() {
    return const PaymentFailure(
      message: 'Payment was canceled.',
      code: 'PAYMENT_CANCELED',
    );
  }
}

/// Unknown failure - Catch-all for unexpected errors
class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'An unexpected error occurred.',
    super.code = 'UNKNOWN_ERROR',
  });
}

/// Extension to get user-friendly error message
extension FailureX on Failure {
  String getUserMessage() {
    return when(
      server: (message) => message,
      network: (message) => message,
      cache: (message) => message,
      validation: (message) => message,
      auth: (message) => message,
      permission: (message) => message,
      payment: (message) => message,
      unknown: (message) => message,
    );
  }

  String? getErrorMessageForField(String fieldName) {
    if (this is ValidationFailure) {
      final fieldErrors = (this as ValidationFailure).fieldErrors;
      return fieldErrors?[fieldName];
    }
    return null;
  }

  T when<T>({
    required T Function(String message) server,
    required T Function(String message) network,
    required T Function(String message) cache,
    required T Function(String message) validation,
    required T Function(String message) auth,
    required T Function(String message) permission,
    required T Function(String message) payment,
    required T Function(String message) unknown,
  }) {
    if (this is ServerFailure) {
      return server(message);
    } else if (this is NetworkFailure) {
      return network(message);
    } else if (this is CacheFailure) {
      return cache(message);
    } else if (this is ValidationFailure) {
      return validation(message);
    } else if (this is AuthFailure) {
      return auth(message);
    } else if (this is PermissionFailure) {
      return permission(message);
    } else if (this is PaymentFailure) {
      return payment(message);
    } else {
      return unknown(message);
    }
  }
}

/// Extension to show snackbar from failure
extension FailureSnackbar on Failure {
  void showSnackBar(BuildContext context) {
    final message = getUserMessage();
    final color = when(
      server: (_) => Colors.red,
      network: (_) => Colors.orange,
      cache: (_) => Colors.brown,
      validation: (_) => Colors.amber,
      auth: (_) => Colors.red,
      permission: (_) => Colors.purple,
      payment: (_) => Colors.red,
      unknown: (_) => Colors.grey,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
