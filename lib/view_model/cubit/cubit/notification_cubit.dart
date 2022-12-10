// import 'package:bloc/bloc.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:meta/meta.dart';
// import 'package:p3/view/pages/users/ViewDetailes.dart';
//
// import '../../../view/pages/users/add_Teretment_screen.dart';
// import '../../notefication.dart';
// import 'package:flutter/material.dart';
//
// part 'notification_state.dart';
//
// class NotificationCubit extends Cubit<NotificationState> {
//   NotificationCubit() : super(NotificationInitial());
//
//   void oninit() {
//     NotificationApi.init(initScdeuled: true);
//     listenNotification();
//     emit(NotificationInitial());
//   }
//
//   void listenNotification() {
//     NotificationApi.onNotification.stream.listen((event) {
//
//     });
//     NotificationApi.onNotification.stream.listen(onClickeNotification);
//   }
//
//   void onClickeNotification(String? payload) {
//     print('payload $payload');
//     Get.to( ViewDetailes(id: payload.toString()));
//   }
// }
