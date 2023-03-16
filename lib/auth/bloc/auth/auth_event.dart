part of './auth_bloc.dart';

@immutable
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthUserChanged extends AuthEvent {
  const AuthUserChanged(this.user);

  final local.User user;

  @override
  List<Object> get props => [user];
}

class AuthUserUpdated extends AuthEvent {
  const AuthUserUpdated(this.user);

  final local.User user;

  @override
  List<Object> get props => [user];
}

class AuthLogoutRequested extends AuthEvent {}
