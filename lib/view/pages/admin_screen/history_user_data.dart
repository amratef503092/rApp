import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p3/view/pages/admin_screen/treatment_user_info.dart';
import 'package:p3/view/pages/users/history_view_details.dart';

import '../../../view_model/cubit/auth/auth_cubit.dart';
import '../../components/custom_data_empty.dart';
import 'history_user_data.dart';

class UserHistoryTreatment extends StatefulWidget {
  UserHistoryTreatment({Key? key, required this.userId}) : super(key: key);
  String userId;

  @override
  State<UserHistoryTreatment> createState() => _UserHistoryTreatmentState();
}

class _UserHistoryTreatmentState extends State<UserHistoryTreatment> {
  @override
  void initState() {
    // TODO: implement initState
    ControllerCubit.get(context).getTreatmentHistoryOneUSerData(id: widget.userId);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [
          // IconButton(onPressed: ()
          // {
          //   Navigator.push(context, MaterialPageRoute(builder: (context) {
          //     return  UserHistoryTreatment(id: widget.userId);
          //
          //   },)) ;
          // }, icon: const Icon(Icons.history)),
        ],
        title: const Text('User Details'),
      ),
      body: BlocConsumer<ControllerCubit, AuthState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () async {
                    // NotificationApi.showNotification();
                    // await AndroidAlarmManager.periodic(const Duration(seconds: 2), 1, (){
                    //   print("Alarm");
                    // });

                    ControllerCubit.get(context).getTreatmentDataUser(userID: widget.userId);
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
              (ControllerCubit.get(context).getHistoryTreatment.isEmpty)
                  ? const DataEmptyWidget()
                  : Expanded(
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
                                    return treatMentUserInfo(
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
          );
        },
      ),
    );
  }
}
