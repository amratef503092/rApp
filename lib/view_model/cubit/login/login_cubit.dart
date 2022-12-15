import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:p3/view/pages/users/hoem_user_screen.dart';

import '../../../database/local/cache_helper.dart';
import '../../../model/user_model/user.dart';


part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  static LoginCubit get(context) => BlocProvider.of(context);

  // login function use it to login in app i reseved email and password to login
  UserModel? userModel;
  Future<void> login(
      {
        required String email, required String password,
      }) async
  {
    emit(UserLoginLoading());
    userModel = null; // here i remove all old data to receive New Data
    await FirebaseAuth
        .instance // firebase auth this library i use it to login i send request Email and password
        .signInWithEmailAndPassword
        (
        email: email,
        password: password
        )
        .then((value) async {
      // if login successful i will update user is online to true
      await FirebaseFirestore.instance
          .collection('users')
          .doc(value.user!.uid)
          .update({'online': true});

      await CacheHelper.put(
          key: 'id', value: value.user!.uid); // i cache user id to use
      // if login successful i will get user id and i will use it to get user data from firebase
      await FirebaseFirestore.instance
          .collection('users')
          .doc(value.user!.uid)
          .get()
          .then((value) async {
        userModel = UserModel.fromMap(value.data()!);
        // save user id in cashHelper
        emit(UserLoginSuccess(
          approveUser: userModel!.approveUser,
            role: userModel!.role,
            message: 'Login Successful',
            userID: userModel!.id,
            ban: userModel!.ban));
        // here i will store user data in userModel
        //  cashing role user
      });
    }).catchError((onError) {
      // if email Error or password Error show message :D
      if (onError is FirebaseAuthException) {
        print(onError.message);
        emit(UserLoginFailed(message: onError.message!.trim()));
      }
    });
  }
}
