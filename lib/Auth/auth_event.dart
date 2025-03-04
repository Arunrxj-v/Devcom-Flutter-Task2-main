import 'package:equatable/equatable.dart';

abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent({required this.email, required this.password});
}

class GoogleSignInEvent extends AuthEvent {}

class SignUpEvent extends AuthEvent {
  final String email;
  final String password;

   SignUpEvent(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}