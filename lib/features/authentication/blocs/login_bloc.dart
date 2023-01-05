import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:follow/features/authentication/login_repo.dart';

import '../models/user_model.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent,LoginState>{
  LoginBloc() : super(LoginInitial()){
    on<LoginUserEvent>(_onUserLogin);
  }
   final userData = FirebaseFirestore.instance
    .collection('firestore-example-app')
    .withConverter<UserModel>(
      fromFirestore: (snapshots, _) => UserModel.fromJson(snapshots.data()!),
      toFirestore: (user, _) => user.toJson(),
    );

  Future<void> _onUserLogin(
    LoginEvent event, Emitter<LoginState> emit)async{
      emit(LoginLoading());
      //call function to login
      var data = await FirebaseAuthFunctions().signInWithGoogle();
      await FirebaseFirestore.instance.collection("userData").add(
        {
          "name" : data.displayName,
          "email":data.email,
          "id":data.id
        }
      );
      emit ( LoginSuccess(loggedInData: data));
    }

    


    

}