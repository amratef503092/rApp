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
import 'history_screen.dart';
import 'home_admin_screen.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'dart:io' as io;
class HomeUserScreen extends StatefulWidget {
  const HomeUserScreen({Key? key}) : super(key: key);

  @override
  State<HomeUserScreen> createState() => _HomeUserScreenState();
}

class _HomeUserScreenState extends State<HomeUserScreen> {
  @override
  void initState() {
    // TODO: implement initState
    ControllerCubit.get(context).getTreatmentData();
    ControllerCubit.get(context).getUserData();
    super.initState();
  }
  io.File ? file;
  AudioPlayer  player = AudioPlayer();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ControllerCubit, AuthState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Home User"),
            actions: [
              IconButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const HistoryScreen();
                },),);
              }, icon: Icon(Icons.history)),
            ],
          ),
          drawer: SafeArea(
            child: (ControllerCubit.get(context).userModel!=null)?Drawer(

              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(ControllerCubit.get(context).userModel!.photo),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            ControllerCubit.get(context).userModel!.name,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return const HomeAdminUserScreen();
                        },
                      ));
                    },
                    leading: const Icon(Icons.message),
                    title: const Text('Messages'),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return const EditUserInfo();
                        },
                      ));
                    },
                    leading: const Icon(Icons.account_circle),
                    title: const Text('settings'),
                  ),
                  // ListTile(
                  //   onTap: () {
                  //     Navigator.push(context, MaterialPageRoute(
                  //       builder: (context) {
                  //         return const SettingsScreen();
                  //       },
                  //     ));
                  //   },
                  //   leading: Icon(Icons.settings),
                  //   title: Text("settings"),
                  // ),
                  ListTile(
                    leading: Icon(Icons.logout),
                    onTap: () async{
                      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
                        'online':false,
                      });
                      await FirebaseAuth.instance.signOut();
                      CacheHelper.removeData(key: 'id');
                      CacheHelper.removeData(key: 'role');
                      ControllerCubit.get(context).userModel = null;
                      Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(
                        builder: (context) {
                          return  LoginPage();
                        },
                      ),(route) => false,);
                    },
                    title: Text('Logout'),
                  ),
                ],
              ),
            ):
            Center(child: CircularProgressIndicator(),)
            ,
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

                    ControllerCubit.get(context).getTreatmentData();
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

              (ControllerCubit.get(context).treatMentModel.isEmpty)?const DataEmptyWidget():Expanded(
                child: ListView.builder(
                  itemCount: ControllerCubit.get(context).treatMentModel.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image(
                            image: NetworkImage(ControllerCubit.get(context)
                                .treatMentModel[index]
                                .photo),
                            width: 100,
                            height: 100,
                          ),
                          Column(
                            children: [
                              Text(
                                "Name : ${ControllerCubit.get(context).treatMentModel[index].title}",
                                style: const TextStyle(fontSize: 20),
                              ),
                              Text(
                                "Amount :${ControllerCubit.get(context).treatMentModel[index].amount}",
                                style: const TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return ViewDetailes(
                                      id: ControllerCubit.get(context)
                                          .treatMentModel[index]
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
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return const AddTeratMentScreen();
                },
              ));
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
