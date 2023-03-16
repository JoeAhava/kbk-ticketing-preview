import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:formz/formz.dart';
import 'package:ticketing/auth/bloc/auth/auth_bloc.dart';
import 'package:ticketing/auth/bloc/login/login_cubit.dart';
import 'package:ticketing/auth/bloc/password_reset/password_reset_cubit.dart';
import 'package:ticketing/auth/repo/auth_repo.dart';
import 'package:ticketing/auth/ui/phone_page.dart';
import 'package:ticketing/auth/ui/sign_up_page.dart';
import 'package:ticketing/utils.dart';

class SignInPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => SignInPage());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => AuthBloc(
                authenticationRepository:
                    context.watch<AuthenticationRepository>())),
        BlocProvider(
          create: (_) => LoginCubit(context.read<AuthenticationRepository>()),
        )
      ],
      child: Scaffold(
        body: LoginForm(),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
                const SnackBar(content: Text('Sign in Failed! Perhaps wrong email or password !'), backgroundColor: Colors.red,));
        }
      },
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/club.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32.0),
                    topRight: Radius.circular(32.0)),
              ),
              padding: EdgeInsets.only(top: 32.0, left: 32.0, right: 32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _TitleView(),
                  const SizedBox(height: 32.0),
                  _EmailInput(),
                  const SizedBox(height: 8.0),
                  _PasswordInput(),
                  _ForgotPasswordLink(),
                  const SizedBox(height: 8.0),
                  _LoginButton(),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _GoogleLoginButton(),
                      _FacebookLoginButton(),
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  _SignUpButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TitleView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          $t(context, 'placeholder.login'),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          $t(context, 'placeholder.skip'),
          style: TextStyle(
            fontSize: 14,
            color: Colors.black26,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
        buildWhen: (previous, current) => previous.email != current.email,
        builder: (context, state) {
          return TextField(
              key: const Key('loginForm_emailInput_textField'),
              onChanged: (email) =>
                  context.read<LoginCubit>().emailChanged(email),
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: $t(context, 'placeholder.email'),
                labelStyle: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold),
                helperText: '',
                border: OutlineInputBorder(),
                errorText: state.email.invalid ? 'Invalid email' : null,
              ));
        });
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
        buildWhen: (previous, current) => previous.password != current.password,
        builder: (context, state) {
          return TextField(
              key: const Key('loginForm_passwordInput_textField'),
              onChanged: (password) =>
                  context.read<LoginCubit>().passwordChanged(password),
              obscureText: true,
              decoration: InputDecoration(
                labelText: $t(context, 'placeholder.password'),
                labelStyle: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold),
                helperText: '',
                border: OutlineInputBorder(),
                errorText: state.password.invalid ? 'Invalid password' : null,
              ));
        });
  }
}

class _ForgotPasswordLink extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state){
        if(state.email.invalid){
          return Container();
        }
        return BlocProvider(
          create: (_) => PasswordResetCubit(AuthenticationRepository()),
          child: BlocBuilder<PasswordResetCubit,PasswordResetState>(
            buildWhen: (prev, next) => prev.status != next.status,
            builder: (context, s){
              return InkWell(
                onTap: (){
                  context.read<PasswordResetCubit>().passwordReset(state.email.value);
                  s.status == ResetStatus.sent ? 
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: RichText(text: TextSpan(children: [
                        TextSpan(text: 'Check your email ! ',style: TextStyle(fontWeight: FontWeight.w900)),
                        TextSpan(text: '\nA password reset link has been sent to your email. '),
                      ]),maxLines: 2, overflow: TextOverflow.ellipsis,),
                      backgroundColor: Colors.green,
                    ),
                  ) : 
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: RichText(text: TextSpan(children: [
                        TextSpan(text: 'Email sending failed ! ',style: TextStyle(fontWeight: FontWeight.w900)),
                        TextSpan(text: '\nSomething went wrong try again later. '),
                      ]),maxLines: 2, overflow: TextOverflow.ellipsis,),
                      backgroundColor: Colors.red,
                    ),
                  );
                },
                child: Text(
                  $t(context, 'placeholder.forgot_password'),
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
                child: ElevatedButton(
                  key: const Key('loginForm_continue_raisedButton'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    primary: Colors.blue,
                  ),
                  child: Text($t(context, 'placeholder.login'),
                      style: TextStyle(color: Colors.white)),

                  // disabledColor: Colors.blueGrey,
                  onPressed: state.status.isValidated
                      ? () => context.read<LoginCubit>().loginWithCredentials()
                      : null,
                ));
      },
    );
  }
}

class _GoogleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () => context.read<LoginCubit>().loginWithGoogle(),
      icon: const Icon(FontAwesomeIcons.googlePlusG, color: Colors.redAccent),
      style: TextButton.styleFrom(
        backgroundColor: Colors.transparent,
      ),
      label: const Text(''),
    );
  }
}

class _FacebookLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () => context.read<LoginCubit>().loginWithGoogle(),
      icon: const Icon(FontAwesomeIcons.facebookF, color: Colors.blueAccent),
      style: TextButton.styleFrom(primary: Colors.transparent),
      label: const Text(''),
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5.0),
          topRight: Radius.circular(5.0),
        ),
      ),
      child: Column(
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: <TextSpan>[
              TextSpan(
                text: $t(context, 'placeholder.new'),
                style: TextStyle(
                  color: Colors.black87,
                ),
              ),
              TextSpan(
                  text: $t(context, 'placeholder.sign_up'),
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.of(context).push<void>(SignUpPage.route());
                    }),
              TextSpan(
                  text: $t(context, 'placeholder.or'),
                  style: TextStyle(color: Colors.black87)),
              TextSpan(
                  text: $t(context, 'placeholder.phone'),
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.of(context).push<void>(PhonePage.route());
                    })
            ]),
          )
        ],
      ),
    );
  }
}
