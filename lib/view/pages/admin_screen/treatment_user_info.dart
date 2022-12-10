import 'dart:io' as io;
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:p3/view_model/cubit/auth/auth_cubit.dart';
import 'package:p3/view_model/notification_as/notefication_assowme_cubit.dart';

import '../../components/custom_button.dart';
import '../../components/custom_text_field.dart';

class treatMentUserInfo extends StatefulWidget {
  treatMentUserInfo({Key? key, required this.id}) : super(key: key);
  String id;

  @override
  State<treatMentUserInfo> createState() => _treatMentUserInfoState();
}
class _treatMentUserInfoState extends State<treatMentUserInfo> {
  @override
  TextEditingController titleController = TextEditingController();
  TextEditingController amoutController = TextEditingController();
  TextEditingController durationPerDay = TextEditingController();
  TextEditingController timeOfToke = TextEditingController();
  DateTimeRange? selectedTime;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  DateTime? lastTime;

  @override
  void initState() {
    // TODO: implement initState

    init();
    super.initState();
  }

  void init() async {
    await ControllerCubit.get(context).getDataTreatments(id: widget.id);
    titleController.text = ControllerCubit.get(context).treatMentModelOne!.title;
    amoutController.text =
        ControllerCubit.get(context).treatMentModelOne!.amount.toString();
    durationPerDay.text =
        ControllerCubit.get(context).treatMentModelOne!.duration.toString();
    timeOfToke.text =
        ControllerCubit.get(context).treatMentModelOne!.times_of_took.toString();
    lastTime =
        DateTime.parse(ControllerCubit.get(context).treatMentModelOne!.lastTimeTake);
    print(ControllerCubit.get(context).treatMentModelOne!.nameSound);
  }

