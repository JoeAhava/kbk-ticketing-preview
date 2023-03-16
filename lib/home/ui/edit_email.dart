import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing/auth/repo/auth_repo.dart';
import 'package:ticketing/home/bloc/edit_email/edit_email_cubit.dart';
import 'package:ticketing/home/bloc/edit_email/edit_email_state.dart';
import 'package:ticketing/home/services/Validator.dart';

class EditEmail extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => EditEmail(),
    );
  }

  @override
  _EditEmailState createState() => _EditEmailState();
}

class _EditEmailState extends State<EditEmail> {
  TextEditingController emailController;

  @override
  void initState() {
    emailController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Edit Email Address"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [Color(0xFF4fabf6), Color(0XFF6dc2e7)],
          )),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.vertical -
                AppBar().preferredSize.height,
            // To get the usable screen height, we get the height of the whole screen and subtract the height of the appbar and the safe area padding
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: BlocProvider(
                create: (_) =>
                    EditEmailCubit(context.read<AuthenticationRepository>()),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Column(
                      children: [
                        TextFormField(
                          controller: emailController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            return Validator.validateEmail(value, context);
                          },
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.mail_rounded,
                                color: Colors.blue,
                              ),
                              hintText: "example@gmail.com",
                              labelText: "Email Address"),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: BlocBuilder<EditEmailCubit, EditEmailState>(
                          builder: (context, state) {
                            return state.isUpdatingEmail
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0)),
                                      primary: Color(0XFF4eaaf8),
                                    ),
                                    onPressed: () async {
                                      if (Validator.validateEmail(
                                              emailController.text, context) ==
                                          null) {
                                        bool value = await context
                                            .read<EditEmailCubit>()
                                            .updateEmail(emailController.text);
                                        if (value) Navigator.pop(context);
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Text(
                                        "Edit Email Address",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  );
                          },
                        )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
