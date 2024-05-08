// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jmaker_qrscanner_mobile/controllers/snackbar_controller.dart';
import 'package:jmaker_qrscanner_mobile/models/maker_model.dart';
import 'package:jmaker_qrscanner_mobile/models/student_model.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class FirestoreController extends ControllerMVC {
  factory FirestoreController() => _this ??= FirestoreController._();
  FirestoreController._();
  static FirestoreController? _this;

  Stream<QuerySnapshot<Map<String, dynamic>>> attendanceSnapshots = FirebaseFirestore.instance.collection('attendance').snapshots();

  //* Add User Details
  Future<void> addStudentDetails(BuildContext context, StudentModel studentModel) async {
    try {
      await FirebaseFirestore.instance.collection('attendance').add(studentModel.toJson());
      SnackBarController.showSnackBar(context, 'Successfully added the scanned data');
    } catch (e) {
      SnackBarController.showSnackBar(context, e.toString());
    }
  }

  Future<void> addMakerDetails(BuildContext context, MakerModel makerModel) async {
    try {
      await FirebaseFirestore.instance.collection('attendance').add(makerModel.toJson());
      SnackBarController.showSnackBar(context, 'Successfully added the scanned data');
    } catch (e) {
      SnackBarController.showSnackBar(context, e.toString());
    }
  }

  //* Get User Details
  Future<dynamic> getUserDetailsById(BuildContext context, String uid) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      final DocumentSnapshot docSnap = await firestore.collection('students').doc(uid).get();
      if (docSnap.exists) {
        return StudentModel.fromJson(docSnap.data() as Map<String, dynamic>);
      } else {
        final DocumentSnapshot docSnap = await firestore.collection('makers').doc(uid).get();

        if (docSnap.exists) {
          return MakerModel.fromJson(docSnap.data() as Map<String, dynamic>);
        }

        return null;
      }
    } catch (e) {
      SnackBarController.showSnackBar(context, e.toString());
      return null;
    }
  }
}
