//
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
//
// import '../../../constants.dart';
// import '../../../model/auth/login_model.dart';
// import '../../../view/components/component.dart';
// import '../local/cache_helper.dart';
// import 'dio-helper.dart';
// import 'end_points.dart';
//
// class DioExceptions implements Exception {
//   String? message;
//
//   LoginModel? loginModel;
//
//
//   String _handleError(int? statusCode, dynamic error) {
//     switch (statusCode) {
//       case 400:
//         return error['message'];
//       case 401:
//         return 'Unauthorized';
//       case 403:
//         return 'Forbidden';
//       case 404:
//         return error['message'];
//       case 500:
//         return 'Internal server error';
//       case 502:
//         return 'Bad gateway';
//       default:
//         return 'Oops something went wrong';
//     }
//   }
//
//   @override
//   String toString() => message ?? '';
// }
