import 'package:dartz/dartz.dart';
import 'package:tall_us/core/constants/app_constants.dart';
import 'package:tall_us/core/errors/failures.dart';
import 'package:tall_us/features/auth/domain/entities/user_entity.dart';
import 'package:tall_us/features/auth/domain/repositories/auth_repository.dart';

/// Register Use Case
///
/// Business logic for user registration
class RegisterUseCase {
  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  /// Execute registration with all required fields
  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
    required String displayName,
    required String gender,
    required int height,
    required DateTime birthday,
    required String countryCode,
    required String city,
  }) async {
    // Validate email
    if (!_isValidEmail(email)) {
      return Left(ValidationFailure(
        message: 'Invalid email format',
        code: 'INVALID_EMAIL',
      ));
    }

    // Validate password strength
    final passwordValidation = _validatePassword(password);
    if (passwordValidation != null) {
      return Left(passwordValidation);
    }

    // Validate display name
    if (displayName.trim().isEmpty) {
      return Left(ValidationFailure(
        message: 'Display name is required',
        code: 'DISPLAY_NAME_REQUIRED',
      ));
    }

    if (displayName.length < 2 || displayName.length > 50) {
      return Left(ValidationFailure(
        message: 'Display name must be between 2 and 50 characters',
        code: 'INVALID_DISPLAY_NAME_LENGTH',
      ));
    }

    // Validate gender
    if (!['male', 'female', 'other'].contains(gender.toLowerCase())) {
      return Left(ValidationFailure(
        message: 'Invalid gender value',
        code: 'INVALID_GENDER',
      ));
    }

    // Validate height requirements
    final minHeight = gender.toLowerCase() == 'male'
        ? AppConstants.minHeightMale
        : AppConstants.minHeightFemale;

    if (height < minHeight) {
      return Left(ValidationFailure(
        message: 'Minimum height for ${gender.toLowerCase()} is $minHeight cm',
        code: 'HEIGHT_TOO_SHORT',
      ));
    }

    if (height > 250) {
      return Left(ValidationFailure(
        message: 'Height must be less than 250 cm',
        code: 'HEIGHT_TOO_TALL',
      ));
    }

    // Validate birthday (must be 18+)
    final age = _calculateAge(birthday);
    if (age < 18) {
      return Left(ValidationFailure(
        message: 'You must be at least 18 years old',
        code: 'UNDERAGE',
      ));
    }

    if (age > 120) {
      return Left(ValidationFailure(
        message: 'Invalid birth date',
        code: 'INVALID_BIRTH_DATE',
      ));
    }

    // Validate country code
    if (countryCode.length != 2) {
      return Left(ValidationFailure(
        message: 'Invalid country code',
        code: 'INVALID_COUNTRY_CODE',
      ));
    }

    // Validate city
    if (city.trim().isEmpty || city.length > 100) {
      return Left(ValidationFailure(
        message: 'City must be between 1 and 100 characters',
        code: 'INVALID_CITY',
      ));
    }

    // Call repository
    return await _repository.register(
      email: email,
      password: password,
      displayName: displayName,
      gender: gender.toLowerCase(),
      height: height,
      birthday: birthday,
      countryCode: countryCode.toUpperCase(),
      city: city,
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  ValidationFailure? _validatePassword(String password) {
    if (password.length < 8) {
      return ValidationFailure(
        message: 'Password must be at least 8 characters',
        code: 'PASSWORD_TOO_SHORT',
      );
    }

    if (password.length > 100) {
      return ValidationFailure(
        message: 'Password must be less than 100 characters',
        code: 'PASSWORD_TOO_LONG',
      );
    }

    // Check for at least one uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return ValidationFailure(
        message: 'Password must contain at least one uppercase letter',
        code: 'PASSWORD_NO_UPPERCASE',
      );
    }

    // Check for at least one lowercase letter
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return ValidationFailure(
        message: 'Password must contain at least one lowercase letter',
        code: 'PASSWORD_NO_LOWERCASE',
      );
    }

    // Check for at least one number
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return ValidationFailure(
        message: 'Password must contain at least one number',
        code: 'PASSWORD_NO_NUMBER',
      );
    }

    return null;
  }

  int _calculateAge(DateTime birthDate) {
    final today = DateTime.now();
    int age = today.year - birthDate.year;

    // Adjust if birthday hasn't occurred yet this year
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }

    return age;
  }
}
