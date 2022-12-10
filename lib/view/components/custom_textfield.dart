import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/color_manager.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField({
    required this.controller,
    required this.hint,
    this.password = false,
    this.passwordTwo = false,
    this.function,
    required this.fieldValidator,
    this.iconData,
    this.textInputType = TextInputType.text,
    this.enable = true,
    this.maxLine = 1,
    this.formate,
    Key? key,
  }) : super(key: key);
  final TextEditingController controller;
  final String hint;
  final bool password;
  final bool passwordTwo;
  final Function fieldValidator;
  final Function? function;
  final IconData? iconData;
  final TextInputType textInputType;
  final bool enable;
  final int maxLine;

  List<TextInputFormatter>? formate;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: formate,
      controller: controller,
      validator: (value) => fieldValidator(value),
      keyboardType: textInputType,
      enabled: enable,
      maxLines: maxLine,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
          icon: Icon(
            iconData,
            color: Colors.black,
          ),
          hintStyle: TextStyle(color: Colors.black, fontSize: 15.sp),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(10.r),
          ),
          errorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(40)),
              borderSide: BorderSide(color: ColorManage.redError)),
          enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(40)),
              borderSide: BorderSide(color: ColorManage.gray)),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(40)),
            borderSide: BorderSide(color: ColorManage.redError),
          ),
          hintText: hint,
          contentPadding: const EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 10),
          suffixIconConstraints: const BoxConstraints(maxHeight:20,),

          suffix: (passwordTwo)
              ? InkWell(
                  child: (password)
                      ? const Icon(
                          Icons.visibility_outlined,
                          color: Colors.white,
                        )
                      : const Icon(
                      Icons.visibility_off,
                      color: Colors.white
                  ),
                  onTap: () {
                    function!();
                  },
                )
              : const SizedBox()
      ),
      obscureText: password,
    );
  }
}
