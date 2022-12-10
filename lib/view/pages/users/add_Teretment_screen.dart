import 'dart:io' as io;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../view_model/cubit/auth/auth_cubit.dart';
import '../../../view_model/notification_as/notefication_assowme_cubit.dart';
import '../../components/custom_button.dart';
import '../../components/custom_text_field.dart';

class AddTeratMentScreen extends StatefulWidget {
  const AddTeratMentScreen({Key? key}) : super(key: key);

  @override
  State<AddTeratMentScreen> createState() => _AddTeratMentScreenState();
}

class _AddTeratMentScreenState extends State<AddTeratMentScreen> {
  @override
  TextEditingController titleController = TextEditingController();
  TextEditingController amoutController = TextEditingController();
  TextEditingController durationPerDay = TextEditingController();

  TextEditingController timeOfToke = TextEditingController();
  DateTimeRange? selectedTime;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void dispose() {

    // TODO: implement dispose
    titleController.dispose();
    amoutController.dispose();
    durationPerDay.dispose();
    timeOfToke.dispose();
    super.dispose();
  }
  Widget build(BuildContext context) {
    return BlocConsumer<ControllerCubit, AuthState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is CreateTreatmentStateSuccessful) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Treatment Added Successfully")));
          ControllerCubit.get(context).getTreatmentData();
          notivication(
            idNotification:Random().nextInt(10000),
            id: state.id,
            durationPerDay: durationPerDay,
            timeOfToke: timeOfToke,
            title: "Please Take Your Treatment now",
            body: titleController.text,
            sound: ControllerCubit.get(context).file!.path,
          );
          ControllerCubit.get(context).baseName = '';
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            ControllerCubit.get(context).baseName = null;
            ControllerCubit.get(context).file = null;


