import 'dart:io' as io;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:p3/database/network/dio_helper.dart';
import 'package:path/path.dart';

import '../../../database/local/cache_helper.dart';
import '../../../model/treatment_model.dart';
import '../../../model/user_model/user.dart';

part 'auth_state.dart';

class ControllerCubit extends Cubit<AuthState> {
  ControllerCubit() : super(AuthInitial());

  static ControllerCubit get(context) => BlocProvider.of<ControllerCubit>(context);
  UserModel? userModel;
  io.File? file;
  FilePickerResult? filePicker;
  String? baseName;

  void pickSound() async {
    filePicker = await FilePicker.platform.pickFiles(allowedExtensions: ['mp3'],
        type: FileType.custom

    );
    if (filePicker != null) {
      file = io.File(io.File(filePicker!.files.single.path!).path);
      print(filePicker!.files.single.path);
      baseName = basename(file!.path);
    } else {
      // User canceled the pick
      // User canceled the picker
    }
    emit(PickSoundState());
  }

  Future<void> deleteTreatement(String id) async {
    emit(DeleteTreatmentStateLoading());
    await FirebaseFirestore.instance
        .collection('treatments')
        .doc(id)
        .delete()
        .then((value)
    {
      emit(DeleteTreatmentStateSuccessful());
    }).catchError((error)
    {
      emit(DeleteTreatmentStateError());
    });
  }

  final ImagePicker _picker = ImagePicker();
  TreatMentModel? treatMentModelOne;

  Future<void> sendMessageEmail() async {
    String serviceId = "service_221p1v5";
    String templateID = "template_67usrle";
    String userID = "ZBnkx-VbLvLz023ZI";
    var params = {
      'user_id': userID,
      'accessToken': '9Pe4fmhvjh5TR13I9xsHo',
      'service_id': serviceId,
      'template_id': templateID,
    };
    await DioHelper.postData(url: "/api/v1.0/email/send", data: params)
        .then((value) {
      print(value.data);
    }).catchError((error) {
      if (error is DioError) {
        print(error.response!.data);
      }
      print(error);
    });
  }

  Future<void> getDataTreatments({required String id}) async {
    treatMentModelOne = null;
    emit(GetDataTreatmentStateLoading());
    await FirebaseFirestore.instance
        .collection('treatments')
        .doc(id)
        .get()
        .then((value) {
      treatMentModelOne = TreatMentModel.fromMap(value.data()!);
      emit(GetDataTreatmentStateSuccessful());
    }).catchError((error) {
      print(error);
      emit(GetDataTreatmentStateError());
    });
  }

  // login function start
  Future<void> getUserData() async {
    emit(GetUserDataLoadingState());
    userModel = null;
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      userModel = UserModel.fromMap(value.data()!);

      emit(GetUserDataSuccessfulState('data come true'));
    }).catchError((onError) {
      print(onError.toString());
      emit(GetUserDataErrorState('some Thing Error'));
    });
  }

  Future<void> update({
    required String email,
    required String phone,
    required String age,
    required String name,

    // required String role,
  }) async {
    emit(UpdateDataLoadingState());
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'name': name,
      'phone': phone,
      'age': age,
      'email': email,
    }).then((value) {
      emit(UpdateDataSuccessfulState('done'));
    }).catchError((onError) {
      emit(UpdateDataErrorState('some thing Error'));
    });
  }

  List<UserModel> userModelList = [];
