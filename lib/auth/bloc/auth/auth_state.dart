part of './auth_bloc.dart';

enum AuthStatus { authenticated, unauthenticated, unknown, emailNotVerified }

class AuthState extends Equatable {
  const AuthState._({this.status = AuthStatus.unknown, this.user = local.User.empty});

  const AuthState.unknown() : this._();

  const AuthState.authenticated(local.User user)
      : this._(status: AuthStatus.authenticated, user: user);

  const AuthState.emailNotVerified(local.User user)
      : this._(status: AuthStatus.emailNotVerified, user: user);

  const AuthState.updatedUser(local.User user)
      : this._(status: AuthStatus.authenticated, user: user);

  const AuthState.unauthenticated()
      : this._(status: AuthStatus.unauthenticated);

  final AuthStatus status;
  final local.User user;

  @override
  List<Object> get props => [status, user];
}
