import 'package:flutter/material.dart';
import 'package:jmaker_qrscanner_mobile/qr_scanner.dart';
import 'package:jmaker_qrscanner_mobile/styles/color.dart';
import 'package:jmaker_qrscanner_mobile/styles/text_style.dart';

class CollectedData {
  final String purpose;
  final String service;
  final String machine;
  final String qrData;

  CollectedData({
    required this.purpose,
    required this.service,
    required this.machine,
    required this.qrData,
  });
}

class DataDisplayPage extends StatefulWidget {
  final CollectedData collectedData;

  const DataDisplayPage({Key? key, required this.collectedData}) : super(key: key);

  @override
  _DataDisplayPageState createState() => _DataDisplayPageState();
}

class _DataDisplayPageState extends State<DataDisplayPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainYellow,
        title: Text('Attendance'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  child: DataTable(
                    columnSpacing: 10,
                    columns: [
                      DataColumn(label: Text('Purpose')),
                      DataColumn(label: Text('Service')),
                      DataColumn(label: Text('Machine')),
                      DataColumn(label: Text('QR Data')),
                    ],
                    rows: [
                      DataRow(cells: [
                        DataCell(Text(widget.collectedData.purpose)),
                        DataCell(Text(widget.collectedData.service)),
                        DataCell(Text(widget.collectedData.machine)),
                        DataCell(Text(widget.collectedData.qrData)),
                      ]),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => QRScanner(
                        selectedPurpose: widget.collectedData.purpose,
                        selectedService: widget.collectedData.service,
                        selectedMachine: widget.collectedData.machine,
                      ),
                    ),
                  );
                },
                child: Text(
                  'Scan QR Code Again',
                  style: CustomTextStyle.primaryBlack,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
