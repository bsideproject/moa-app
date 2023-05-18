import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInApi {
  static final _googleSignIn = GoogleSignIn();

  static Future<GoogleSignInAccount?> login () => _googleSignIn.signIn();

  static Future logout() => _googleSignIn.disconnect();
  // {
  //    displayName: paul kim,
  //    email: paulracooni@gmail.com,
  //    id: 113833284447125050510,
  //    photoUrl: https://lh3.googleusercontent.com/a/AGNmyxY0SnfHaotwxf-lQQBv26uDeTWZiPbcwO4dqpss,
  //    serverAuthCode: null
  // }
}


