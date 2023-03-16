import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:ticketing/auth/bloc/signup/signup_cubit.dart';
import 'package:ticketing/auth/repo/auth_repo.dart';
import 'package:ticketing/auth/ui/sign_in_page.dart';
import 'package:ticketing/utils.dart';

class SignUpPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => SignUpPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => SignupCubit(
          context.read<AuthenticationRepository>(),
        ),
        child: SignUpForm(),
      ),
    );
  }
}

class SignUpForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupCubit, SignupState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(const SnackBar(content: Text('Sign Up Failure')));
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
                  _DisplayNameInput(),
                  const SizedBox(height: 8.0),
                  _EmailInput(),
                  const SizedBox(height: 8.0),
                  _PasswordInput(),
                  const SizedBox(height: 8.0),
                  _ConfirmPasswordInput(),
                  const SizedBox(height: 8.0),
                  _PhoneNumberInput(),
                  const SizedBox(height: 8.0),
                  _SignUpButton(),
                  const SizedBox(height: 8.0),
                  const SizedBox(height: 4.0),
                  _SignInButton(),
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
          $t(context, 'placeholder.sign_up'),
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

class _DisplayNameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
        buildWhen: (previous, current) =>
            previous.displayName != current.displayName,
        builder: (context, state) {
          return TextField(
              key: const Key('signUpForm_displayNameInput_textField'),
              onChanged: (displayName) =>
                  context.read<SignupCubit>().displayNameChanged(displayName),
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: $t(context, 'placeholder.display_name'),
                labelStyle: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold),
                helperText: '',
                border: OutlineInputBorder(),
                errorText: state.displayName.invalid ? 'Invalid name' : null,
              ));
        });
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
        buildWhen: (previous, current) => previous.email != current.email,
        builder: (context, state) {
          return TextField(
              key: const Key('signUpForm_emailInput_textField'),
              onChanged: (email) =>
                  context.read<SignupCubit>().emailChanged(email),
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
    return BlocBuilder<SignupCubit, SignupState>(
        buildWhen: (previous, current) =>
            previous.password != current.password ||
            previous.passwordConfirmation != current.passwordConfirmation,
        builder: (context, state) {
          return TextField(
              key: const Key('signUpForm_passwordInput_textField'),
              onChanged: (password) => {
                    context.read<SignupCubit>().passwordConfirmationChanged(
                        state.passwordConfirmation.value.item2),
                    context.read<SignupCubit>().passwordChanged(password)
                  },
              obscureText: true,
              decoration: InputDecoration(
                labelText: $t(context, 'placeholder.password'),
                labelStyle: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
                helperText: '',
                border: OutlineInputBorder(),
                errorText: state.password.invalid ? 'Invalid password' : null,
              ));
        });
  }
}

class _ConfirmPasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
        buildWhen: (previous, current) =>
            previous.passwordConfirmation != current.passwordConfirmation ||
            previous.password != current.password,
        builder: (context, state) {
          return TextField(
              key: const Key('signUpForm_passwordInput_textField'),
              onChanged: (passwordConfirmation) => {
                    context
                        .read<SignupCubit>()
                        .passwordConfirmationChanged(passwordConfirmation),
                    context
                        .read<SignupCubit>()
                        .passwordChanged(state.password.value)
                  },
              obscureText: true,
              decoration: InputDecoration(
                labelText: $t(context, 'placeholder.confirm_password'),
                labelStyle: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold),
                helperText: '',
                border: OutlineInputBorder(),
                errorText: state.passwordConfirmation.invalid
                    ? 'Passwords do not match'
                    : null,
              ));
        });
  }
}

class _PhoneNumberInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
        buildWhen: (previous, current) =>
            previous.phoneNumber != current.phoneNumber,
        builder: (context, state) {
          return TextField(
              key: const Key('signUpForm_phoneNumberInput_textField'),
              onChanged: (phoneNumber) =>
                  context.read<SignupCubit>().phoneNumberChanged(phoneNumber),
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: $t(context, 'placeholder.phone_number'),
                labelStyle: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold),
                helperText: '',
                border: OutlineInputBorder(),
                errorText: state.phoneNumber.invalid
                    ? 'Enter valid phone number'
                    : null,
              ));
        });
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
              child: ElevatedButton(
                  key: const Key('signUpForm_continue_raisedButton'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    primary: Colors.blue,
                  ),
                  child: Text($t(context, 'placeholder.sign_up'),
                      style: TextStyle(color: Colors.white)),
                  
                  
                  // disabledColor: Colors.blueGrey,
                  onPressed: state.status.isValidated
                      ? () => context.read<SignupCubit>().signUpFormSubmitted()
                      : null,
                ),
            );
      },
    );
  }
}

class _SignInButton extends StatelessWidget {
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
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(children: <TextSpan>[
          TextSpan(
            text: $t(context, 'placeholder.not_new'),
            style: TextStyle(
              color: Colors.black87,
            ),
          ),
          TextSpan(
              text: $t(context, 'placeholder.login'),
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.of(context)
                      .pushAndRemoveUntil(SignInPage.route(), (route) => false);
                }),
        ]),
      ),
    );
  }
}
