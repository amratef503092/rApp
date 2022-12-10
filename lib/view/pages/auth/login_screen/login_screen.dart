import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p3/database/local/cache_helper.dart';
import 'package:p3/view_model/notefication.dart';
import '../../../../constants/validator.dart';
import '../../../../view_model/cubit/login/login_cubit.dart';
import '../../../components/buttons/custom_button.dart';
import '../../../components/custom_text_field.dart';
import '../../../components/login & signup/header.dart';
import '../../../components/login & signup/login_signup_switch.dart';
import '../../admin_screen/home_admin_screen.dart';
import '../../users/add_Teretment_screen.dart';
import '../../users/hoem_user_screen.dart';
import '../register_screen/register_screen.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  bool showPassword = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) async{
          if (state is UserLoginSuccess) {
            // ScaffoldMessenger.of(context)
            //     .showSnackBar(const SnackBar(content: Text("Login Success")));
            await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
              'online':true,
            });
            CacheHelper.put(key: 'id', value: FirebaseAuth.instance.currentUser!.uid);
            CacheHelper.put(key: 'role', value:state.role);

          } else if (state is UserLoginFailed) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ));
          }
        },
        builder: (context, state) {
          LoginCubit myCubit = LoginCubit.get(context);
          return Scaffold(
            resizeToAvoidBottomInset: true,
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 50.h),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Header(pageName: "Login"),
                      SizedBox(
                        height: 46.h,
                      ),
                      textFields(),
                      SizedBox(
                        height: 6.h,
                      ),
                      loginAndSignup(myCubit, context),
                      SizedBox(
                        height: 50.h,
                      ),
                    ]),
              ),
            ),
          );
        },
      ),
    );
  }

  //contains email and password textfields
  Widget textFields() {
    return Column(
      children: [
        CustomTextField(
          controller: emailController,
          fieldValidator: emailValidator,
          hint: 'email',
          iconData: Icons.email,
        ),
        SizedBox(
          height: 20.h,
        ),
        CustomTextField(
          controller: passwordController,
          fieldValidator: passwordValidator,
          hint: 'Password',
          iconData: Icons.lock,
          password: showPassword,
          passwordTwo: true,
          function: () {
            setState(() {
              showPassword = !showPassword;
            });
          },
        ),
      ],
    );
  }

  //contains forget password and login button and signup text

  Widget loginAndSignup(LoginCubit myCubit, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 45.h,
        ),
        Center(
            child: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            // TODO: implement listener
            if (state is UserLoginSuccess) {
              // user
              if (state.approveUser) {
                if (state.role == "3") {
                  CacheHelper.put(
                      key: 'id', value: state.userID); // i cache user id to use
                  // save role in cashHelper
                  CacheHelper.put(
                      key: 'role', value: state.role);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeUserScreen()),
                      (route) => false);
                } else {
                  // user
                   CacheHelper.put(
                      key: 'id', value: state.userID); // i cache user id to use
                  // save role in cashHelper
                   CacheHelper.put(
                      key: 'role', value: state.role);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeAdminScreen()),
                      (route) => false);
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Your account is not approved yet"),
                  backgroundColor: Colors.red,
                ));
              }
            }
          },
          builder: (context, state) {
            return (state is UserLoginLoading)
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : CustomButtonOne(
                    buttonTitle: "Login",
                    onClick: () {
                      if (emailController.text.trim().isEmpty ||
                          passwordController.text.trim().isEmpty) {
                        return;
                      }

                      myCubit.login(
                          email: emailController.text.trim(),
                          password: passwordController.text,
                          context: context);
                    });
          },
        )),
        SizedBox(
          height: 35.h,
        ),
        LoginSignUpSwitcher(
          clickableTitle: "Sign up",
          title: "Don't have an account? ",
          navigatorFunction: () {
            // NotificationApi.repetedNotification(
            //     title: "hello",
            //     body: "body",
            //     dateTime: DateTime.now().
            //     add(const Duration(seconds: 2))
            // );
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>  SignUpPage()));
          },
        )
      ],
    );
  }
}
