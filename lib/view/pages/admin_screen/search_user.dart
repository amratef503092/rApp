import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:p3/model/user_model/user.dart';
import 'package:p3/view/components/custom_text_field.dart';
import 'package:p3/view_model/cubit/auth/auth_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

import '../chat.dart';


class FiltartionByFilmName extends StatefulWidget {
  FiltartionByFilmName({
    Key? key,
  }) : super(key: key);

  @override
  State<FiltartionByFilmName> createState() => _FiltartionByFilmNameState();
}

class _FiltartionByFilmNameState extends State<FiltartionByFilmName> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  TextEditingController searchController = TextEditingController();

  String name = '';
  List<UserModel>searchModel = [];
  Widget build(BuildContext context) {
    return BlocConsumer<ControllerCubit, AuthState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        ControllerCubit myCubit = ControllerCubit.get(context);

        return Scaffold(
          appBar:   AppBar(
            backgroundColor: Colors.blueAccent,
            title: Text('Search User',style: GoogleFonts.roboto(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.w700),),
            centerTitle: true,
          ),
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(

                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  TextFormField(
                    onChanged: (value) {
                      setState(() {
                        name = value;
                      });
                    },
                    style: GoogleFonts.roboto(
                        color: Colors.black,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700),
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: GoogleFonts.roboto(
                          color: Colors.black,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.blueAccent),
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blueAccent),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream:
                    FirebaseFirestore.instance.collection('users').where('role' ,isEqualTo: '3').snapshots(),
                    builder: (context, snapshots) {

                      if(snapshots.connectionState == ConnectionState.waiting){
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }else {
                        return Expanded(
                          child: ListView.builder(
                              itemCount: snapshots.data!.docs.length,
                              itemBuilder: (context, index) {
                                List<UserModel> userModelList = [];
                                for (var element in snapshots.data!.docs) {
                                  userModelList.add(UserModel.fromMap(
                                      element.data() as Map<String, dynamic>));
                                }
                                if (name.isEmpty) {
                                  if (!userModelList[index].ban)
                                  {
                                    return Card(
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceAround,
                                        children: [
                                          CircleAvatar(
                                            backgroundImage:
                                            NetworkImage(userModelList[
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
                                                "Name : ${userModelList[index].name}",
                                                style: TextStyle(
                                                    fontSize: 15.sp,
                                                    fontWeight:
                                                    FontWeight
                                                        .bold,
                                                    color:
                                                    Colors.black),
                                              ),
                                              Text(
                                                  "Phone : ${userModelList[index].phone}",
                                                  style: TextStyle(
                                                      fontSize: 15.sp,
                                                      color: Colors
                                                          .black)),
                                            userModelList[
                                              index]
                                                  .online
                                                  ? Row(
                                                children: const [
                                                  Text(
                                                    "Status : ",
                                                    style: TextStyle(
                                                        color: Colors
                                                            .black),
                                                  ),
                                                  Text(
                                                    "online",
                                                    style: TextStyle(
                                                        color: Colors
                                                            .green),
                                                  )
                                                ],
                                              )
                                                  : Row(
                                                children: const [
                                                  Text(
                                                      "Status : ",
                                                      style: TextStyle(
                                                          color:
                                                          Colors.black)),
                                                  Text(
                                                    "offline",
                                                    style: TextStyle(
                                                        color: Colors
                                                            .red),
                                                  )
                                                ],
                                              ),
                                            ],
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
                                              onPressed: ()
                                              {
                                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                  return ChatScreen
                                                    (
                                                    receiverId: userModelList[index].id,
                                                    receiverName: userModelList[index].name,
                                                    cinema: true,
                                                    cinemaID: FirebaseAuth.instance.currentUser!.uid,
                                                    userID:  userModelList[index].id,);
                                                },));
                                              },
                                              icon: const FaIcon(
                                                FontAwesomeIcons.message,

                                                color: Colors.black,
                                              )),
                                          IconButton(
                                              onPressed: () {
                                                _launchInBrowser(Uri(
                                                    scheme: 'https',
                                                    host: 'wa.me',
                                                    path:
                                                    "+${userModelList[index].phone}"));
                                              },
                                              icon: const FaIcon(
                                                FontAwesomeIcons.whatsapp,

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
                                                NetworkImage(userModelList[
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
                                                    "Name : ${userModelList[index].name}",
                                                    style: TextStyle(
                                                        fontSize: 15.sp,
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        color:
                                                        Colors.black),
                                                  ),
                                                  Text(
                                                      "Phone : ${userModelList[index].phone}",
                                                      style: TextStyle(
                                                          fontSize: 15.sp,
                                                          color: Colors
                                                              .black)),
                                                 userModelList[
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

                                } else if (userModelList[index]                                                                                                             .name
                                    .toString()
                                    .toLowerCase()
                                    .contains(name.toLowerCase()))
                                {
                                  if (!userModelList[index].ban) {
                                    return Card(
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceAround,
                                        children: [
                                          CircleAvatar(
                                            backgroundImage:
                                            NetworkImage(userModelList[
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
                                                "Name : ${userModelList[index].name}",
                                                style: TextStyle(
                                                    fontSize: 15.sp,
                                                    fontWeight:
                                                    FontWeight
                                                        .bold,
                                                    color:
                                                    Colors.black),
                                              ),
                                              Text(
                                                  "Phone : ${userModelList[index].phone}",
                                                  style: TextStyle(
                                                      fontSize: 15.sp,
                                                      color: Colors
                                                          .black)),
                                              userModelList[
                                              index]
                                                  .online
                                                  ? Row(
                                                children: const [
                                                  Text(
                                                    "Status : ",
                                                    style: TextStyle(
                                                        color: Colors
                                                            .black),
                                                  ),
                                                  Text(
                                                    "online",
                                                    style: TextStyle(
                                                        color: Colors
                                                            .green),
                                                  )
                                                ],
                                              )
                                                  : Row(
                                                children: const [
                                                  Text(
                                                      "Status : ",
                                                      style: TextStyle(
                                                          color:
                                                          Colors.black)),
                                                  Text(
                                                    "offline",
                                                    style: TextStyle(
                                                        color: Colors
                                                            .red),
                                                  )
                                                ],
                                              ),
                                            ],
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
                                                                  .doc(userModelList[
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
                                              onPressed: ()
                                              {
                                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                  return ChatScreen
                                                    (
                                                    receiverId: userModelList[index].id,
                                                    receiverName: userModelList[index].name,
                                                    cinema: true,
                                                    cinemaID: FirebaseAuth.instance.currentUser!.uid,
                                                    userID:  userModelList[index].id,);
                                                },));
                                              },
                                              icon: const FaIcon(
                                                FontAwesomeIcons.message,

                                                color: Colors.black,
                                              )),
                                          IconButton(
                                              onPressed: () {
                                                _launchInBrowser(Uri(
                                                    scheme: 'https',
                                                    host: 'wa.me',
                                                    path:
                                                    "+${userModelList[index].phone}"));
                                              },
                                              icon: const FaIcon(
                                                FontAwesomeIcons.whatsapp,

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
                                                NetworkImage(userModelList[
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
                                                    "Name : ${userModelList[index].name}",
                                                    style: TextStyle(
                                                        fontSize: 15.sp,
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        color:
                                                        Colors.black),
                                                  ),
                                                  Text(
                                                      "Phone : ${userModelList[index].phone}",
                                                      style: TextStyle(
                                                          fontSize: 15.sp,
                                                          color: Colors
                                                              .black)),
                                                  userModelList[
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
                                                                .doc(userModelList[
                                                            index]
                                                                .id)
                                                                .update({
                                                              'ban': false
                                                            }).then((value) {
                                                              setState(() {

                                                              });
                                                              Navigator.of(
                                                                  context)
                                                                  .pop();
                                                              setState(() {

                                                              });
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
                                }
                                return Container();
                              }),
                        );

                      }

                    },
                  ),
                ],
              ),
            ));
      },
    );
  }
}
Future<void> _launchInBrowser(Uri url) async {
  if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  )) {
    throw 'Could not launch $url';
  }

}
