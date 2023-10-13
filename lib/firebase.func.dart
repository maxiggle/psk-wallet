import 'package:firebase_auth/firebase_auth.dart';

FirebaseAuth auth = FirebaseAuth.instance;

Future<void> verifyNumber(String userPhoneNumber, ) async {
  await auth.verifyPhoneNumber(
    phoneNumber: '+44 7123 123 456',
    verificationCompleted: (PhoneAuthCredential credential) async {
      // ANDROID ONLY!

      // Sign the user in (or link) with the auto-generated credential
      await auth.signInWithCredential(credential);
    },
    verificationFailed: (FirebaseAuthException error) {},
    codeSent: (String verificationId, int? forceResendingToken) {},
    codeAutoRetrievalTimeout: (String verificationId) {},
  );
}
