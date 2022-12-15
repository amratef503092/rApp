import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:just_audio/just_audio.dart';
import 'package:meta/meta.dart';

import '../../view/pages/users/ViewDetailes.dart';
part 'notefication_assowme_state.dart';

class NoteficationAssowmeCubit extends Cubit<NoteficationAssowmeState> {
  NoteficationAssowmeCubit() : super(NoteficationAssowmeInitial());

  static NoteficationAssowmeCubit get(context) =>
      BlocProvider.of<NoteficationAssowmeCubit>(context);

  void oninit() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        // This is just a basic example. For real apps, you must show some
        // friendly dialog box before call the request method.
        // This is very important to not harm the user experience
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    emit(NoteficationAssowmeInitial());
  }

  AudioPlayer player = AudioPlayer();

  void notification(
      {required String title,
      required String body,
      required String sound,
      required String id,
      required int duration,
      required int idNotification}) {
    print("${idNotification} id Notificaion");
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: idNotification,
        channelKey: 'basic_channel',
        title: title,
        body: body,
         payload: {'id': id},
      ),
      schedule: NotificationInterval(
        interval: duration,

        preciseAlarm: true,
      ),
      actionButtons: [
        NotificationActionButton(
            color: Colors.redAccent,
            key: 'cancel',
            label: 'Cancel',
            actionType: ActionType.DismissAction),
        NotificationActionButton(
            key: "snooze", label: "Snooze", color: Colors.red)
      ],
    );
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: (ReceivedAction receivedAction) async {
      print("Action received");
      print(id);
      Get.to(() => ViewDetailes
        (
        id: receivedAction.payload!['id'].toString(),
          ));
      player.stop();
    }, onNotificationDisplayedMethod:
            (ReceivedNotification receivedNotification) async {
          print(receivedNotification.id);
          print(receivedNotification.payload);
      player.setFilePath(sound);
      player.play();
    }, onDismissActionReceivedMethod: (ReceivedAction receivedAction) async {
      player.stop();
      // AwesomeNotifications().cancel(receivedAction.id!);
    });
  }
}