// here i get all users from firebase and put it in list
  Future<void> getCustomerUSer() async {
    emit(GetAllUsersLoadnig());
    userModelList = [];
    await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: '3')
        .where('approveUser', isEqualTo: true)
        .get()
        .then((value) {
      for (var element in value.docs) {
        userModelList.add(UserModel.fromMap(element.data()));
      }

      emit(GetAllCustomerScreenSuccessful());
    }).catchError((error) {
      emit(GetAllUserErrorState('some thing Error'));
    });
  }

  Future<void> uploadFile(XFile? file, BuildContext context) async {
    emit(UploadImageStateLoading('loading'));
    if (file == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No file was selected'),
        ),
      );

      return;
    }

    UploadTask uploadTask;

    // Create a Reference to the file
    Reference ref = FirebaseStorage.instance.ref().child('/${file.name}');

    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'picked-file-path': file.path},
    );

    if (kIsWeb) {
      uploadTask = ref.putData(await file.readAsBytes(), metadata);
    } else {
      print('Amr2');
      ref.putFile(io.File(file.path), metadata).then((p0) => {
            ref.getDownloadURL().then((value) async {
              // here modify the profile pic
              userModel!.photo = value;
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .update({'photo': value}).then((value) {
                emit(UploadImageStateSuccessful('upload done'));
              }).catchError((onError) {
                emit(UploadImageStateError('Error'));
              });
            })
          });
    }
  }

  String? imageUrl;

  // Future<void> uploadImageMovie(XFile? file, BuildContext context) async {
  //   emit(UploadImageStateLoading('loading'));
  //   if (file == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('No file was selected'),
  //       ),
  //     );
  //
  //     return;
  //   }
  //
  //   UploadTask uploadTask;
  //
  //   // Create a Reference to the file
  //   Reference ref = FirebaseStorage.instance.ref().child('/${file.name}');
  //
  //   final metadata = SettableMetadata(
  //     contentType: 'image/jpeg',
  //     customMetadata: {'picked-file-path': file.path},
  //   );
  //
  //   if (kIsWeb) {
  //     uploadTask = ref.putData(await file.readAsBytes(), metadata);
  //   } else {
  //     print('Amr2');
  //     ref.putFile(io.File(file.path), metadata).then((p0) => {
  //           ref.getDownloadURL().then((value) {
  //             // here modify the profile pic
  //             imageUrl = value;
  //             emit(UploadImageStateSuccessful('upload done'));
  //           })
  //         });
  //   }
  // }

  XFile? image;

  Future<void> pickImageGallary(BuildContext context) async {
    image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) {
    } else {
      print(image!.path);
      await uploadFile(image, context).then((value) {});
    }
  }

  Future<void> pickImageCamera(BuildContext context) async {
    image = await _picker.pickImage(source: ImageSource.camera);
    if (image == null) {
    } else {
      print(image!.path);
      await uploadFile(image, context).then((value) {});

      emit(PickImageSuccessful());
    }
  }

  List<UserModel> adminData = [];

  Future<void> getAdmin() async {
    emit(GetAdminsStateLoading('loading'));
    adminData = [];
  await  FirebaseFirestore.instance
        .collection('users')
        .where(
          'role',
          isEqualTo: '1',
        )
        .get()
        .then((value) {
      for (var element in value.docChanges) {
        if (element.doc.data()!['id'] == CacheHelper.get(key: 'id'))
        {
          // do not add in list
        } else {
          adminData.add(UserModel.fromMap(element.doc.data()!));
        }
      }
      emit(GetAdminsStateSuccessful('successful'));
    }).catchError((onError) {
      print(onError.toString());
      print('Amr');
      emit(GetAdminsStateError('Error'));
    });
  }

  String? docOne;
  String? docTwo;

  // send message firebase
  Future<void> sendMessage(
      {required String message,
      required String pharmacyID,
      required String customerName,
      required String customerId,
      required String pharmacyName,
      required String senderID,
      required String type,
      String? baseName}) async {
    emit(SendMessageStateLoading('loading'));
    print(baseName);
    FirebaseFirestore.instance
        .collection('users')
        .doc(customerId)
        .collection('messages')
        .add({
      'message': message,
      'senderID': senderID,
      'customerName': customerName,
      'pharmacyID': pharmacyID,
      'pharmacyName': pharmacyName,
      'customerId': customerId,
      'type': type,
      'time': DateTime.now().toString(),
      'baseName': baseName
    }).then((value) {
      docOne = value.id;
      FirebaseFirestore.instance
          .collection('users')
          .doc(customerId)
          .collection('messages')
          .doc(value.id)
          .update({
        'id': value.id,
      });
    }).catchError((onError) {
      emit(SendMessageStateError('onError'));
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(pharmacyID)
        .collection('messages')
        .add({
      'message': message,
      'customerName': customerName,
      'senderID': senderID,
      'baseName': baseName,
      'pharmacyID': pharmacyID,
      'pharmacyName': pharmacyName,
      'customerId': customerId,
      'type': type,
      'time': DateTime.now().toString(),
    }).then((value) {
      docTwo = value.id;
      FirebaseFirestore.instance
          .collection('users')
          .doc(pharmacyID)
          .collection('messages')
          .doc(value.id)
          .update({
        'id': value.id,
        'docOne': docOne,
      }).then((value) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(customerId)
            .collection('messages')
            .doc(docOne)
            .update({
          'docOne': docTwo,
        });
      });
      print(value);
      emit(SendMessageStateSuccessful('Successful'));
    }).catchError((onError) {
      emit(SendMessageStateError('onError'));
    });
  }

  FilePickerResult? result;

  Future<void> pickFile() async {
    result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowedExtensions: ['pdf', 'doc'],
    );
    if (result != null) {
      io.File file = io.File(result!.files.single.path.toString());
      FirebaseStorage.instance.ref().child('files').putFile(file).then((p0) {
        p0.ref.getDownloadURL().then((value) {
          print(value);
        });
      });
    }
  }

  XFile? image2;
  XFile? imageSnack;

  Future<void> uploadFileTreatment({
    XFile? file,
    required BuildContext context,
    required String title,
    required num amount,
    required int duration,
  }) async {
    emit(UploadImageStateLoading('loading'));
    if (file == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No file was selected'),
        ),
      );
      return;
    }

    UploadTask uploadTask;

    // Create a Reference to the file
    Reference ref =
    FirebaseStorage.instance.ref().child('/${file.name}');

    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'picked-file-path': file.path},
    );

    if (kIsWeb) {
      uploadTask = ref.putData(await file.readAsBytes(), metadata);
    } else {
      if (kDebugMode) {
        print('Amr2');
      }

      ref.putFile(io.File(file.path), metadata).then((p0) => {
            ref.getDownloadURL().then((value) async {
              // here modify the profile pic
              await createTreatment(
                context: context,
                title: title,
                amount: amount,
                image: value,
                duration: duration,
              );
            })
          });
    }
  }

  XFile? imageTreatment;

  Future<void> pickImageGallaryTreatment(BuildContext context) async {
    imageTreatment = await _picker.pickImage(source: ImageSource.gallery);
    if (imageTreatment == null) {
    } else {
      print(imageTreatment!.path);
    }
    emit(PickImageSuccessful());
  }

  Future<void> pickImageGallaryTreatmentUpdate(
      BuildContext context, String id) async {
    imageTreatment = await _picker.pickImage(source: ImageSource.gallery);
    if (imageTreatment == null) {
    } else {
      updateUploadFileTreatment(
        file: imageTreatment,
        context: context,
        id: id,
      );
      print(imageTreatment!.path);
      emit(PickImageSuccessful());
    }
  }

  String? url;

  Future<void> pickImageCameraTreatmentUpdate(
      BuildContext context, String id) async {
    imageTreatment = await _picker.pickImage(source: ImageSource.camera);
    if (imageTreatment == null) {
    } else {
      print(imageTreatment!.path);
      updateUploadFileTreatment(
        file: imageTreatment,
        context: context,
        id: id,
      );
      emit(PickImageSuccessful());
    }
  }

  Future<void> pickImageCameraTreatment(
    BuildContext context,
  ) async {
    imageTreatment = await _picker.pickImage(source: ImageSource.camera);
    if (imageTreatment == null) {
    } else {
      print(imageTreatment!.path);

      emit(PickImageSuccessful());
    }
  }

  Future<void> updateUploadFileTreatment({
    XFile? file,
    String? id,
    required BuildContext context,
  }) async {
    emit(UploadImageStateLoading('loading'));
    if (file == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No file was selected'),
        ),
      );

      return;
    }

    UploadTask uploadTask;

    // Create a Reference to the file
    Reference ref = FirebaseStorage.instance.ref().child('/${file.name}');

    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'picked-file-path': file.path},
    );

    if (kIsWeb) {
      uploadTask = ref.putData(await file.readAsBytes(), metadata);
    } else {
      if (kDebugMode) {
        print('Amr2');
      }
      ref.putFile(io.File(file.path), metadata).then((p0) => {
            ref.getDownloadURL().then((value) async {
              // here modify the profile pic
              FirebaseFirestore.instance
                  .collection('treatments')
                  .doc(id)
                  .update({
                'image': value,
              }).then((value) {
                emit(UploadImageStateSuccessful('Successful'));
              }).catchError((onError) {
                emit(UploadImageStateError('onError'));
              });
            })
          });
    }
  }

  Future<void> UpdatecreateTreatment({
    required String title,
    required num amount,
    required BuildContext context,
    required int duration,
    required String id,
  }) async {
    emit(CreateTreatmentStateLoading());
    print(id);
    await FirebaseFirestore.instance.collection('treatments').doc(id).update({
      'title': title,
      'amount': amount,
      'duration': duration,
    }).then((value) async {
      imageTreatment = null;
      emit(updateTreatmentSuccessful());
    }).catchError((onError) {
      emit(CreateTreatmentStateError());
    });
  }

  Future<void> createTreatment({
    required String title,
    required num amount,
    required BuildContext context,
    required String image,
    required int duration,
  }) async {
    emit(CreateTreatmentStateLoading());
    TreatMentModel treatMentModel = 
    TreatMentModel(
      title: title,
      startTime: DateTime.now().toString(),
      lastTimeTake: DateTime.now().toString(),
      userID: FirebaseAuth.instance.currentUser!.uid,
      photo: image,
      finished: false,
      id: '',
      nameSound: file!.absolute.path,
      times_of_took: 0,
      amount: amount,
      duration: duration,
    );
    await FirebaseFirestore.instance
        .collection('treatments')
        .add(treatMentModel.toMap())
        .then((value) async {
      await FirebaseFirestore.instance
          .collection('treatments')
          .doc(value.id)
          .update({
        'id': value.id,
      }).then((value) {
        imageTreatment = null;
      });
      emit(CreateTreatmentStateSuccessful(value.id));
    }).catchError((onError) {
      emit(CreateTreatmentStateError());
    });
  }

  List<TreatMentModel> treatMentModel = [];
  Future<void> getTreatmentData() async {
    treatMentModel = [];
    emit(GetTreatmentDataStateLoading());
    FirebaseFirestore.instance
        .collection('treatments')
        .where('userID', isEqualTo: FirebaseAuth.instance.currentUser!.uid).
         where('amount', isGreaterThan: 0)
        .get()
        .then((value)
    {
      for (var element in value.docs)
      {
        print(element.data());
        treatMentModel.add(TreatMentModel.fromMap(element.data()));
      }
      emit(GetTreatmentDataStateSuccessful());
    }).catchError((onError) {
      print(onError);
      emit(GetTreatmentDataStateError());
    });
  }
  Future<void> getTreatmentDataUser({required String userID}) async {
    treatMentModel = [];
    emit(GetTreatmentDataStateLoading());
    FirebaseFirestore.instance
        .collection('treatments')
        .where('userID', isEqualTo: userID).
        where('amount', isGreaterThan: 0)
        .get()
        .then((value) {
      for (var element in value.docs) {
        print(element.data());
        treatMentModel.add(TreatMentModel.fromMap(element.data()));
      }
      emit(GetTreatmentDataStateSuccessful());
    }).catchError((onError) {
      print(onError);
      emit(GetTreatmentDataStateError());
    });
  }
  List<TreatMentModel> getHistoryTreatment = [];
  Future<void> getTreatmentHistoryOneUSerData({required String id}) async {
    getHistoryTreatment = [];
    emit(GetTreatmentDataStateLoading());
    FirebaseFirestore.instance
        .collection('treatments')
        .where('userID', isEqualTo:id).where('amount', isEqualTo: 0)
        .get()
        .then((value) {
      for (var element in value.docs) {
        print(element.data());
        getHistoryTreatment.add(TreatMentModel.fromMap(element.data()));
      }
      emit(GetTreatmentDataStateSuccessful());
    }).catchError((onError) {
      print(onError);
      emit(GetTreatmentDataStateError());
    });
  }

  Future<void> getTreatmentHistoryData() async {
    getHistoryTreatment = [];
    emit(GetTreatmentDataStateLoading());
    FirebaseFirestore.instance
        .collection('treatments')
        .where('userID', isEqualTo: FirebaseAuth.instance.currentUser!.uid).where('amount', isEqualTo: 0)
        .get()
        .then((value) {
      for (var element in value.docs) {
        print(element.data());
        getHistoryTreatment.add(TreatMentModel.fromMap(element.data()));
      }
      emit(GetTreatmentDataStateSuccessful());
    }).catchError((onError) {
      print(onError);
      emit(GetTreatmentDataStateError());
    });
  }

}
