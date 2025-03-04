import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AuthBloc(this._auth) : super(AuthInitial()) {
    on<LoginEvent>((event, emit) async {
      try {
        emit(AuthLoading());
        
        final userCredential = await _auth.signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );

        if (userCredential.user != null) {
          emit(AuthSuccess(userCredential.user!));
        } else {
          emit( AuthError('Login failed'));
        }
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<GoogleSignInEvent>((event, emit) async {
      try {
        emit(AuthLoading());
        
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

        if (googleUser == null) {
          emit( AuthError('Google Sign In was canceled'));
          return;
        }

        final GoogleSignInAuthentication googleAuth = 
            await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential userCredential = 
            await _auth.signInWithCredential(credential);
            
        if (userCredential.user != null) {
          emit(AuthSuccess(userCredential.user!));
        } else {
          emit( AuthError('Google Sign In failed'));
        }
      } catch (e) {
        emit(AuthError(e.toString()));
        print('Google Sign In Error: $e');
      }
    });

    on<SignUpEvent>((event, emit) async {
      try {
        emit(AuthLoading());
        
        final userCredential = await _auth.createUserWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );

        if (userCredential.user != null) {
          emit(AuthSuccess(userCredential.user!));
        } else {
          emit( AuthError('Sign up failed'));
        }
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });
  }
}