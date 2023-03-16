import 'package:flutter/material.dart';
import 'package:ticketing/utils.dart';

class ChangePassword extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => ChangePassword());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Change Password"),
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
                AppBar()
                    .preferredSize
                    .height, // To get the usable screen height, we get the height of the whole screen and subtract the height of the appbar and the safe area padding
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                            hintText: "example@123",
                            labelText: $t(context, 'placeholder.old_password')),
                      ),
                      Container(
                        height: 10,
                      ),
                      TextField(
                        decoration: InputDecoration(
                            // hintText: "example@123",
                            labelText: $t(context, 'placeholder.new_password')),
                      ),
                      Container(
                        height: 10,
                      ),
                      TextField(
                        decoration: InputDecoration(
                            // hintText: "example@123",
                            labelText:
                                $t(context, 'placeholder.confirm_password')),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                            primary: Color(0XFF4eaaf8),
                          ),
                          onPressed: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              $t(context, 'account.change_password_btn'),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
