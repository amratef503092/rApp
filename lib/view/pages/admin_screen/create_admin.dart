import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:p3/view_model/cubit/auth/auth_cubit.dart' as auth;

import '../../../../constants/validator.dart';
import '../../../../view_model/cubit/signup/signup_cubit.dart';
import '../../components/buttons/custom_button.dart';
import '../../components/custom_text_field.dart';
import '../../components/login & signup/header.dart';

class CreateNewAdmin extends StatefulWidget {
  CreateNewAdmin({Key? key}) : super(key: key);

  @override
  State<CreateNewAdmin> createState() => _CreateNewAdminState();
}

class _CreateNewAdminState extends State<CreateNewAdmin> {
  TextEditingController emailController = TextEditingController();
  RegExp regExp = RegExp(r"^[0-9]{2}$", caseSensitive: false);

  TextEditingController userNameController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController passwordConfirmationController =
  TextEditingController();
  List<String> gender = ['Male', 'Female'];
  String valueGender = 'Male';
  bool showPassword = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignupCubit(),
      child: BlocBuilder<SignupCubit, SignupState>(
        builder: (context, state) {
          SignupCubit myCubit = SignupCubit.get(context);
          return Scaffold(
            resizeToAvoidBottomInset: true,
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 50.h),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Header(pageName: "Create New Admin"),
                      SizedBox(
                        height: 46.h,
                      ),
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            CustomTextField(
                              controller: emailController,
                              fieldValidator: emailValidator,
                              hint: 'email',
                              iconData: Icons.email,
                            ),
                            const SizedBox(
                              height: 20,
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
                            const SizedBox(
                              height: 20,
                            ),

                            CustomTextField(
                              controller: nameController,
                              fieldValidator: (String value) {
                                if (value
                                    .trim()
                                    .isEmpty || value == ' ') {
                                  return 'This field is required';
                                }
                                if (!RegExp(r'^[a-zA-Z]+(\s[a-zA-Z]+)?$')
                                    .hasMatch(value)) {
                                  return 'please enter only two names with one space';
                                }
                                if (value.length < 3 || value.length > 32) {
                                  return 'First name must be between 2 and 32 characters';
                                }
                              },
                              hint: 'name',
                              iconData: Icons.perm_identity,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                const FaIcon(
                                  FontAwesomeIcons.marsAndVenus,
                                  color: Colors.grey,
                                ),
                                SizedBox(
                                  width: 20.w,
                                ),
                                SizedBox(
                                  width: 245.w,
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton2(

                                      hint: const Text(
                                        'Select Item',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                      items: gender
                                          .map((item) =>
                                          DropdownMenuItem<String>(
                                            value: item,
                                            child: Text(
                                              item,
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black
                                              ),
                                            ),
                                          ))
                                          .toList(),
                                      value: valueGender,

                                      dropdownDecoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          valueGender = value as String;
                                        });
                                      },

                                      buttonHeight: 40,
                                      buttonWidth: 140,
                                      itemHeight: 40,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CustomTextField(
                              textInputType: TextInputType.number,
                              controller: ageController,
                              fieldValidator: (String value) {
                                if (value.isEmpty) {
                                  return "age is required";
                                } else if (regExp.hasMatch(value) == false) {
                                  return "number only";
                                } else if (int.parse(value) < 0 &&
                                    int.parse(value) < 100) {
                                  return "please enter valid age";
                                }
                              },
                              hint: 'Age',
                              iconData: Icons.date_range,
                            ),

                            const SizedBox(
                              height: 20,
                            ),

                            CustomTextField(
                              textInputType: TextInputType.phone,
                              controller: phoneController,
                              fieldValidator: phoneValidator,
                              hint: 'phone',
                              iconData: Icons.phone,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            // creat drop down button

                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
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

  //contains userName , email , password and password confirmation textfields

  //contains signup button and login text
  Widget loginAndSignup(SignupCubit myCubit, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 45.h,
        ),
        Center(
            child: BlocConsumer<SignupCubit, SignupState>(
              listener: (context, state) {
                // TODO: implement listener
                if(state is RegisterSuccessfulState){
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Create new Admin Successful'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  auth.ControllerCubit.get(context).getAdmin();
                  Navigator.pop(context);
                }else if(state is RegisterErrorState)
                {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                }else if(state is PhoneISNotUnique )
                {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("This Number Recorded in Database"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                return (state is RegisterLoadingState)? const Center(child: CircularProgressIndicator(),):
                CustomButtonOne(
                    buttonTitle: "Sign up",
                    onClick: () async{

                      if (formKey.currentState!.validate()) {
                        // send  data to function
                        myCubit.registerUser(email: emailController.text.trim()
                          ,
                          password: passwordController.text.trim(),
                          gender: valueGender,
                          role: '1',
                          age: ageController.text.trim(),
                          username: nameController.text.trim(),
                          phone: phoneController.text.trim(),
                        );
                      }
                    });
              },
            )),

      ],
    );
  }
}