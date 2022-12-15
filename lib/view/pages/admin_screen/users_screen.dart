import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:p3/view/pages/admin_screen/view_detilsScreen.dart';
import 'package:p3/view/pages/chat.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../view_model/cubit/auth/auth_cubit.dart';
import '../../components/custom_data_empty.dart';

class CustomerScreenAdmin extends StatefulWidget {
  const CustomerScreenAdmin({Key? key}) : super(key: key);

  @override
  State<CustomerScreenAdmin> createState() => _CustomerScreenAdminState();
}

class _CustomerScreenAdminState extends State<CustomerScreenAdmin> {
  @override
  void initState() {
    // TODO: implement initState
    ControllerCubit.get(context).getCustomerUSer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ControllerCubit, AuthState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        // print(userID.toString()+ "from sql");

        var authCubit = ControllerCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: const Text("Users"),
          ),
          body: (state is GetAllUsersLoadnig)
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: (ControllerCubit.get(context).userModel == null)
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : (authCubit.userModelList.isEmpty)
                          ? Column(
                              children: [
                                Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                      onPressed: () {
                                        ControllerCubit.get(context)
                                            .getCustomerUSer();
                                      },
                                      icon: const Icon(
                                        Icons.refresh,
                                        color: Colors.black,
                                      ),
                                    )),
                                const Center(
                                  child: Text("No User Found"),
                                )
                              ],
                            )
                          : Column(
                              children: [
                                Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                      onPressed: () {
                                        authCubit.getCustomerUSer();
                                      },
                                      icon: const Icon(
                                        Icons.refresh,
                                        color: Colors.black,
                                      ),
                                    )),
                                Expanded(
                                  child: (authCubit.userModelList.isEmpty)
                                      ? const DataEmptyWidget()
                                      : ListView.builder(
                                          itemCount:
                                              authCubit.userModelList.length,
                                          itemBuilder: (context, index) {
                                            if (!authCubit
                                                .userModelList[index].ban) {
                                              return Card(
                                                borderOnForeground: true,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => ShowUserDetilesScreen(
                                                                    userId: authCubit
                                                                        .userModelList[
                                                                            index]
                                                                        .id)));
                                                      },
                                                      child: Row(
                                                        children: [
                                                          CircleAvatar(
                                                            backgroundImage:
                                                                NetworkImage(authCubit
                                                                    .userModelList[
                                                                        index]
                                                                    .photo
                                                                    .toString()),
                                                            radius: 30,
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "Name : ${authCubit.userModelList[index].name}",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                              Text(
                                                                  "Phone : ${authCubit.userModelList[index].phone}",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15.sp,
                                                                      color: Colors
                                                                          .black)),
                                                              authCubit
                                                                      .userModelList[
                                                                          index]
                                                                      .online
                                                                  ? Row(
                                                                      children: const [
                                                                        Text(
                                                                          "Status : ",
                                                                          style:
                                                                              TextStyle(color: Colors.black),
                                                                        ),
                                                                        Text(
                                                                          "online",
                                                                          style:
                                                                              TextStyle(color: Colors.green),
                                                                        )
                                                                      ],
                                                                    )
                                                                  : Row(
                                                                      children: const [
                                                                        Text(
                                                                            "Status : ",
                                                                            style:
                                                                                TextStyle(color: Colors.black)),
                                                                        Text(
                                                                          "offline",
                                                                          style:
                                                                              TextStyle(color: Colors.red),
                                                                        )
                                                                      ],
                                                                    ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    IconButton(
                                                        onPressed: () {
                                                          showDialog(
                                                            context: context,
                                                            builder: (ctx) =>
                                                                AlertDialog(
                                                              title: const Text(
                                                                  "You want Delete Account ?"),
                                                              content: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: const [
                                                                  Text(
                                                                      "If You click ok you will Ban this Account")
                                                                ],
                                                              ),
                                                              actions: <Widget>[
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            ctx)
                                                                        .pop();
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            14),
                                                                    child: const Text(
                                                                        "Cancel"),
                                                                  ),
                                                                ),
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'users')
                                                                        .doc(ControllerCubit.get(context)
                                                                            .userModelList[
                                                                                index]
                                                                            .id)
                                                                        .update({
                                                                      'ban':
                                                                          true
                                                                    }).then((value) {
                                                                      Navigator.of(
                                                                              ctx)
                                                                          .pop();
                                                                      ControllerCubit.get(
                                                                              context)
                                                                          .getCustomerUSer();
                                                                      setState(
                                                                          () {});
                                                                    });
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            14),
                                                                    child:
                                                                        const Text(
                                                                            "Ok"),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                        icon: const FaIcon(
                                                          FontAwesomeIcons.ban,
                                                          color: Colors.red,
                                                        )),

                                                    IconButton(
                                                        onPressed: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                            builder: (context) {
                                                              return ChatScreen(
                                                                receiverId: authCubit
                                                                    .userModelList[
                                                                        index]
                                                                    .id,
                                                                receiverName:
                                                                    authCubit
                                                                        .userModelList[
                                                                            index]
                                                                        .name,
                                                                adminID:
                                                                    FirebaseAuth
                                                                        .instance
                                                                        .currentUser!
                                                                        .uid,
                                                                userID: authCubit
                                                                    .userModelList[
                                                                        index]
                                                                    .id,
                                                              );
                                                            },
                                                          ));
                                                        },
                                                        icon: const FaIcon(
                                                          FontAwesomeIcons
                                                              .message,
                                                          color: Colors.black,
                                                        )),
                                                    IconButton(
                                                        onPressed: () {
                                                          _launchInBrowser(Uri(
                                                              scheme: 'https',
                                                              host: 'wa.me',
                                                              path:
                                                                  "+${authCubit.adminData[index].phone}"));
                                                        },
                                                        icon: const FaIcon(
                                                          FontAwesomeIcons
                                                              .whatsapp,
                                                          color: Colors.black,
                                                        )),
                                                    // IconButton(
                                                    //     onPressed: () {
                                                    //       LayoutCubit.get(context)
                                                    //           .x(authCubit
                                                    //           .userModelList[
                                                    //       index]);
                                                    //
                                                    //       Navigator.push(context,
                                                    //           MaterialPageRoute(
                                                    //             builder: (context) {
                                                    //               return LayOutUserPharmacy(
                                                    //                 pahrmacyModel: authCubit
                                                    //                     .userModelList[
                                                    //                 index],
                                                    //               );
                                                    //             },
                                                    //           ));
                                                    //     },
                                                    //     icon: FaIcon(
                                                    //       FontAwesomeIcons.shop,
                                                    //     ))
                                                  ],
                                                ),
                                              );
                                            } else {
                                              return Card(
                                                child: Stack(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        CircleAvatar(
                                                          backgroundImage:
                                                              NetworkImage(authCubit
                                                                  .userModelList[
                                                                      index]
                                                                  .photo
                                                                  .toString()),
                                                          radius: 40,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              "Name : ${authCubit.userModelList[index].name}",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      15.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                            Text(
                                                                "Phone : ${authCubit.userModelList[index].phone}",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15.sp,
                                                                    color: Colors
                                                                        .black)),
                                                            authCubit
                                                                    .userModelList[
                                                                        index]
                                                                    .online
                                                                ? Row(
                                                                    children: const [
                                                                      Text(
                                                                        "Status : ",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                      Text(
                                                                        "online",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.green),
                                                                      )
                                                                    ],
                                                                  )
                                                                : Row(
                                                                    children: const [
                                                                      Text(
                                                                          "Status : ",
                                                                          style:
                                                                              TextStyle(color: Colors.black)),
                                                                      Text(
                                                                        "offline",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.red),
                                                                      )
                                                                    ],
                                                                  ),
                                                          ],
                                                        ),
                                                        // TextButton(
                                                        //   onPressed: () {
                                                        //     FirebaseFirestore.instance
                                                        //         .collection('users')
                                                        //         .doc(AuthCubit.get(
                                                        //         context)
                                                        //         .adminData[index]
                                                        //         .id)
                                                        //         .update({
                                                        //       'ban': true
                                                        //     }).then((value) {
                                                        //
                                                        //       Navigator.of(context).pop();
                                                        //       AuthCubit.get(context).getAdmin();
                                                        //       setState(() {});
                                                        //     });
                                                        //   },
                                                        //   child: Container(
                                                        //     padding:
                                                        //     const EdgeInsets.all(
                                                        //         14),
                                                        //     child: const Text("Ok"),
                                                        //   ),
                                                        // ),
                                                      ],
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (ctx) =>
                                                              AlertDialog(
                                                            title: const Text(
                                                                "You want Remove Ban Account ?"),
                                                            content: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: const [
                                                                Text(
                                                                    "If You click ok you will Remove Ban From this Account ? ")
                                                              ],
                                                            ),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          ctx)
                                                                      .pop();
                                                                },
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(14),
                                                                  child: const Text(
                                                                      "Cancel"),
                                                                ),
                                                              ),
                                                              TextButton(
                                                                onPressed: () {
                                                                  FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'users')
                                                                      .doc(ControllerCubit.get(
                                                                              context)
                                                                          .userModelList[
                                                                              index]
                                                                          .id)
                                                                      .update({
                                                                    'ban': false
                                                                  }).then((value) {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                    ControllerCubit.get(
                                                                            context)
                                                                        .getCustomerUSer();
                                                                  });
                                                                },
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(14),
                                                                  child:
                                                                      const Text(
                                                                          "Ok"),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                      child: Container(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        height: 100.h,
                                                        color: Colors.black
                                                            .withOpacity(0.5),
                                                        child: Center(
                                                          child: Text(
                                                            "Banned",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize:
                                                                    30.sp),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }
                                          }),
                                ),
                              ],
                            )),
        );
      },
    );
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }
}
