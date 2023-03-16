import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketing/auth/bloc/auth/auth_bloc.dart';
import 'package:ticketing/auth/repo/auth_repo.dart';
import 'package:ticketing/auth/ui/sign_in_page.dart';
import 'package:ticketing/auth/ui/splash_page.dart';
import 'package:ticketing/cubit/language_cubit.dart';
import 'package:ticketing/events/repo/events_repo.dart';
import 'package:ticketing/events/ui/create/bloc/create_event_cubit.dart';
import 'package:ticketing/home/ui/home_page.dart';
import 'package:ticketing/simple_bloc_observer.dart';

void main() async {
  final GlobalKey<NavigatorState> _navigatorKey =
      new GlobalKey<NavigatorState>();
  // GoogleMap.init('AIzaSyB55b7VQXflfiPZuDMLSj6uInpapJgFVBY');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  EquatableConfig.stringify = kDebugMode;
  Bloc.observer = SimpleBlocObserver();
  final authRepo = AuthenticationRepository();
  final eventRepo = EventsRepo();
  AppLocale currentLang;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  currentLang =
      (prefs.getBool('isEnglish') ?? true ? AppLocale.en : AppLocale.am);
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authRepo),
        RepositoryProvider.value(value: eventRepo)
      ],
      // Global bloc providers
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => CreateEventCubit(
              eventRepo,
            ),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: _navigatorKey,
          theme: ThemeData(primarySwatch: Colors.blue),
          builder: (context, state) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (_) => AuthBloc(authenticationRepository: authRepo),
                ),
                BlocProvider(
                  create: (_) => LanguageCubit(currentLocale: currentLang),
                ),
              ],
              child: BlocListener<AuthBloc, AuthState>(
                listener: (context, state) {
                  switch (state.status) {
                    case AuthStatus.unauthenticated:
                      _navigatorKey.currentState.pushAndRemoveUntil(
                          SignInPage.route(), (route) => false);
                      break;
                    case AuthStatus.emailNotVerified:
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Please check your email! we\'ve sent instructions to to verify your account',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.orange[700],
                          elevation: 8.0,
                          behavior: SnackBarBehavior.floating,
                          // duration: Duration(days: 365),
                        ),
                      );
                      _navigatorKey.currentState.pushAndRemoveUntil(
                        HomePage.route(),
                        (route) => false,
                      );
                      break;
                    case AuthStatus.authenticated:
                      _navigatorKey.currentState.pushAndRemoveUntil(
                        HomePage.route(),
                        (route) => false,
                      );
                      break;
                    default:
                      break;
                  }
                  return Container();
                },
                child: state,
              ),
            );
          },
          onGenerateRoute: (_) => SplashPage.route(),
        ),
      ),
    ),
  );
}