  bool isEdit = false;
  int x = 0;
  io.File? file;
  AudioPlayer player = AudioPlayer();
  int random = Random().nextInt(10000);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ControllerCubit, AuthState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is DeleteTreatmentStateSuccessful) {
          ControllerCubit.get(context).getTreatmentData();

          Navigator.pop(context);
        }
        if (state is CreateTreatmentStateSuccessful) {
          ControllerCubit.get(context).getTreatmentData();
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Treatment Added Successfully")));
          Navigator.pop(context);

          ControllerCubit.get(context).getTreatmentData();
        }
        if (state is updateTreatmentSuccessful) {
          notivication(
            sound: ControllerCubit.get(context).treatMentModelOne!.nameSound,
            id: ControllerCubit.get(context).treatMentModelOne!.id,
            durationPerDay: durationPerDay,
            timeOfToke: timeOfToke,
            idNotification: random,
            title: "Please Take Your Treatment now",
            body: titleController.text,
          );
          ControllerCubit.get(context).getTreatmentData();
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return (ControllerCubit.get(context).treatMentModelOne != null)
            ? Scaffold(
          appBar: AppBar(
            title: const Text("Treatment info"),
            actions: [
              // IconButton(
              //     onPressed: ()
              //     {
              //       // AuthCubit.get(context).deleteTreateMent(widget.id);
              //     },
              //     icon: const Icon(Icons.delete))
            ],
          ),
          body: ModalProgressHUD(
            inAsyncCall: state is GetDataTreatmentStateLoading ||
                state is UploadImageStateLoading,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
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
                            ControllerCubit.get(context)
                                .imageTreatment!
                                .path)),
                      )
                          : CircleAvatar(
                          radius: 100,
                          backgroundImage: NetworkImage(
                              ControllerCubit.get(context)
                                  .treatMentModelOne!
                                  .photo)),
                      SizedBox(
                        height: 20.h,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      CustomTextField(
                          enable: isEdit,
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
                          enable: isEdit,
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
                          enable: isEdit,
                          textInputType: TextInputType.number,
                          controller: durationPerDay,
                          hint: 'Time per days',
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
                      // ElevatedButton(
                      //     onPressed: () {
                      //       if (formKey.currentState!.validate()) {
                      //         AuthCubit.get(context).uploadFileTreatment(
                      //           duration: int.parse(durationPerDay.text),
                      //           title: titleController.text,
                      //           file: AuthCubit.get(context).imageTreatment!,
                      //           amount: int.parse(amoutController.text),
                      //           context: context,
                      //           timesPerDay: int.parse(timeperdays.text),
                      //         );
                      //       }
                      //     },
                      //     child: const Text('Confirm')),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //   children: [
                      //     CustomButton(
                      //       disable: !isEdit,
                      //       size: Size(150.w, 40.h),
                      //       widget: const Text("Start Edit"),
                      //       function: () {
                      //         setState(() {
                      //           isEdit = true;
                      //         });
                      //       },
                      //     ),
                      //     CustomButton(
                      //       size: Size(150.w, 40.h),
                      //       disable: isEdit,
                      //       widget: const Text("Confirm Edit"),
                      //       function: () {
                      //         setState(() {
                      //           isEdit = false;
                      //         });
                      //         if (formKey.currentState!.validate()) {
                      //           AuthCubit.get(context)
                      //               .UpdatecreateTreatment(
                      //             id: AuthCubit.get(context)
                      //                 .treatMentModelOne!
                      //                 .id,
                      //             title: titleController.text,
                      //             amount: int.parse(amoutController.text),
                      //             context: context,
                      //             duration:
                      //                 int.parse(durationPerDay.text),
                      //           );
                      //         }
                      //       },
                      //     ),
                      //   ],
                      // ),
                      SizedBox(
                        height: 20.h,
                      ),
                      // ElevatedButton(
                      //     onPressed: () async{
                      //      print(DateTime.now()
                      //          .difference(lastTime!)
                      //          .inMinutes);
                      //      print(int.parse(durationPerDay.text));
                      //      print(DateTime.now()
                      //          .difference(lastTime!)
                      //          .inMinutes >=
                      //          int.parse(durationPerDay.text));
                      //     },
                      //     child: const Text("Amr")),
                      // ElevatedButton(
                      //     onPressed: () {
                      //       print(durationPerDay.text);
                      //       print(DateTime.now().difference(lastTime!));
                      //       print(DateTime.now()
                      //               .difference(lastTime!)
                      //               .inSeconds >=
                      //           int.parse(durationPerDay.text));
                      //     },
                      //     child: Text("")),
                      // (AuthCubit.get(context).treatMentModelOne!.amount ==
                      //     0)
                      //     ? const SizedBox()
                      //     : CustomButton(
                      //     size: Size(150.w, 40.h),
                      //     disable: DateTime.now()
                      //         .difference(lastTime!)
                      //         .inSeconds >=
                      //         int.parse(durationPerDay.text),
                      //     widget: const Text("Take Medicine"),
                      //     function: () async {
                      //       await FirebaseFirestore.instance
                      //           .collection('treatments')
                      //           .doc(AuthCubit.get(context)
                      //           .treatMentModelOne!
                      //           .id)
                      //           .update({
                      //         'amount':
                      //         int.parse(amoutController.text) - 1,
                      //         'lastTimeTake':
                      //         DateTime.now().toString(),
                      //       });
                      //       print(Random().nextInt(10000).toString()+ "dasdasd");
                      //       if (int.parse(amoutController.text) > 1) {
                      //         notivication(
                      //           idNotification:
                      //           Random().nextInt(10000),
                      //           sound: AuthCubit.get(context)
                      //               .treatMentModelOne!
                      //               .nameSound,
                      //           title: 'Take Medicine',
                      //           body: 'You have to take medicine now',
                      //           id: widget.id,
                      //           durationPerDay: durationPerDay,
                      //           timeOfToke: timeOfToke,
                      //         );
                      //       }
                      //
                      //       setState(() {
                      //         int.parse(amoutController.text) - 1;
                      //       });
                      //
                      //     }),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
            : const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  show() {
    print("Amr");
  }

  void notivication(
      {required String title,
        required String sound,
        required String body,
        required TextEditingController durationPerDay,
        required TextEditingController timeOfToke,
        required int idNotification,
        required String id}) {
    durationPerDay; // فتره بين الدواء و التاني; // عدد الدواء
    // الوقت الي هياخد في الدواء
    // void test(AudioPlayer player , String title , String body , String url , String sound , String id) {
    NoteficationAssowmeCubit.get(context).notification(
      sound: sound,
      title: title,
      body: body,
      id: id,
      duration: int.parse(durationPerDay.text),
      idNotification: idNotification,
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
