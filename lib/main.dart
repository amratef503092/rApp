import 'dart:isolate';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:p3/database/local/cache_helper.dart';
import 'package:p3/view/pages/admin_screen/home_admin_screen.dart';
import 'package:p3/view/pages/auth/login_screen/login_screen.dart';
import 'package:p3/view/pages/users/hoem_user_screen.dart';
import 'package:p3/view_model/cubit/auth/auth_cubit.dart';
import 'package:p3/view_model/cubit/cubit/notification_cubit.dart';
import 'package:p3/view_model/cubit/login/login_cubit.dart';
import 'package:p3/view_model/cubit/signup/signup_cubit.dart';
import 'package:p3/view_model/notification_as/notefication_assowme_cubit.dart';

import 'constants/blocObserver.dart';
import 'database/network/dio_helper.dart';
import 'firebase_options.dart';
// import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

void printHello() {
  final DateTime now = DateTime.now();
  final int isolateId = Isolate.current.hashCode;
  print("[$now] Hello, world! isolate=$isolateId function='$printHello'");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await AndroidAlarmManager.initialize();
 await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: const Color(0xFF9D50DD),
            enableLights: true,
            importance: NotificationImportance.High,
            playSound: true,
            ledColor: Colors.yellow)
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'basic_channel_group',
            channelGroupName: 'Basic group'),
      ],
      debug: false
  );
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  await DioHelper.init();
  await CacheHelper.init();
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
  final int helloAlarmID = 0;
  // await AndroidAlarmManager.periodic(
  //     const Duration(minutes: 1), helloAlarmID, printHello);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => LoginCubit(),
            ),
            BlocProvider(
              create: (context) => SignupCubit(),
            ),
            BlocProvider(create: (context) =>
            ControllerCubit()
              ..getUserData()),
            BlocProvider(create: (context) =>
            NoteficationAssowmeCubit()
              ..oninit()),

          ],
          child: BlocConsumer<NoteficationAssowmeCubit, NoteficationAssowmeState>(
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, state) {
              return GetMaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Flutter Demo',
                home: (CacheHelper.get(key: 'id') != null) ? (CacheHelper.get(
                    key: 'role') == "1")
                    ? const HomeAdminScreen()
                    : const HomeUserScreen() : LoginPage(),

              );
            },
          ),
        );
      },
    );
  }
}
