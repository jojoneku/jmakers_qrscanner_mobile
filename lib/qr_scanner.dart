import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jmaker_qrscanner_mobile/attendanceList.dart';
import 'package:jmaker_qrscanner_mobile/styles/buttons.dart';
import 'package:jmaker_qrscanner_mobile/styles/color.dart';
import 'package:jmaker_qrscanner_mobile/styles/text_style.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'purposePage.dart';

class QRScanner extends StatefulWidget {
  final String selectedPurpose;
  final String selectedService;
  final String selectedMachine;

  QRScanner({
    required this.selectedPurpose,
    required this.selectedService,
    required this.selectedMachine,
  });

  @override
  State<StatefulWidget> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainYellow,
        title: Text('QR Scanner'),
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
                          child: Text('QR Code Successfully Detected'),
                        ),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: const Text('Scan QR Code'),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            style: blackSecondary,
                            onPressed: result != null
                                ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DataDisplayPage(
                                    collectedData: CollectedData(
                                      purpose: widget.selectedPurpose,
                                      service: widget.selectedService,
                                      machine: widget.selectedMachine,
                                      qrData: result!.code!,
                                    ),
                                  ),
                                ),
                              );
                            }
                                : null, // Disable button if result is null
                            child: Text(
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
                      Container(
                        margin: EdgeInsets.all(8),
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
                      Container(
                        margin: const EdgeInsets.all(8),
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
    var scanArea = (MediaQuery.of(context).size.width < 400 || MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
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
