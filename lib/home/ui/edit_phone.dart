import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing/auth/repo/auth_repo.dart';
import 'package:ticketing/home/bloc/edit_phone_number/edit_phone_number_cubit.dart';
import 'package:ticketing/home/bloc/edit_phone_number/edit_phone_number_state.dart';
import 'package:ticketing/home/services/Validator.dart';

class EditPhone extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => EditPhone(),
    );
  }

  @override
  _EditPhoneState createState() => _EditPhoneState();
}

class _EditPhoneState extends State<EditPhone> {
  TextEditingController phoneController;

  @override
  void initState() {
    phoneController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Edit Phone Number"),
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
                  create: (_) => EditPhoneNumberCubit(
                      context.read<AuthenticationRepository>()),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Column(
                        children: [
                          TextFormField(
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              return Validator.validatePhone(value, context);
                            },
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.phone,
                                  color: Colors.blue,
                                ),
                                hintText: "000 - 000 - 000",
                                labelText: "Phone"),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(child: BlocBuilder<EditPhoneNumberCubit,
                              EditPhoneNumberState>(
                            builder: (context, state) {
                              return state.isUpdatingPhoneNumber
                                  ? Center(child: CircularProgressIndicator())
                                  : ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0)),
                                      primary: Color(0XFF4eaaf8),
                                    ),
                                      onPressed: () async {
                                        if (Validator.validatePhone(
                                                phoneController.text,
                                                context) ==
                                            null) {
                                          context
                                              .read<EditPhoneNumberCubit>()
                                              .updatePhoneNumber(
                                                  phoneController.text,
                                                  context);
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Text(
                                          "Edit Phone Number",
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
                )),
          ),
        ),
      ),
    );
  }
}
