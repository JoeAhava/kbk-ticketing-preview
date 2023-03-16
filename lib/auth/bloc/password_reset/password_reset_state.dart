part of 'password_reset_cubit.dart';

class PasswordResetState extends Equatable {
  const PasswordResetState({
    this.status = ResetStatus.none,
  });

  final ResetStatus status;

  @override
  List<Object> get props => [ status];

  PasswordResetState copyWith({Email email, ResetStatus status}) {
    return PasswordResetState(
        status: status ?? this.status);
  }
}
