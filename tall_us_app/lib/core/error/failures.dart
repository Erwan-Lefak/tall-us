/// Base class for all failures in the app
abstract class Failure extends Equatable {
  const Failure([List properties = const <dynamic>[]]);

  @override
  List<Object?> get props => [];
}

/// Server failure
class ServerFailure extends Failure {
  final String message;
  final int? statusCode;

  const ServerFailure(this.message, {this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

/// Network failure
class NetworkFailure extends Failure {
  final String message;

  const NetworkFailure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Cache failure
class CacheFailure extends Failure {
  final String message;

  const CacheFailure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Authentication failure
class AuthFailure extends Failure {
  final String message;

  const AuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Validation failure
class ValidationFailure extends Failure {
  final String message;

  const ValidationFailure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Not found failure
class NotFoundFailure extends Failure {
  final String message;

  const NotFoundFailure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Permission failure
class PermissionFailure extends Failure {
  final String message;

  const PermissionFailure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Unknown failure
class UnknownFailure extends Failure {
  final String message;

  const UnknownFailure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Equatable base class
abstract class Equatable {
  const Equatable();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Equatable &&
        other.runtimeType == runtimeType &&
        listEquals(other.props, props);
  }

  @override
  int get hashCode => props.fold(0, (previousValue, element) {
        return previousValue ^ element.hashCode;
      });

  List<Object?> get props => [];

  bool listEquals(List? list1, List? list2) {
    if (list1 == null || list2 == null || list1.length != list2.length) {
      return false;
    }
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) {
        return false;
      }
    }
    return true;
  }
}
