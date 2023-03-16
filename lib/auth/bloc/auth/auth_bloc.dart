import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:pedantic/pedantic.dart' show unawaited;
import 'package:ticketing/auth/repo/auth_repo.dart';
import 'package:ticketing/vo/user.dart' as local;

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({@required AuthenticationRepository authenticationRepository})
      : assert(authenticationRepository != null),
        _authenticationRepository = authenticationRepository,
        super(const AuthState.unknown()) {
    _userSubscription = _authenticationRepository.user.listen((user) {
      add(AuthUserChanged(user));
    });
    _updatedUserSubscription =
        _authenticationRepository.updatedUser.listen((user) {
      add(AuthUserUpdated(user));
    });
  }

  final AuthenticationRepository _authenticationRepository;
  StreamSubscription<local.User> _userSubscription;
  StreamSubscription<local.User> _updatedUserSubscription;

  @override
  Future<void> close() {
    _userSubscription.cancel();
    _updatedUserSubscription.cancel();
    return super.close();
  }

  AuthState _mapAuthUserChangedToState(AuthUserChanged event) {
    try {
      if (event.user != local.User.empty) {
        if (event?.user?.emailVerified ?? false) {
          print("Email Verified");
          return AuthState.authenticated(event.user);
        }
        print("Email not Verified");
        // FirebaseAuth.instance.currentUser.sendEmailVerification();
        return AuthState.emailNotVerified(event.user);
      }
    } catch (e) {
      throw e;
    }

    return const AuthState.unauthenticated();
  }

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is AuthUserChanged)
      yield _mapAuthUserChangedToState(event);
    else if (event is AuthLogoutRequested)
      unawaited(_authenticationRepository.logOut());
    else if (event is AuthUserUpdated) yield AuthState.updatedUser(event.user);
  }
}
