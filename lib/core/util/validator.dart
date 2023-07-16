import 'package:temple_adventures/core/constants/constants.dart';

class Validator {
  static String? validateName(String name) {
    // //print('validateName');
    if (name.isEmpty) return null;
    if (name.length > 15) return '15 characters only';
    return null;
  }

  static String? validateDiveNumber(String num) {
    if (num.isEmpty) return null;
    try {
      int.parse(num.trim());
    } catch (e) {
      return 'Invalid Input';
    }
    return null;
  }

  static String? validateNationality(String nationality) {
    if (nationality.isEmpty) return null;
    if (nationality.length > 30) return 'Limit Exceeded';
    return null;
  }

  static String? validateCountryCode(String code) {
    try {
      if (code.isEmpty) return null;
      if (code.length > 3) return 'Limit Exceeded';
      return null;
    } catch (e) {
      return 'Invalid Code';
    }
  }

  static String? validatePhoneNumber(String number) {
    try {
      if (number.isEmpty) return null;
      if(number.length < 10) return 'Invalid PhoneNumber';
      if (number.length > 10) return 'Limit exceeded';
      return null;
    } catch (e) {
      return 'Invalid Code';
    }
  }

  static String? validateCertificate(String value) {
    if (value.isEmpty) return null;
    if (value.length > 50) return '50 characters only';
    return null;
  }

  static String? validateEmail(String email) {
    if (email.isEmpty) return null;
    bool isEmailValid =
        RegularExpressions.emailRegularExpression.hasMatch(email);
    return isEmailValid ? null : 'Invalid email';
  }

  static String? validatePassword(String password) {
    if (password.isEmpty) return null;
    if (password.length < 8) return 'Should be more than 8';
    bool isPasswordValid =
        RegularExpressions.passwordRegularExpression.hasMatch(password);
    // //print(isPasswordValid);
    return isPasswordValid ? null : 'Missing uppercase / number';
  }

  static String? validatePinCode(String pinCode) {
    try {
      if (pinCode.isEmpty) return null;
      return null;
    } catch (e) {
      return 'Invalid PinCode';
    }
  }
}
