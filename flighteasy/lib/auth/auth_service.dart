import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    signInOption: SignInOption.standard, // Ensure the standard flow is used
    scopes: [
      'email', // Access the user's email
      'profile', // Access the user's profile
    ],
  );

  // Google Sign-In
  Future<User?> signInWithGoogle() async {
    try {
      // Trigger the Google Authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in
        return null;
      }

      // Obtain the Google Sign-In authentication details
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential using the Google token
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final UserCredential userCredential = await _auth.signInWithCredential(credential);

      return userCredential.user;
    } catch (e) {
      print("Error during Google Sign-In: $e");
      return null;
    }
  }

  // Sign-In With Email
Future<User?> signInWithEmail(String email, String password) async {
  try {
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user;
  } catch (e) {
    print("Email Sign-In Error: $e");
    return null;
  }
}

  // Email Registration
  Future<User?> registerWithEmail(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Error registering with email: $e");
      return null;
    }
  }

  // Sending SMS Code
  Future<void> sendCode(String phoneNumber, Function(String) onCodeSent) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Automatically sign in the user when verification is completed
        await _auth.signInWithCredential(credential);
        print('User signed in automatically');
      },
      verificationFailed: (FirebaseAuthException e) {
        print('Phone number verification failed: ${e.message}');
        print('Error code: ${e.code}');
      },
      codeSent: (String verificationId, int? resendToken) {
        print('Code sent to $phoneNumber');
        onCodeSent(verificationId); // Pass verificationId to the callback
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print('Auto retrieval timeout');
      },
    );
  }

// Verifying SMS Code
Future<void> verifyCode(String verificationId, String smsCode) async {
  FirebaseAuth auth = FirebaseAuth.instance;

  // Create a PhoneAuthCredential with the code
  PhoneAuthCredential credential = PhoneAuthProvider.credential(
    verificationId: verificationId,
    smsCode: smsCode,
  );

  // Sign in the user with the credential
  await auth.signInWithCredential(credential);
  print('User signed in with SMS code');
}

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    print("User signed out");
  }

  // Get Current User
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
