// import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:p3/database/local/cache_helper.dart';
import 'package:p3/view/components/custom_data_empty.dart';
import 'package:p3/view/pages/users/SettingsScreen.dart';
import 'package:p3/view_model/cubit/auth/auth_cubit.dart';
import '../../../view_model/notefication.dart';
import '../auth/login_screen/login_screen.dart';
import 'Edit_Info.dart';
import 'ViewDetailes.dart';
import 'add_Teretment_screen.dart';
import 'history_view_details.dart';
import 'home_admin_screen.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'dart:io' as io;
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    // TODO: implement initState
    ControllerCubit.get(context).getTreatmentHistoryData();
    ControllerCubit.get(context).getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ControllerCubit, AuthState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("History User"),
          ),
          body: Column(
            children: [

              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () async{
                    // NotificationApi.showNotification();
                    // await AndroidAlarmManager.periodic(const Duration(seconds: 2), 1, (){
                    //   print("Alarm");
                    // });

                    ControllerCubit.get(context).getTreatmentHistoryData();
                    // NotificationApi.ScheduleNotification(
                    //   title: "title",
                    //   body: "body",
                    //   dateTime: DateTime.now()
                    //       .add(const Duration(seconds: 2)), // id medicine
                    //   payload: "5vNuzTcEDWWsjGIcJ1yM",
                    // );
                  },
                ),
              ),

              (ControllerCubit.get(context).getHistoryTreatment.isEmpty)?const DataEmptyWidget():Expanded(
                child: ListView.builder(
                  itemCount: ControllerCubit.get(context).getHistoryTreatment.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image(
                            image: NetworkImage(ControllerCubit.get(context)
                                .getHistoryTreatment[index]
                                .photo),
                            width: 100,
                            height: 100,
                          ),
                          Column(
                            children: [
                              Text(
                                "Name : ${ControllerCubit.get(context).getHistoryTreatment[index].title}",
                                style: const TextStyle(fontSize: 20),
                              ),
                              Text(
                                "Amount :${ControllerCubit.get(context).getHistoryTreatment[index].amount}",
                                style: const TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return History_View_details(
                                      id: ControllerCubit.get(context)
                                          .getHistoryTreatment[index]
                                          .id,
                                    );
                                  },
                                ));
                              },
                              child: const Text("View Details")),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
