import 'package:google_sign_in/google_sign_in.dart';

// class GoogleAuth {
final GoogleSignIn googleSignIn = GoogleSignIn(
  clientId:
      '887976103157-7un5bl7sckal9eg46hamq6so1pima2t4.apps.googleusercontent.com',
  signInOption: SignInOption.standard,
  scopes: [
    'email',
    //'https://www.googleapis.com/auth/contacts.readonly',
  ],
);
// }
