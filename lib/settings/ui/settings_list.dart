import 'package:flutter/material.dart';
import 'package:ticketing/settings/ui/change_password.dart';
import 'package:ticketing/settings/ui/my_profile.dart';
import 'package:ticketing/utils.dart';

import '../../home/ui/edit_profile.dart';

class SettingsList extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => SettingsList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text($t(context, 'setting.appbar')),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [Color(0xFF4fabf6), Color(0XFF6dc2e7)],
          )),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Card(
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 0.0),
                    child: ListTile(
                      leading: Icon(Icons.person),
                      title: Text($t(context, 'setting.account'),
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      trailing: Icon(Icons.navigate_next),
                      onTap: () {
                        Navigator.of(context).push<void>(EditProfile.route());
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Card(
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 0.0),
                    child: ListTile(
                      leading: Icon(Icons.lock),
                      title: Text(
                        $t(context, 'setting.change_password'),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: Icon(Icons.navigate_next),
                      onTap: () {
                        Navigator.of(context)
                            .push<void>(ChangePassword.route());
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Card(
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 0.0),
                    child: ListTile(
                      leading: Icon(Icons.notifications),
                      title: Text($t(context, 'setting.notification'),
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      trailing: Switch(
                        value: false,
                        activeTrackColor: Colors.lightGreenAccent,
                        activeColor: Colors.green,
                        onChanged: (bool value) {},
                      ),
                      onTap: () {},
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
