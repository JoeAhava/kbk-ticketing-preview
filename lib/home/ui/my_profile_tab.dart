import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing/auth/bloc/auth/auth_bloc.dart';
import 'package:ticketing/auth/ui/sign_in_page.dart';
import 'package:ticketing/home/ui/edit_profile.dart';
import 'package:ticketing/utils.dart';

class MyProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // ListTile(
        //   title: Text(
        //     'Policies',
        //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        //   ),
        // ),
        // ListTile(
        //   leading: Icon(Icons.support),
        //   title: Text($t(context, 'account.support')),
        //   trailing: Icon(Icons.arrow_forward_ios),
        //   onTap: () {},
        // ),
        // ListTile(
        //   leading: Icon(Icons.insert_drive_file_rounded),
        //   title: Text($t(context, 'account.terms')),
        //   trailing: Icon(Icons.arrow_forward_ios),
        //   onTap: () {},
        // ),
        // ListTile(
        //   leading: Icon(Icons.lock),
        //   title: Text($t(context, 'account.privacy')),
        //   trailing: Icon(Icons.arrow_forward_ios),
        //   onTap: () {},
        // ),
        // ListTile(
        //   leading: Icon(Icons.wrap_text),
        //   title: Text($t(context, 'account.feedback')),
        //   trailing: Icon(Icons.arrow_forward_ios),
        //   onTap: () {},
        // ),
        // ListTile(
        //   leading: Icon(Icons.share),
        //   title: Text($t(context, 'account.share')),
        //   trailing: Icon(Icons.arrow_forward_ios),
        //   onTap: () {},
        // ),
        
        ListTile(
          leading: Icon(Icons.person),
          title: Text($t(context, 'account.edit'),
              ),
          trailing: Icon(Icons.navigate_next),
          onTap: () {
            Navigator.of(context).push<void>(EditProfile.route());
          },
        ),
        Divider(),
        ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.vpn_key,
                  color: Colors.red,
                ),
              ),
              Text(
                $t(context, 'account.sign_out'),
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                      title: Text($t(context, 'account.sign_out_confirm')),
                      content:
                          Text($t(context, 'account.sign_out_confirm_message')),
                      actions: [
                        TextButton(
                            onPressed: () {
                              context
                                  .read<AuthBloc>()
                                  .add(AuthLogoutRequested());
                              Navigator.of(context).pushAndRemoveUntil(
                                  SignInPage.route(), (route) => false);
                            },
                            child: Text($t(context, 'account.sign_out')))
                      ]);
                });
          },
        )
      ],
    );
  }
}
