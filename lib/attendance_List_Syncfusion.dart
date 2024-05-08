
import 'package:flutter/material.dart';
import 'package:jmaker_qrscanner_mobile/purposePage.dart';
import 'package:jmaker_qrscanner_mobile/styles/color.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column, Row;
import 'package:path_provider/path_provider.dart';
import 'dart:io'; // Import File from dart:io

class CollectedUserData {
  final String purpose;
  final String service;
  final String machine;
  final String qrData;

  CollectedUserData({
    required this.purpose,
    required this.service,
    required this.machine,
    required this.qrData,
  });
}

class DataDisplayPageSyncfusion extends StatelessWidget {
  final GlobalKey<SfDataGridState> _key = GlobalKey<SfDataGridState>();
  final List<CollectedUserData> dataList;
  final CollectedUserData collectedData; // Add this variable

  DataDisplayPageSyncfusion({
    super.key,
    required this.dataList,
    required this.collectedData, // Update the constructor
  });

  Future<void> exportDataGridToExcel(BuildContext context) async {
    try {
      final Workbook workbook = _key.currentState!.exportToExcelWorkbook();
      final List<int> bytes = workbook.saveAsStream();

      // Get the directory for saving files on the device
      final directory = await getExternalStorageDirectory();
      final String filePath = '/storage/emulated/0/Download/DataGrid.xlsx';

      // Write the Excel file
      final file = File(filePath);
      await file.writeAsBytes(bytes);

      workbook.dispose();
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Excel file has been downloaded successfully.'),
      ));
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('We are unable to download the Excel file. Please try again later.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserDataSource userDataSource =
    UserDataSource(dataList: dataList);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Display'),
        backgroundColor: mainYellow,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 16, right: 16),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    height: 40.0,
                    width: 150.0,
                    child: MaterialButton(
                      color: blackGreen,
                      onPressed: () {
                        exportDataGridToExcel(context);
                      },

                      child: const Center(
                        child: Text(
                          'Export to Excel',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SfDataGrid(
                key: _key,
                allowSorting: true,
                allowPullToRefresh: true,
                showHorizontalScrollbar: true,
                showVerticalScrollbar: true,
                source: userDataSource,
                columnWidthMode: ColumnWidthMode.fill,
                columns: <GridColumn>[
                  GridColumn(
                      columnName: 'purpose',
                      label: Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            'Purpose',
                          ))),
                  GridColumn(
                      columnName: 'service',
                      label: Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.centerLeft,
                          child: const Text('Service'))),
                  GridColumn(
                      columnName: 'machine',
                      label: Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            'Machine',
                            overflow: TextOverflow.ellipsis,
                          ))),
                  GridColumn(
                      columnName: 'qrData',
                      columnWidthMode: ColumnWidthMode.fitByCellValue,
                      label: Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.centerLeft,
                          child: const Text('QR Data'))),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PurposeAndServices(
                  ),
                ),
              );
            },
            backgroundColor: Colors.amber,
            child: const Icon(Icons.add,),

          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

}

class UserDataSource extends DataGridSource {
  final List<CollectedUserData> dataList;

  UserDataSource({required this.dataList});

  @override
  List<DataGridRow> get rows => dataList
      .map<DataGridRow>((data) => DataGridRow(cells: [
    DataGridCell<String>(columnName: 'purpose', value: data.purpose),
    DataGridCell<String>(columnName: 'service', value: data.service),
    DataGridCell<String>(columnName: 'machine', value: data.machine),
    DataGridCell<String>(columnName: 'qrData', value: data.qrData),
  ]))
      .toList();

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataCell) {
        return Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(8.0),
          child: Text(dataCell.value.toString()), // Adjust this based on your cell content
        );
      }).toList(),
    );
  }
}
