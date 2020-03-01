import 'package:asima_online/models/provider_data.dart';
import 'package:asima_online/screens/signin_screen.dart';
import 'package:asima_online/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;
  static final firestore = Firestore.instance;
  static final GoogleSignIn googleSignIn = new GoogleSignIn();
  static FacebookLogin facebookLogin = new FacebookLogin();
  static void signUpWithEmail(BuildContext context, String name, String email,
      String password, String type) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      if (user != null) {
        usersRef.document(user.uid).setData({
          'name': name,
          'email': email,
          'profileImageUrl': '',
          'userType': type,
        });
        Provider.of<ProviderData>(context, listen: false).currentUserId =
            user.uid;
        Provider.of<ProviderData>(context, listen: false).signInMethod =
            'email';
        Navigator.pop(context);
      }
    } catch (err) {
      print(err);
    }
  }

  static void signInWithEmail(
      BuildContext context, String email, String password) async {
    try {
      AuthResult authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = authResult.user;
      Provider.of<ProviderData>(context, listen: false).currentUserId =
          user.uid;
      Provider.of<ProviderData>(context, listen: false).signInMethod = 'email';
      Navigator.pop(context);
    } catch (e) {
      print(e);
    }
  }

  static void signWithGoogle(BuildContext context) async {
    try {
      GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final AuthResult authResult =
          await _auth.signInWithCredential(credential);
      final FirebaseUser user = authResult.user;
      final isUserSignedIn = await usersRef.document(user.uid).get();
      if (user != null && !isUserSignedIn.exists) {
        usersRef.document(user.uid).setData({
          'name': user.displayName,
          'email': user.email,
          'profileImageUrl': '',
          'userType': 'individual',
        });
      }
      Provider.of<ProviderData>(context, listen: false).currentUserId =
          user.uid;
      Provider.of<ProviderData>(context, listen: false).signInMethod = 'google';
      Navigator.pop(context);
    } catch (e) {
      print(e);
    }
  }

  static void signWithFacebook(BuildContext context) async {
    FacebookLoginResult facebookLoginResult =
        await facebookLogin.logIn(['email', 'public_profile']);
    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        print("Error");
        break;
      case FacebookLoginStatus.cancelledByUser:
        Navigator.pop(context);
        break;
      case FacebookLoginStatus.loggedIn:
        final facebookAuthCred = FacebookAuthProvider.getCredential(
            accessToken: facebookLoginResult.accessToken.token);
        final authResult = await _auth.signInWithCredential(facebookAuthCred);
        final user = authResult.user;
        final isUserSignedUp = await usersRef.document(user.uid).get();
        if (user != null && !isUserSignedUp.exists) {
          usersRef.document(user.uid).setData({
            'name': user.displayName,
            'email': user.email,
            'profileImageUrl': '',
            'userType': 'individual',
          });
        }
        Provider.of<ProviderData>(context, listen: false).currentUserId =
            user.uid;
        Provider.of<ProviderData>(context, listen: false).signInMethod =
            'facebook';
        Navigator.pop(context);
        break;
    }
  }

  static void logout(BuildContext context) async {
    var _signInMethod =
        Provider.of<ProviderData>(context, listen: false).signInMethod;
    if (_signInMethod == 'email') {
      _auth.signOut();
      Provider.of<ProviderData>(context, listen: false).currentUserId = null;
      Provider.of<ProviderData>(context, listen: false).signInMethod = null;
      Navigator.pushReplacementNamed(context, SignIn.id);
    } else if (_signInMethod == 'google') {
      await googleSignIn.signOut();
      _auth.signOut();
      Provider.of<ProviderData>(context, listen: false).currentUserId = null;
      Provider.of<ProviderData>(context, listen: false).signInMethod = null;
      Navigator.pushReplacementNamed(context, SignIn.id);
    } else if (_signInMethod == 'facebook') {
      await facebookLogin.logOut();
      _auth.signOut();
      Provider.of<ProviderData>(context, listen: false).currentUserId = null;
      Provider.of<ProviderData>(context, listen: false).signInMethod = null;
      Navigator.pop(context);
    }
  }
}
