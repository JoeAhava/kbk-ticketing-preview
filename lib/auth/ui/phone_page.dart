import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:ticketing/auth/bloc/verification/verification_bloc.dart';
import 'package:ticketing/auth/repo/auth_repo.dart';
import 'package:ticketing/home/ui/home_page.dart';
import 'package:formz/formz.dart';
import 'package:ticketing/utils.dart';

class PhonePage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => PhonePage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => VerificationBloc(
            authenticationRepository: context.read<AuthenticationRepository>()),
        child: PhoneForm(),
      ),
    );
  }
}

class PhoneForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<VerificationBloc, VerificationState>(
        listener: (context, state) {
          if (state.verificationStatus == VerificationStatus.codeVerified) {
            Navigator.of(context)
                .pushAndRemoveUntil<void>(HomePage.route(), (route) => false);
          }

          if (state.errorMessage.isNotEmpty) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.errorMessage)));

            // revert back to previous state once error has been shown
            context
                .read<VerificationBloc>()
                .add(VerificationCodeChanged(state.code.value));
          }
        },
        child: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.all(16.0),
              child: BlocBuilder<VerificationBloc, VerificationState>(
                builder: (context, state) {
                  return state.showingPhone()
                      ? _PhoneNumberForm()
                      : _VerifyCodeForm();
                },
              )),
        ));
  }
}

class _PhoneNumberForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VerificationBloc, VerificationState>(
      builder: (context, state) {
        return Container(
            padding: EdgeInsets.only(top: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text($t(context, 'placeholder.enter_phone'),
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                SizedBox(height: 15),
                _PhoneNumberInput(),
                SizedBox(height: 10),
                _SendPhoneCodeButton(),
              ],
            ));
      },
    );
  }
}

class _PhoneNumberInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VerificationBloc, VerificationState>(
      buildWhen: (previous, current) =>
          previous.phoneNumber != current.phoneNumber,
      builder: (context, state) {
        return TextField(
            key: const Key('phoneNumberForm_phoneInput_textField'),
            onChanged: (phoneNumber) => context
                .read<VerificationBloc>()
                .add(PhoneNumberChanged(phoneNumber)),
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: $t(context, 'placeholder.phone_lbl'),
              errorText:
                  state.phoneNumber.invalid ? 'Invalid phone number' : null,
              contentPadding: EdgeInsets.all(20),
              labelStyle: TextStyle(fontSize: 14, color: Colors.black54),
              border: OutlineInputBorder(),
            ));
      },
    );
  }
}

class _SendPhoneCodeButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VerificationBloc, VerificationState>(
      builder: (context, state) {
        final loading =
            state.verificationStatus == VerificationStatus.sendingCode;
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor,
                textStyle: TextStyle(
                  color: Colors.white,
                ),
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              ),
              icon: loading ? Icon(FontAwesomeIcons.ellipsisH) : Container(),
              onPressed: state.phoneNumberStatus.isValidated && !loading
                  ? () {
                      context.read<VerificationBloc>().add(
                          SendCodeEvent(phoneNumber: state.phoneNumber.value));
                    }
                  : null,
              label: Text(loading
                  ? $t(context, 'placeholder.verification_code_sending')
                  : $t(context, 'placeholder.verification_code'))),
        );
      },
    );
  }
}

class _VerifyCodeForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [_HeaderAndTitle(), _VerificationInput(), _VerifyButton()],
    );
  }
}

class _HeaderAndTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VerificationBloc, VerificationState>(
      builder: (context, state) {
        return Column(
          children: [
            Image.asset('assets/verification.png', width: 200),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text($t(context, 'account.verify_title'),
                    style: TextStyle(
                        fontSize: 28.0, fontWeight: FontWeight.bold))),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                    $t(context, 'account.verify_message') + '+1 - 000 000 000',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.black38)))
          ],
        );
      },
    );
  }
}

class _VerificationInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VerificationBloc, VerificationState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 32.0),
          child: Container(
            padding: EdgeInsets.fromLTRB(8.0, 24.0, 8.0, 8.0),
            child: PinCodeTextField(
              appContext: context,
              length: 6,
              obscureText: false,
              keyboardType: TextInputType.number,
              animationType: AnimationType.fade,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(5),
                fieldHeight: 50,
                fieldWidth: 40,
                borderWidth: 0,
                selectedFillColor: Colors.grey.withOpacity(0.2),
                inactiveFillColor: Colors.grey.withOpacity(0.2),
                activeFillColor: Colors.blue,
              ),
              textStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
              animationDuration: Duration(milliseconds: 300),
              backgroundColor: Colors.transparent,
              enableActiveFill: true,
              onChanged: (value) => {
                context
                    .read<VerificationBloc>()
                    .add(VerificationCodeChanged(value))
              },
              beforeTextPaste: (text) => false,
            ),
            decoration: BoxDecoration(
              color: Colors.transparent,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: Offset(0, 3))
              ],
            ),
          ),
        );
      },
    );
  }
}

class _VerifyButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VerificationBloc, VerificationState>(
      builder: (context, state) {
        final loading =
            state.verificationStatus == VerificationStatus.verifyingCode;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 38.0, vertical: 12.0),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              textStyle: TextStyle(
                color: Colors.white,
              ),
              shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            ),
            icon: loading
                ? Icon(FontAwesomeIcons.ellipsisH)
                : Icon(FontAwesomeIcons.infinity),
            label: Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(loading ? '' : $t(context, 'account.verify'),
                    style: TextStyle(fontSize: 16.0))),
            onPressed: state.codeStatus.isValidated && !loading
                ? () => context.read<VerificationBloc>().add(
                      VerifyCodeEvent(
                        code: state.code.value,
                      ),
                    )
                : null,
          ),
        );
      },
    );
  }
}
