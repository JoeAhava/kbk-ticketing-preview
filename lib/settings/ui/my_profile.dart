import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing/auth/bloc/auth/auth_bloc.dart';
import 'package:ticketing/auth/ui/sign_in_page.dart';
import 'package:ticketing/settings/ui/payment_options.dart';
import 'package:ticketing/settings/ui/saved_cards.dart';
import 'package:ticketing/utils.dart';

class MyProfilePage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => MyProfilePage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: ListView(
        children: [
          ListTile(
            title: Text(
              'My Accounts',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: Icon(Icons.card_giftcard),
            title: Text($t(context, 'account.saved_cards')),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.of(context).push(SavedCards.route());
            },
          ),
          ListTile(
            leading: Icon(Icons.home_filled),
            title: Text($t(context, 'account.payment_options')),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.of(context).push(PaymentOptions.route());
            },
          ),
          Divider(),
          ListTile(
            title: Text(
              $t(context, 'account.saved_cards'),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: Icon(Icons.support),
            title: Text($t(context, 'account.support')),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.accessibility),
            title: Text($t(context, 'account.accessibility')),
            trailing: Icon(Icons.accessibility),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.insert_drive_file_rounded),
            title: Text($t(context, 'account.terms')),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text($t(context, 'account.privacy')),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.wrap_text),
            title: Text($t(context, 'account.saved_cards')),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.share),
            title: Text($t(context, 'account.share')),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.info_sharp),
            title: Text($t(context, 'account.about')),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {},
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
                        content: Text(
                            $t(context, 'account.sign_out_confirm_message')),
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
      ),
    );
  }

  AppBar _appBar(context) => AppBar(
        title: Text('My Profile'),
        shadowColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      );
}
