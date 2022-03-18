import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:twitter_clone/repository/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;
  StreamSubscription? streamSubscription;
  AuthCubit(this.authRepository) : super(AuthInitial()) {
    streamSubscription = authRepository.authState().listen((event) {
      emit(event == null ? UnAuthenticated() : Authenticated());
    });
  }

  Stream<User?> authState() {
    return authRepository.authState();
  }

  RegExp get emailRegEx {
    return authRepository.emailReg;
  }

  signIn(String email, String password) async {
    try {
      emit(Authenticating());
      await authRepository.signIn(email, password);
      emit(AuthInitial());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(AuthenticatingFailed('No user found for that email.'));
      } else if (e.code == 'wrong-password') {
        emit(AuthenticatingFailed('Wrong password provided for that user.'));
      } else {
        emit(AuthenticatingFailed('Something went wrong'));
      }
    } catch (e) {
      emit(AuthenticatingFailed('Check your internet connection'));
    }
  }

  signUp(String email, String password) async {
    try {
      emit(Authenticating());
      await authRepository.registerUser(email, password);
      emit(AuthInitial());
    } on FirebaseAuthException catch (e) {
      log("$e");
      if (e.code == 'weak-password') {
        emit(AuthenticatingFailed('The password provided is too weak.'));
      } else if (e.code == 'email-already-in-use') {
        emit(
            AuthenticatingFailed('The account already exists for that email.'));
      } else {
        emit(AuthenticatingFailed('Something went wrong'));
      }
    } catch (e) {
      emit(AuthenticatingFailed('Check your internet connection'));
    }
  }

  @override
  Future<void> close() {
    streamSubscription?.cancel();
    return super.close();
  }
}
