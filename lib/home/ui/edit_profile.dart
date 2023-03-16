import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing/auth/bloc/auth/auth_bloc.dart';
import 'package:ticketing/auth/repo/auth_repo.dart';
import 'package:ticketing/home/services/TakePicture.dart';
// import 'package:ticketing/home/ui/edit_bio_and_location.dart';
import 'package:ticketing/home/ui/edit_display_name.dart';
import 'package:ticketing/home/ui/edit_email.dart';
import 'package:ticketing/home/ui/edit_phone.dart';

class EditProfile extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => EditProfile(),
    );
  }

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("${ context.watch<AuthBloc>().state.user.name ?? context.watch<AuthBloc>().state.user.email.split("@")[0]}"),
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
        width: MediaQuery.of(context).size.width,
        child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage(
                          "assets/avatar.png",
                        ),
                        radius: 60,
                        child: IconButton(
                            padding: EdgeInsets.all(0.0),
                            icon: Icon(
                              Icons.camera_enhance_rounded,
                              size: 34,
                            ),
                            onPressed: () async {
                              File croppedFile =
                                  await TakePicture.takePictureAndEdit();
                              if (croppedFile != null) {
                                await context
                                    .read<AuthenticationRepository>()
                                    .uploadProfilePicture(
                                        croppedFile, state.user.id);
                                Navigator.pop(context);
                              }
                            }),
                      )
                    ],
                  );
                }),
                Card(
                  child: ListTile(
                    title: Text("Edit Name"),
                    onTap: () {
                      Navigator.of(context).push(EditDisplayName.route());
                    },
                    trailing: Icon(Icons.navigate_next),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text("Edit Email"),
                    onTap: () {
                      Navigator.of(context).push(EditEmail.route());
                    },
                    trailing: Icon(Icons.navigate_next),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text("Edit Phone Number"),
                    onTap: () {
                      Navigator.of(context).push(EditPhone.route());
                    },
                    trailing: Icon(Icons.navigate_next),
                  ),
                ),
                // Card(
                //   child: ListTile(
                //     title: Text("Edit Bio and Location"),
                //     onTap: () {
                //       Navigator.of(context).push(EditBioAndLocation.route());
                //     },
                //     trailing: Icon(Icons.navigate_next),
                //   ),
                // ),
              ],
            )),
      ))),
    );
  }
}
