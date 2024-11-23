// import 'dart:async';
// import 'dart:io';
//
// import 'package:bloc/bloc.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
//
// part 'email_verify_event.dart';
// part 'email_verify_state.dart';
//
// class EmailVerifyBloc extends Bloc<EmailVerifyEvent, EmailVerifyState> {
//   EmailVerifyBloc() : super(EmailVerifyInitial()) {
//     on<EmailVerifySent>(_emailVerifySent);
//     on<EmailVerifyResend>(_emailVerifyResend);
//   }
//   Future<void> _emailVerifySent(
//       EmailVerifySent event, Emitter<EmailVerifyState> emit) async {
//     try {
//       emit(EmailVerifyLoading());
//       // final res = await EmailVerifyRepo(otp: event.otp).emailVerifyResponse();
//       if (res == null) {
//         emit(EmailVerifyFailed("Check Your Connection"));
//       }
//       if (res?.statusCode == HttpStatus.ok) {
//         // final SharedPreferences prefs = await SharedPreferences.getInstance();
//         // prefs.setBool("isVerified", true);
//         // prefs.remove('userEmail');
//         // emit(EmailVerifySuccess("Successful"));
//       } else {
//         emit(EmailVerifyFailed(res?.data['message']));
//       }
//     } on DioException catch (error) {
//       emit(EmailVerifyFailed(error.toString()));
//     }
//   }
//
//   Future<void> _emailVerifyResend(
//       EmailVerifyResend event, Emitter<EmailVerifyState> emit) async {
//     try {
//       emit(EmailVerifyLoading());
//       final res = await EmailVerifyRepo().emailVerifyResendResponse();
//       print(res);
//       if (res?.statusCode == 200) {
//         emit(EmailVerifyResendSuccess(res?.data['message']));
//       } else {
//         if (res?.data.containsKey('missing_parameters') &&
//             !res?.data['missing_parameters'].isEmpty) {
//           emit(EmailVerifyResendFailed(res?.data['missing_parameters']?[0]));
//         } else {
//           emit(EmailVerifyResendFailed(res?.data['message']));
//         }
//       }
//     } on DioException catch (err) {
//       emit(EmailVerifyResendFailed(err.toString()));
//     }
//   }
// }
