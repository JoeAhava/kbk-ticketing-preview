import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing/auth/repo/auth_repo.dart';
import 'package:ticketing/home/bloc/edit_display_name/edit_display_name_cubit.dart';
import 'package:ticketing/home/bloc/edit_display_name/edit_display_name_state.dart';
import 'package:ticketing/home/services/Validator.dart';

class EditDisplayName extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => EditDisplayName(),
    );
  }

  @override
  _EditDisplayNameState createState() => _EditDisplayNameState();
}

class _EditDisplayNameState extends State<EditDisplayName> {
  TextEditingController nameController;

  @override
  void initState() {
    nameController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Edit Display Name"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4fabf6), Color(0XFF6dc2e7)],
            ),
          ),
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
                create: (_) => EditDisplayNameCubit(
                  context.read<AuthenticationRepository>(),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Column(
                      children: [
                        TextFormField(
                          controller: nameController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            return Validator.validateName(value, context);
                          },
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.person,
                                color: Colors.blue,
                              ),
                              hintText: "User name",
                              labelText: "Name",
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide())),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: BlocBuilder<EditDisplayNameCubit,
                                EditDisplayNameState>(
                          buildWhen: (previous, current) =>
                              previous.isUpdatingName != current.isUpdatingName,
                          builder: (context, state) {
                            return state.isUpdatingName
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
                                      if (Validator.validateName(
                                              nameController.text, context) ==
                                          null) {
                                        bool value = await context
                                            .read<EditDisplayNameCubit>()
                                            .updateDisplayName(
                                                nameController.text);
                                        if (value) Navigator.pop(context);
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Text(
                                        "Edit Display Name",
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
