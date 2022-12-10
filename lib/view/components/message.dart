// import 'package:dio/dio.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
//
// import 'package:intl/intl.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:path_provider/path_provider.dart';
// import 'dart:io' as io;
// import 'package:open_filex/open_filex.dart';
//
// import '../../view_model/cubit/auth/auth_cubit.dart';
// import '../../view_model/database/local/cache_helper.dart';
//
// class MessageLine extends StatelessWidget {
//   MessageLine({super.key,this.idDocOne,this.idDocTwo,this.pharmacyID,this.customerID ,this.id, this.messageText, this.sender, this.isMe, this.type ,this.baseName , required this.dateTime});
//   String ? customerID;
//   String ? idDocOne;
//   String ? idDocTwo;
//   String ? pharmacyID;
//   String? type;
//   String? messageText;
//   String? sender;
//   bool? isMe;
//   String? baseName;
//   String? id;
//   String ? dateTime ;
//
//   @override
//   Widget build(BuildContext context) {
//     DateTime now = DateTime.parse(dateTime.toString());
//     return (isMe!)
//         ? (type == 'pdf')
//         ? Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: InkWell(
//             onLongPress: ()
//             async {
//               if (DateTime.now().difference(now).inSeconds > 30) {
//                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("can not delete Message")));
//               } else {
//                 if (AuthCubit
//                     .get(context)
//                     .userModel!
//                     .role == '3') {
//                   await FirebaseFirestore.instance.collection('users').doc(
//                       pharmacyID).
//                   collection('messages').doc(id).get().then((value) async {
//                     print(value.data());
//                     await FirebaseFirestore.instance.collection('users').doc(
//                         customerID).
//                     collection('messages').doc((value.data()!['docOne']))
//                         .delete();
//                   }).whenComplete(() {
//                     FirebaseFirestore.instance.collection('users').doc(
//                         pharmacyID).
//                     collection('messages').doc(id).delete();
//                   });
//                 } else {
//                   await FirebaseFirestore.instance.collection('users').doc(
//                       customerID).
//                   collection('messages').doc(id).get().then((value) async {
//                     await FirebaseFirestore.instance.collection('users').doc(
//                         pharmacyID).
//                     collection('messages').doc((value.data()!['docOne']))
//                         .delete();
//                   }).whenComplete(() {
//                     FirebaseFirestore.instance.collection('users').doc(
//                         customerID).
//                     collection('messages').doc(id).delete();
//                   });
//                 }
//               }
//
//             },
//       onTap: () {
//           openFile(
//               url: messageText!,
//               fileName:
//              "$baseName");
//       },
//       child: Align(
//         alignment: Alignment.topRight,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           mainAxisSize: MainAxisSize.min,
//             children: [
//               Text('$sender'),
//               Material(
//                 elevation: 2,
//                 borderRadius: const BorderRadius.only(
//                   bottomLeft: Radius.circular(30),
//                   bottomRight: Radius.circular(30),
//                   topLeft: Radius.circular(30),
//                 ),
//                 color: Colors.white,
//                 child: Padding(
//                     padding: const EdgeInsets.all(14.0),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Icon((Icons.download)),
//                         SizedBox(
//                           width: 10,
//                         ),
//                         Text(
//                             '$baseName',
//                             style: TextStyle(
//                                 color: Colors.black, fontSize: 14)),
//                       ],
//                     )
//                 ),
//               ),
//               Text(DateFormat.yMEd().add_jms().format(DateTime.parse(dateTime!)))
//             ],
//         ),
//       ),
//     ),
//         )
//         : InkWell(
//       onLongPress: ()
//       async{
//         if (kDebugMode) {
//           print(id);
//         }
//         if (kDebugMode) {
//           print(CacheHelper.get(key: 'id'));
//         }
//         if (DateTime.now().difference(now).inSeconds > 30) {
//           ScaffoldMessenger.of(context).showSnackBar(const
//           SnackBar(content: Text("can not delete Message")));
//         }else {
//           if (AuthCubit
//               .get(context)
//               .userModel!
//               .role == '3') {
//             await FirebaseFirestore.instance.collection('users').doc(pharmacyID)
//                 .
//             collection('messages').doc(id).get()
//                 .then((value) async {
//               print(value.data());
//               await FirebaseFirestore.instance.collection('users').doc(
//                   customerID).
//               collection('messages').doc((value.data()!['docOne']))
//                   .delete();
//             }).whenComplete(() {
//               FirebaseFirestore.instance.collection('users').doc(pharmacyID).
//               collection('messages').doc(id).delete();
//             });
//           } else {
//             await FirebaseFirestore.instance.collection('users').doc(customerID)
//                 .
//             collection('messages').doc(id).get()
//                 .then((value) async {
//               await FirebaseFirestore.instance.collection('users').doc(
//                   pharmacyID).
//               collection('messages').doc((value.data()!['docOne']))
//                   .delete();
//             }).whenComplete(() {
//               FirebaseFirestore.instance.collection('users').doc(customerID).
//               collection('messages').doc(id).delete();
//             });
//           }
//         }
//
//
//
//
//
//       },
//           child: Padding(
//       padding: EdgeInsets.all(22),
//       child: SizedBox(
//           width: double.infinity,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text('$sender'),
//               Material(
//                 elevation: 2,
//                 borderRadius: const BorderRadius.only(
//                   bottomLeft: Radius.circular(30),
//                   bottomRight: Radius.circular(30),
//                   topLeft: Radius.circular(30),
//                 ),
//                 color: Colors.white,
//                 child: Padding(
//                   padding: const EdgeInsets.all(14.0),
//                   child: Text(
//                     '$messageText',
//                     style: const TextStyle(
//                       color: Color(0xff1A1D21),
//                       fontSize: 14,
//                     ),
//                   ),
//                 ),
//               ),
//               Text(DateFormat.yMEd().add_jms().format(DateTime.parse(dateTime!)))
//
//
//             ],
//           ),
//       ),
//     ),
//         )
//         : (type == 'pdf')
//         ? Padding(
//       padding: const EdgeInsets.all(15.0),
//       child: InkWell(
//         onTap: () {
//           openFile(
//               url: messageText!,
//               fileName:
//               "$baseName");
//         },
//         child: Align(
//           alignment: Alignment.topLeft,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text('$sender'),
//               Material(
//                 elevation: 2,
//                 borderRadius: const BorderRadius.only(
//                     bottomLeft: Radius.circular(30),
//                     bottomRight: Radius.circular(30),
//                     topRight: Radius.circular(30)),
//                 color: Color(0xffAAACAE),
//                 child: Padding(
//                     padding: const EdgeInsets.all(14.0),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Icon((Icons.download)),
//                         SizedBox(
//                           width: 10,
//                         ),
//                         Text(
//                             '$baseName',
//                             style: TextStyle(
//                                 color: Colors.black, fontSize: 14)),
//                       ],
//                     )
//                 ),
//               ),
//               Text(DateFormat.yMEd().add_jms().format(DateTime.parse(dateTime!)))
//
//             ],
//           ),
//         ),
//       ),
//     )
//         : InkWell(
//       onLongPress: () async{
//        //
//        //
//        //  await FirebaseFirestore.instance.collection('users').doc(customerID).
//        //  collection('messages').doc(id).get().then((value)
//        // async {
//        //
//        //   print(value.data());
//        //    await FirebaseFirestore.instance.collection('users').doc(pharmacyID).collection('messages').doc(id).delete();
//        //    await FirebaseFirestore.instance.collection('users').doc(pharmacyID).collection('messages').doc(value.data()!['docOne']).delete();
//        //    await FirebaseFirestore.instance.collection('users').doc(customerID).collection('messages').doc(id).delete();
//        //    await FirebaseFirestore.instance.collection('users').doc(customerID).collection('messages').doc(value.data()!['docOne']).delete();
//        //
//        //  });
//        //  await FirebaseFirestore.instance.collection('users').doc(pharmacyID).
//        //  collection('messages').doc(id).get().then((value)
//        //  async {
//        //
//        //    print(value.data());
//        //    await FirebaseFirestore.instance.collection('users').doc(pharmacyID).collection('messages').doc(id).delete();
//        //    await FirebaseFirestore.instance.collection('users').doc(pharmacyID).collection('messages').doc(value.data()!['docOne']).delete();
//        //    await FirebaseFirestore.instance.collection('users').doc(customerID).collection('messages').doc(id).delete();
//        //    await FirebaseFirestore.instance.collection('users').doc(customerID).collection('messages').doc(value.data()!['docOne']).delete();
//        //
//        //  });
//         // await FirebaseFirestore.instance.collection('users').doc(pharmacyID).
//         // collection('messages').doc(id).get().then((value)
//         // async {
//         //
//         //   print(value.data());
//         //
//         // });
//
//
//
//       },
//           child: Padding(
//       padding: EdgeInsets.all(22),
//       child: Container(
//           width: double.infinity,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('$sender'),
//               Material(
//                 elevation: 2,
//                 borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(30),
//                     bottomRight: Radius.circular(30),
//                     topRight: Radius.circular(30)),
//                 color: Color(0xffAAACAE),
//                 child: Padding(
//                   padding: const EdgeInsets.all(14.0),
//                   child: Text(
//                     '$messageText',
//                     style: TextStyle(
//                       color: Color(0xff1A1D21),
//                       fontSize: 14,
//                     ),
//                   ),
//                 ),
//               ),
//               Text(DateFormat.yMEd().add_jms().format(DateTime.parse(dateTime!)))
//
//
//             ],
//           ),
//       ),
//     ),
//         );
//   }
// }
//
// class PdfLine extends StatelessWidget {
//   PdfLine({
//     this.messageText,
//     this.sender,
//     this.isMe,
//   });
//
//   String? messageText;
//   String? sender;
//   bool? isMe;
//
//   @override
//   Widget build(BuildContext context) {
//     return (isMe!)
//         ? Padding(
//       padding: EdgeInsets.all(22),
//       child: Container(
//         width: double.infinity,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             Text('$sender'),
//             Material(
//               elevation: 2,
//               borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(30),
//                 bottomRight: Radius.circular(30),
//                 topLeft: Radius.circular(30),
//               ),
//               color: Colors.white,
//               child: Padding(
//                 padding: const EdgeInsets.all(14.0),
//                 child: Text('$messageText',
//                     style: TextStyle(color: Colors.black, fontSize: 14)),
//               ),
//             ),
//           ],
//         ),
//       ),
//     )
//         : Padding(
//       padding: EdgeInsets.all(22),
//       child: Container(
//         width: double.infinity,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('$sender'),
//             Material(
//               elevation: 2,
//               borderRadius: BorderRadius.only(
//                   bottomLeft: Radius.circular(30),
//                   bottomRight: Radius.circular(30),
//                   topRight: Radius.circular(30)),
//               color: Color(0xffAAACAE),
//               child: Padding(
//                 padding: const EdgeInsets.all(14.0),
//                 child: Text(
//                   '$messageText',
//                   style: TextStyle(
//                     color: Color(0xff1A1D21),
//                     fontSize: 14,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// Future openFile({required String url, required String fileName}) async {
//   final file = await downloadFile(url, fileName);
//   if (file == null) {
//     return;
//   }
//   OpenFilex.open(file.path);
// }
//
// Future<io.File?> downloadFile(String url, String filName) async {
//   final appStorage = await getApplicationDocumentsDirectory();
//   final filePath = io.File('${appStorage.path}/$filName');
//   final response = await Dio().get(url,
//       options: Options(
//           responseType: ResponseType.bytes,
//           followRedirects: false,
//           receiveTimeout: 0));
//   final ref = filePath.openSync(mode: io.FileMode.write);
//   ref.writeFromSync(response.data);
//   await ref.close();
//   print("Amr");
//   return filePath;
// }