            return true;
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text("Add Treatment"),
            ),
            body: ModalProgressHUD(
              inAsyncCall: state is CreateTreatmentStateLoading ||
                  state is UploadImageStateLoading,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        (ControllerCubit.get(context).imageTreatment != null)
                            ? CircleAvatar(
                                radius: 100,
                                backgroundImage: FileImage(io.File(
                                    ControllerCubit.get(context).imageTreatment!.path)),
                              )
                            : const CircleAvatar(
                                radius: 100,
                                backgroundImage: NetworkImage(
                                    "https://th.bing.com/th/id/R.f37c0c9a8c2962226f64970e6964047f?rik=SvYazgPg%2bR6EIQ&pid=ImgRaw&r=0")),
                        SizedBox(
                          height: 20.h,
                        ),
                        BlocConsumer<ControllerCubit, AuthState>(
                          listener: (context, state) {
                            // TODO: implement listener
                          },
                          builder: (context, state) {
                            return Row(
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
                                              .pickImageGallaryTreatment(context);
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
                                              .pickImageCameraTreatment(context);
                                        },
                                      ),
                              ],
                            );
                          },
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        CustomButton(
                            disable: true,
                            widget: const Text("Pick Sound Please "),
                            function: () {
                              ControllerCubit.get(context).pickSound();
                              setState(() {});
                            }),
                        SizedBox(
                          height: 20.h,
                        ),
                        (ControllerCubit.get(context).file != null)
                            ? Text(ControllerCubit.get(context).baseName.toString())
                            : const Text("No Sound Selected"),
                        SizedBox(
                          height: 20.h,
                        ),
                        CustomTextField(
                            controller: titleController,
                            hint: 'Name Treatment',
                            iconData: Icons.medical_services,
                            fieldValidator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your name treatment';
                              }
                              return null;
                            }),
                        CustomTextField(
                            controller: amoutController,
                            textInputType: TextInputType.number,
                            hint: 'Amount',
                            iconData: Icons.timelapse,
                            fieldValidator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter Amount';
                              }
                              return null;
                            }),
                        const SizedBox(
                          height: 10,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextField(
                            textInputType: TextInputType.number,
                            controller: durationPerDay,
                            hint: 'duration between treatments',
                            iconData: Icons.timelapse,
                            fieldValidator: (value) {
                              if (value!.isEmpty) {
                                return 'times_per_day';
                              }
                              return null;
                            }),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              if(ControllerCubit.get(context).imageTreatment == null){
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Please select Image"),  backgroundColor: Colors.red,) );
                              }
                              if(ControllerCubit.get(context).file == null){
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Please select sound"),  backgroundColor: Colors.red,) );
                              }
                              if (formKey.currentState!.validate() &&
                                  ControllerCubit.get(context).file != null) {
                                ControllerCubit.get(context).uploadFileTreatment(
                                  title: titleController.text,
                                  file: ControllerCubit.get(context).imageTreatment!,
                                  amount: int.parse(amoutController.text),
                                  context: context,
                                  duration: int.parse(durationPerDay.text),
                                );
                              }
                            },
                            child: const Text('Confirm')),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // void notivication({required String title, required String body ,
  //   required  TextEditingController durationPerDay,
  //   required  TextEditingController timeOfToke,
  //   required String id
  // }) {
  //   durationPerDay; // فتره بين الدواء و التاني; // عدد الدواء
  //   // الوقت الي هياخد في الدواء
  //
  //   print(durationPerDay);
  //   // الوقت الي هياخد في الدواء
  //   NotificationApi.ScheduleNotification
  //     (
  //       title: title,
  //       body: body,
  //       dateTime: DateTime.now().add(Duration(seconds: int.parse(durationPerDay.text))),
  //     payload: id,
  //   );
  //
  // }
  void notivication(
      {required String title,
      required String sound,
      required String body,
      required int idNotification,
      required TextEditingController durationPerDay,
      required TextEditingController timeOfToke,
      required String id}) {
    durationPerDay; // فتره بين الدواء و التاني; // عدد الدواء
    // الوقت الي هياخد في الدواء
    // void test(AudioPlayer player , String title , String body , String url , String sound , String id) {
    // titleController.text,
    // 'Please Take Treatment',
    //
    // sound,
    // id,
    NoteficationAssowmeCubit.get(context).notification(
      id: id,
      title: title,
      body: body,
      duration: int.parse(durationPerDay.text),
      idNotification: idNotification,
      sound: sound,
    );
    // AwesomeNotifications().createNotification(
    //   content: NotificationContent(
    //     id: 1,
    //     channelKey: 'basic_channel',
    //     title: 'Treatment Reminder',
    //     body: 'You have a treatment at 10:00 AM',
    //   ),
    //   schedule: NotificationInterval(
    //     interval: 5,
    //     preciseAlarm: true,
    //   ),
    //   actionButtons: [
    //     NotificationActionButton(
    //         color: Colors.redAccent,
    //         key: 'cancel',
    //         label: 'Cancel',
    //         actionType: ActionType.DismissAction),
    //     NotificationActionButton(
    //         key: "snooze", label: "Snooze", color: Colors.red)
    //   ],
    // );
    // AwesomeNotifications().setListeners(
    //     onActionReceivedMethod: (ReceivedAction receivedAction) async {
    //   print("Action received");
    //   player.stop();
    // }, onNotificationDisplayedMethod:
    //         (ReceivedNotification receivedNotification) async {
    //           player.setFilePath('/data/user/0/com.example.p3/cache/file_picker/AUD-20221130-WA0047.opus');
    //   player.play();
    // }, onDismissActionReceivedMethod: (ReceivedAction receivedAction) async {
    //   player.stop();
    //   AwesomeNotifications().cancel(receivedAction.id!);
    // });
    print(durationPerDay);
    // الوقت الي هياخد في الدواء
    // NotificationApi.ScheduleNotification(
    //   title: title,
    //   body: body,
    //   dateTime:
    //       DateTime.now().add(Duration(seconds: int.parse(durationPerDay.text))),
    //   payload: id,
    // );
  }
}
