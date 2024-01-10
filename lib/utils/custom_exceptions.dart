enum AuthStatus {
  successful,
  wrongPassword,
  emailAlreadyExists,
  invalidEmail,
  weakPassword,
  unknown,
}

class AuthExceptionHandler {
  static String generateErrorMessage(error) {
    String errorMessage;
    switch (error) {
      case AuthStatus.invalidEmail:
        errorMessage = 'Your email address appears to be malformed.';
      case AuthStatus.weakPassword:
        errorMessage = 'Your password should be at least 6 characters.';
      case AuthStatus.wrongPassword:
        errorMessage = 'Your email or password is wrong.';
      case AuthStatus.emailAlreadyExists:
        errorMessage =
            'The email address is already in use by another account.';
      default:
        errorMessage = 'An error occured. Please try again later.';
    }
    return errorMessage;
  }
}
