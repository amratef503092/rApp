import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../constants/validator.dart';
import '../../../view_model/cubit/auth/auth_cubit.dart';
import '../../components/custom_button.dart';
import '../../components/custom_textfield.dart';

class EditUserInfo extends StatefulWidget {
  const EditUserInfo({Key? key}) : super(key: key);

  @override
  State<EditUserInfo> createState() => _EditUserInfoState();
}

GlobalKey<FormState> formKey = GlobalKey<FormState>();

class _EditUserInfoState extends State<EditUserInfo> {
  void initState() {
    // TODO: implement initState
    nameController.text = ControllerCubit.get(context).userModel!.name;
    phoneController.text = ControllerCubit.get(context).userModel!.phone;
    emailController.text = ControllerCubit.get(context).userModel!.email;
    genderController.text = ControllerCubit.get(context).userModel!.gender;
    ageController.text = ControllerCubit.get(context).userModel!.age.toString();

    super.initState();
  }

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController nameController = TextEditingController();

  TextEditingController ageController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController bloodType = TextEditingController();

  TextEditingController phoneController = TextEditingController();
  bool showPassword = false;
  bool enable = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ControllerCubit, AuthState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        var authCubit = ControllerCubit.get(context);

        return Scaffold(
          body: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: (state is GetUserDataLoadingState)
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 100.r,
                            backgroundImage: NetworkImage((authCubit
                                        .userModel!.photo ==
                                    '')
                                ? 'https://firebasestorage.googleapis.com/v0/b/pharmacy-f7702.appspot.com/o/images.jpg?alt=media&token=0aa2b534-e0cf-4ccc-814f-28c57a12d383'
                                : authCubit.userModel!.photo),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              (state is UploadImageStateLoading)
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : CustomButton(
                                      disable: true,
                                      size: Size(150.w, 40.h),
                                      widget: const Text("Select from gallery"),
                                      function: () {
                                        ControllerCubit.get(context)
                                            .pickImageGallary(context);
                                      },
                                    ),
                              (state is UploadImageStateLoading)
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : CustomButton(
                                      size: Size(150.w, 40.h),
                                      disable: true,
                                      widget: const Text("Select from camera"),
                                      function: () {
                                        ControllerCubit.get(context)
                                            .pickImageCamera(context);
                                      },
                                    ),
                            ],
                          ),
                          Form(
                            key: formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 20.h,
                                ),
                                CustomTextField(
                                  controller: emailController,
                                  fieldValidator: emailValidator,
                                  hint: 'email',
                                  iconData: Icons.email,
                                  enable: false,
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                CustomTextField(
                                  controller: nameController,
                                  fieldValidator: (String value) {
                                    if (value.trim().isEmpty || value == ' ') {
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
                                  enable: enable,
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                CustomTextField(
                                  textInputType: TextInputType.phone,
                                  controller: phoneController,
                                  fieldValidator: phoneValidator,
                                  hint: 'phone',
                                  iconData: Icons.phone,
                                  enable: enable,
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                CustomTextField(
                                  textInputType: TextInputType.phone,
                                  controller: genderController,
                                  fieldValidator: (String? value) {
                                    if (value!.isEmpty) {
                                      return "this Field is requried";
                                    }
                                  },
                                  hint: 'gender',
                                  iconData: FontAwesomeIcons.venusMars,
                                  enable: false,
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                CustomTextField(
                                  textInputType: TextInputType.number,
                                  controller: ageController,
                                  fieldValidator: (String? value) {
                                    if (value!.isEmpty) {
                                      return "this Field is requried";
                                    }
                                    if (int.parse(ageController.text) <= 0) {
                                      return "sorry Enter valid age";
                                    }
                                  },
                                  hint: 'age',
                                  iconData: FontAwesomeIcons.calendarDay,
                                  enable: enable,
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    (state is RegisterLoadingState)
                                        ? const Center(
                                            child: CircularProgressIndicator(),
                                          )
                                        : CustomButton(
                                            function: () {
                                              setState(() {
                                                enable = !enable;
                                              });
                                            },
                                            widget: const Text("Start Edit"),
                                            size: Size(150.w, 50.h),
                                            radius: 20.r,
                                            disable: !enable,
                                          ),
                                    (state is UpdateDataLoadingState)
                                        ? const Center(
                                            child: CircularProgressIndicator(),
                                          )
                                        : CustomButton(
                                            function: () {
                                              if (formKey.currentState!
                                                  .validate()) {
                                                ControllerCubit.get(context)
                                                    .update(
                                                        email: emailController
                                                            .text,
                                                        phone: phoneController
                                                            .text,
                                                        age: ageController.text,
                                                        name:
                                                            nameController.text)
                                                    .then((value) {})
                                                    .then((value) {
                                                  enable = false;
                                                });
                                              }
                                            },
                                            widget:
                                                const Text("confirm Update"),
                                            size: Size(150.w, 50.h),
                                            radius: 20.r,
                                            disable: enable,
                                          ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}
