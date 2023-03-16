import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';
import 'package:ticketing/auth/repo/constants.dart';
import 'package:ticketing/home/services/Validator.dart';
import 'package:ticketing/vo/user.dart';
import 'package:tuple/tuple.dart';

class SignUpFailure implements Exception {}

class LoginWithEmailAndPasswordFailure implements Exception {}

class LogInWithGoogleFailure implements Exception {}

class LogOutFailure implements Exception {}

class SendCodeFailure implements Exception {}

class VerifyCodeFailure implements Exception {
  final String message;

  const VerifyCodeFailure(this.message) : super();
}

class UploadProfilePictureException implements Exception {}

class UpdateDisplayNameException implements Exception {}

class UpdateEmailException implements Exception {}

class UpdatePhoneNumberException implements Exception {}

class UpdateBioAndLocationException implements Exception {}

class AuthenticationRepository {
  AuthenticationRepository(
      {firebase_auth.FirebaseAuth firebaseAuth, GoogleSignIn googleSignIn})
      : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.standard();

  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  StreamController<User> controller;

  // Stream of [User] which will emit the current user when
  // the authentication state changes.
  // Emits [User.empty] if the user is not authenticated
  Stream<User> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      return firebaseUser == null ? User.empty : firebaseUser.toUser;
    });
  }

  Stream<User> get updatedUser {
    controller = StreamController<User>();
    return controller.stream;
  }

  Future<void> signUp({
    @required String email,
    @required String password,
  }) async {
    assert(email != null && password != null);
    try {
      // TODO implement sendEmailVerification
      // var r =
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      // r.user.sendEmailVerification(firebase_auth.ActionCodeSettings(url: 'url'));
    } on Exception {
      throw SignUpFailure();
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser.authentication;
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _firebaseAuth.signInWithCredential(credential);
    } on Exception {
      throw LogInWithGoogleFailure();
    }
  }

  Future<void> sendResetEmail(email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch(e) {
      throw e;
    }
  }

  Future<void> loginWithEmailAndPassword({
    @required String email,
    @required String password,
  }) async {
    assert(email != null && password != null);
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on Exception {
      throw LoginWithEmailAndPasswordFailure();
    }
  }

  Future<void> logOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } on Exception {
      throw LogOutFailure();
    }
  }

  String _reformatPhoneNumber(String phoneNumber) {
    if (phoneNumber.startsWith("09"))
      return phoneNumber.replaceAll(RegExp(r"^0"), "+251");
    else if (phoneNumber.startsWith("9"))
      return phoneNumber.replaceAll(RegExp(r"^"), "+251");
    else if (phoneNumber.startsWith("251"))
      return phoneNumber.replaceAll(RegExp(r"^251"), "+251");
    return phoneNumber;
  }

  Future<Tuple2<String, int>> sendPhoneCode(String phoneNumber) async {
    // Reformat phone number
    String reformattedPhoneNumber = _reformatPhoneNumber(phoneNumber);

    var completer = Completer<Tuple2<String, int>>();
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: reformattedPhoneNumber,
        verificationCompleted:
            (firebase_auth.PhoneAuthCredential credential) async {
          await _firebaseAuth.signInWithCredential(credential);
          completer.complete(Tuple2('', 0));
        },
        verificationFailed: (firebase_auth.FirebaseAuthException e) {
          completer.completeError(e);
        },
        codeSent: (String verificationId, int resendToken) {
          completer.complete(Tuple2(verificationId, resendToken));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          completer.complete(Tuple2(verificationId, 0));
        },
      );
    } on Exception {
      completer.completeError(SendCodeFailure());
    }
    return completer.future;
  }

  Future<void> verifyPhoneCode(String verificationId, String code) async {
    firebase_auth.PhoneAuthCredential credential =
        firebase_auth.PhoneAuthProvider.credential(
            verificationId: verificationId, smsCode: code);
    await _firebaseAuth.signInWithCredential(credential);
  }

  Future<bool> uploadProfilePicture(File pickedFile, String userId) async {
    Reference reference =
        storage.ref().child("$profileImagesDirectory/$userId");
    print("Uploading an image");
    UploadTask task = reference.putFile(pickedFile);
    try {
      return await task.then((TaskSnapshot snapshot) async {
        String pictureUrl = await snapshot.ref.getDownloadURL();
        await _firebaseAuth.currentUser.updateProfile(photoURL: pictureUrl);
        User updatedUser = User(
            email: _firebaseAuth.currentUser.email,
            id: _firebaseAuth.currentUser.uid,
            photo: pictureUrl,
            name: _firebaseAuth.currentUser.displayName);
        controller.add(updatedUser);
        return true;
      });
    } catch (e) {
      throw UploadProfilePictureException;
    }
  }

  Future<bool> updateDisplayName(String name) async {
    try {
      await _firebaseAuth.currentUser.updateProfile(displayName: name);
      User updatedUser = User(
          email: _firebaseAuth.currentUser.email,
          id: _firebaseAuth.currentUser.uid,
          photo: _firebaseAuth.currentUser.photoURL,
          name: _firebaseAuth.currentUser.displayName);
      controller.add(updatedUser);
      print("Successfully Changed Display Name");
      return true;
    } catch (e) {
      throw UpdateDisplayNameException;
    }
  }

  Future<bool> updateEmail(String email) async {
    try {
      await _firebaseAuth.currentUser.updateEmail(email);
      User updatedUser = User(
          email: _firebaseAuth.currentUser.email,
          id: _firebaseAuth.currentUser.uid,
          photo: _firebaseAuth.currentUser.photoURL,
          name: _firebaseAuth.currentUser.displayName);
      controller.add(updatedUser);
      print("Successfully Changed email");
      return true;
    } catch (e) {
      throw UpdateEmailException;
    }
  }

  Future<bool> updatePhoneNumber(
      String phoneNumber, BuildContext context) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted:
            (firebase_auth.PhoneAuthCredential credential) async {
          await _firebaseAuth.currentUser.updatePhoneNumber(credential);
        },
        verificationFailed: (firebase_auth.FirebaseAuthException exception) {
          print(exception.message);
          print("Verification Failed");
        },
        timeout: Duration(minutes: 2),
        codeSent: (String verificationId, int forceResendingToken) {
          TextEditingController codeController = TextEditingController();
          showDialog(
              builder: (context) => SimpleDialog(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Container(
                      width: 100,
                      child: TextFormField(
                        validator: (value) {
                          return Validator.validatePassword(value, context,
                              isOtp: true);
                        },
                        controller: codeController,
                        decoration: InputDecoration(
                            hintText: "Enter the SMS code sent to you"),
                      ),
                    ),
                  ),
                  Container(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shadowColor: Colors.green
                      ),
                      onPressed: () async {
                        if (Validator.validatePassword(
                                codeController.text, context,
                                isOtp: true) ==
                            null) {
                          firebase_auth.AuthCredential credential =
                              firebase_auth.PhoneAuthProvider.credential(
                                  verificationId: verificationId,
                                  smsCode: codeController.text);
                          try {
                            await _firebaseAuth.currentUser
                                .updatePhoneNumber(credential);
                            User updatedUser = User(
                                email: _firebaseAuth.currentUser.email,
                                id: _firebaseAuth.currentUser.uid,
                                photo: _firebaseAuth.currentUser.photoURL,
                                name: _firebaseAuth.currentUser.displayName);
                            controller.add(updatedUser);
                            print("Successfully Changed phone number");
                            Navigator.pop(context);
                          } catch (e) {
                            throw e;
                          }
                        }
                      },
                      child: Text(
                        "Enter Code",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ), context: context);
        },
        codeAutoRetrievalTimeout: (String timeout) {},
      );

      return true;
    } catch (e) {
      throw UpdatePhoneNumberException;
    }
  }

  Future<bool> updateBioAndLocation(
      String bio, String location, String id) async {
    try {
      await _fireStore
          .collection("bio_and_location")
          .doc(id)
          .set({'bio': bio, 'location': location, 'uid': id});
      print("Successfully Changed Bio and Location");
      return true;
    } catch (e) {
      throw UpdateBioAndLocationException;
    }
  }
}

extension on firebase_auth.User {
  User get toUser {
    return User(id: uid, email: email, name: displayName, photo: photoURL);
  }
}
