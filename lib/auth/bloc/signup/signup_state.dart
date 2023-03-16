part of 'signup_cubit.dart';

class SignupState extends Equatable {
  const SignupState({
    this.displayName = const DisplayName.pure(),
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.passwordConfirmation = const PasswordConfirmation.pure(),
    this.phoneNumber = const PhoneNumber.pure(),
    this.status = FormzStatus.pure,
  });

  final DisplayName displayName;
  final Email email;
  final Password password;
  final PasswordConfirmation passwordConfirmation;
  final PhoneNumber phoneNumber;
  final FormzStatus status;

  @override
  List<Object> get props =>
      [displayName, email, password, passwordConfirmation, phoneNumber, status];

  SignupState copyWith(
      {DisplayName displayName,
      Email email,
      Password password,
      PasswordConfirmation passwordConfirmation,
      PhoneNumber phoneNumber,
      FormzStatus status}) {
    return SignupState(
        displayName: displayName ?? this.displayName,
        email: email ?? this.email,
        password: password ?? this.password,
        passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        status: status ?? this.status);
  }
}
