import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:entregable_2/auth/user_auth_provider.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  UserAuthProvider _authProvider = UserAuthProvider();
  FirebaseAuth mAuth = FirebaseAuth.instance;
  LoginBloc() : super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is VerifyLogInEvent) {
      try {
        if (_authProvider.isAlreadyLogged())
          yield LoginSuccessState();
        else
          yield LoginInitial();
      } catch (e) {
        yield LoginInitial();
      }
    } else if (event is LoginWithGoogleEvent) {
      try {
        yield LoginLoadingState();
        await _authProvider.signInWithGoogle();
        yield LoginSuccessState();
      } catch (e) {
        yield LoginErrorState(
            error: "Error while trying to sign in with Google");
      }
    } else if (event is LogoutWithGoogleEvent) {
      try {
        if (_authProvider.isAlreadyLogged()) {
          _authProvider.signOutGoogle();
          yield LoginInitial();
        }
      } catch (e) {}
    } else if (event is LoginWithEmailEvent) {
      try {
        mAuth.signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        yield LoginSuccessState();
      } catch (e) {}
    }
  }
}
