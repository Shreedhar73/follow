part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props=> [];
}

class LoginInitial extends LoginState{}
class LoginLoading extends LoginState{}

class LoginSuccess extends LoginState{
  final dynamic loggedInData;
  const LoginSuccess({required this.loggedInData});

  @override
  List<Object> get props => [loggedInData];
  
} 

class LoginError extends LoginState{
  final String errorMessage;
  const LoginError({required this.errorMessage});

  @override 
  List<Object> get props=>[errorMessage];
}