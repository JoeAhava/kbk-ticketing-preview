import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing/auth/bloc/auth/auth_bloc.dart';
import 'package:ticketing/auth/repo/auth_repo.dart';
import 'package:ticketing/home/bloc/edit_bio_and_location/edit_bio_and_location_cubit.dart';
import 'package:ticketing/home/bloc/edit_bio_and_location/edit_bio_and_location_state.dart';
import 'package:ticketing/home/services/Validator.dart';

class EditBioAndLocation extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => EditBioAndLocation(),
    );
  }

  @override
  _EditBioAndLocationState createState() => _EditBioAndLocationState();
}

class _EditBioAndLocationState extends State<EditBioAndLocation> {
  TextEditingController locationController, bioController;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    locationController = TextEditingController();
    bioController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Edit Bio And Location"),
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
                  create: (_) => EditBioAndLocationCubit(
                      context.read<AuthenticationRepository>()),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Column(
                          children: [
                            Container(
                              height: 80,
                              width: MediaQuery.of(context).size.width - 24,
                              // since this text field expands, we need to set the height width, the value 24 subtracted is for the padding set above
                              child: TextFormField(
                                controller: bioController,
                                expands: true,
                                maxLines: null,
                                minLines: null,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  return Validator.validateName(value, context);
                                },
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.person_pin_rounded,
                                    color: Colors.blue,
                                  ),
                                  labelText: "Bio",
                                  hintText:
                                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
                                      "Sed sit amet felis sit amet justo pretium volutpat. Aenean",
                                ),
                              ),
                            ),
                            Container(
                              height: 20,
                            ),
                            TextFormField(
                              controller: locationController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                return Validator.validateName(value, context);
                              },
                              decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.location_on,
                                    color: Colors.blue,
                                  ),
                                  hintText: "Lorem Ipsum dolor sit amet",
                                  labelText: "Location"),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(child: BlocBuilder<AuthBloc, AuthState>(
                              builder: (context, authState) {
                                return BlocBuilder<EditBioAndLocationCubit,
                                    EditBioAndLocationState>(
                                  builder: (context, state) {
                                    return state.isUpdatingBioAndLocation
                                        ? Center(
                                            child: CircularProgressIndicator())
                                        : ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: Color(0XFF4eaaf8),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        30.0),),
                                          ),
                                            
                                            onPressed: () async {
                                              if (_formKey.currentState
                                                  .validate()) {
                                                bool value = await context
                                                    .read<
                                                        EditBioAndLocationCubit>()
                                                    .updateBioAndLocation(
                                                        bioController.text,
                                                        locationController.text,
                                                        authState.user.id);
                                                if (value)
                                                  Navigator.pop(context);
                                              }
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              child: Text(
                                                "Edit Email Address",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          );
                                  },
                                );
                              },
                            )),
                          ],
                        ),
                      ],
                    ),
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
