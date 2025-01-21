// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jmaker_qrscanner_mobile/controllers/firestore_controller.dart';
import 'package:jmaker_qrscanner_mobile/controllers/snackbar_controller.dart';
import 'package:jmaker_qrscanner_mobile/models/maker_model.dart';
import 'package:jmaker_qrscanner_mobile/models/student_model.dart';
import 'package:jmaker_qrscanner_mobile/routes/app_router.gr.dart';
import 'package:jmaker_qrscanner_mobile/styles/buttons.dart';
import 'package:jmaker_qrscanner_mobile/styles/color.dart';
import 'package:jmaker_qrscanner_mobile/styles/text_style.dart';
import 'package:jmaker_qrscanner_mobile/utils/encryt_utils.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

@RoutePage()
class QRScannerScreen extends StatefulWidget {
  final String selectedPurpose;
  final String selectedService;
  final String selectedMachine;

  const QRScannerScreen({
    super.key,
    required this.selectedPurpose,
    required this.selectedService,
    required this.selectedMachine,
  });

  @override
  State<StatefulWidget> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ModalRoute.of(context)!.isCurrent) {
      // Resume the camera if this page is the current route
      controller?.resumeCamera();
    } else {
      // Pause the camera if this page is not the current route
      controller?.pauseCamera();
    }
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  String formatDateTime(DateTime dateTime) {
    return DateFormat('MMMM d, y h:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainYellow,
        title: const Text('QR Scanner'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(flex: 10, child: _buildQrView(context)),
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (result != null)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Container(
                          alignment: Alignment.center,
                          width: 400,
                          child: const Text('QR Code Successfully Detected'),
                        ),
                      ),
                    )
                  else
                    const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text('Scan QR Code'),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            style: blackSecondary,
                            onPressed: result != null
                                ? () async {
                                    if (isLoading) {
                                      return;
                                    }

                                    try {
                                      if (result?.code != null) {
                                        final decryptedData = EncryptUtils.decrypt(result!.code!);

                                        final decodedData = jsonDecode(decryptedData);

                                        if (decodedData is Map<String, dynamic>) {
                                          setState(() {
                                            isLoading = true;
                                          });
                                          if (decodedData.containsKey('universityEmail')) {
                                            final studentModel = StudentModel.fromJson(decodedData);

                                            final studentData =
                                                (await FirestoreController().getUserDetailsById(context, studentModel.uid)) as StudentModel;

                                            await FirestoreController().addStudentDetails(
                                              context,
                                              studentData.copyWith(
                                                purpose: widget.selectedPurpose,
                                                service: widget.selectedService,
                                                machine: widget.selectedMachine,
                                                dateTime: formatDateTime(DateTime.now()),
                                              ),
                                            );
                                            setState(() {
                                              isLoading = false;
                                            });
                                            context.router.popUntilRouteWithName(DataDisplayRouteSyncfusionRoute.name);
                                          } else {
                                            final makerModel = MakerModel.fromJson(decodedData);

                                            final makerData = (await FirestoreController().getUserDetailsById(context, makerModel.uid)) as MakerModel;

                                            await FirestoreController().addMakerDetails(
                                              context,
                                              makerData.copyWith(
                                                purpose: widget.selectedPurpose,
                                                service: widget.selectedService,
                                                machine: widget.selectedMachine,
                                                dateTime: formatDateTime(DateTime.now()),
                                              ),
                                            );
                                            setState(() {
                                              isLoading = false;
                                            });
                                            context.router.popUntilRouteWithName(DataDisplayRouteSyncfusionRoute.name);
                                          }
                                          log('message');
                                        } else {
                                          SnackBarController.showSnackBar(context, 'Invalid QR Code');
                                          setState(() {
                                            isLoading = false;
                                          });
                                        }
                                      }
                                    } catch (e) {
                                      SnackBarController.showSnackBar(context, 'Invalid QR Code');
                                      setState(() {
                                        isLoading = false;
                                      });
                                    }
                                  }
                                : null,
                            // Disable button if result is null
                            child: isLoading
                                ? const CircularProgressIndicator.adaptive()
                                : Text(
                                    'Record Attendance',
                                    style: CustomTextStyle.primaryWhite,
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            style: yellowPrimary,
                            onPressed: () async {
                              await controller?.pauseCamera();
                            },
                            child: Text(
                              'Pause',
                              style: CustomTextStyle.primaryBlack,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            style: yellowPrimary,
                            onPressed: () async {
                              await controller?.resumeCamera();
                            },
                            child: Text(
                              'Resume',
                              style: CustomTextStyle.primaryBlack,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 || MediaQuery.of(context).size.height < 400) ? 150.0 : 300.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.amber,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: scanArea,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });

      String? scannedCode = scanData.code;
      if (scannedCode!.isEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('No QR code scanned.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        // Handle scanned QR code data here
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
