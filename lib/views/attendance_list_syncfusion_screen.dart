// ignore_for_file: use_build_context_synchronously

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jmaker_qrscanner_mobile/controllers/firestore_controller.dart';
import 'package:jmaker_qrscanner_mobile/models/maker_model.dart';
import 'package:jmaker_qrscanner_mobile/models/student_model.dart';
import 'package:jmaker_qrscanner_mobile/routes/app_router.gr.dart';
import 'package:jmaker_qrscanner_mobile/styles/color.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column, Row;
import 'dart:io'; // Import File from dart:io

class CollectedUserData {
  final String purpose;
  final String service;
  final String machine;
  final dynamic userData;

  CollectedUserData({
    required this.purpose,
    required this.service,
    required this.machine,
    required this.userData,
  });
}

@RoutePage()
class DataDisplayPageSyncfusionScreen extends StatelessWidget {
  final GlobalKey<SfDataGridState> _key = GlobalKey<SfDataGridState>();

  DataDisplayPageSyncfusionScreen({
    super.key,
  });

  Future<void> exportDataGridToExcel(BuildContext context) async {
    try {
      final Workbook workbook = _key.currentState!.exportToExcelWorkbook();
      final List<int> bytes = workbook.saveAsStream();

      // Get the directory for saving files on the device
      const String filePath = '/storage/emulated/0/Download/DataGrid.xlsx';

      // Write the Excel file
      final file = File(filePath);
      await file.writeAsBytes(bytes);

      workbook.dispose();
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Excel file has been downloaded successfully.'),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('We are unable to download the Excel file. Please try again later.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Display'),
        backgroundColor: mainYellow,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirestoreController().attendanceSnapshots,
          builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Something went wrong'),
              );
            }

            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final users = snapshot.data?.docs.map((e) {
              if (e.data().containsKey('universityEmail')) {
                return StudentModel.fromJson(e.data());
              }

              if (e.data().containsKey('email')) {
                return MakerModel.fromJson(e.data());
              }

              return null;
            }).toList();

            final List<CollectedUserData> dataList = (users
                    ?.map((e) {
                      if (e is StudentModel) {
                        return CollectedUserData(purpose: e.purpose ?? '', service: e.service ?? '', machine: e.machine ?? '', userData: e);
                      } else if (e is MakerModel) {
                        return CollectedUserData(purpose: e.purpose ?? '', service: e.service ?? '', machine: e.machine ?? '', userData: e);
                      }
                      return null;
                    })
                    .whereType<CollectedUserData>()
                    .toList()) ??
                [];

            if (dataList.isEmpty) {
              return const Center(
                child: Text('No Data Yet'),
              );
            }

            final UserDataSource userDataSource = UserDataSource(dataList: dataList);
            return ListView(
              padding: const EdgeInsets.only(left: 16.0, top: 16, right: 16),
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
                  headerRowHeight: 80,
                  showHorizontalScrollbar: true,
                  showVerticalScrollbar: true,
                  source: userDataSource,
                  columnWidthMode: ColumnWidthMode.fill,
                  allowColumnsResizing: true,
                  columnResizeMode: ColumnResizeMode.onResize,
                  columns: <GridColumn>[
                    GridColumn(
                      columnName: 'name',
                      columnWidthMode: ColumnWidthMode.fitByCellValue,
                      label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.centerLeft,
                        child: const Text('Full Name'),
                      ),
                    ),
                    GridColumn(
                      columnName: 'datetime',
                      columnWidthMode: ColumnWidthMode.fitByCellValue,
                      label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.centerLeft,
                        child: const Text('Date and Time'),
                      ),
                    ),
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
                        label: Container(padding: const EdgeInsets.all(8.0), alignment: Alignment.centerLeft, child: const Text('Service'))),
                    GridColumn(
                        columnName: 'machine',
                        label: Container(
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              'Machine',
                              overflow: TextOverflow.ellipsis,
                            ))),

                    //               DataGridCell<String>(columnName: 'affiliation', value: (data.userData as MakerModel).affiliation),
                    // DataGridCell<String>(columnName: 'contact number', value: (data.userData as MakerModel).contactNumber),
                    // DataGridCell<String>(columnName: 'user type', value: (data.userData as MakerModel).userType),
                    // DataGridCell<String>(columnName: 'company name', value: (data.userData as MakerModel).companyName),
                    // DataGridCell<String>(columnName: 'email', value: (data.userData as MakerModel).email),
                    // DataGridCell<String>(columnName: 'gender', value: (data.userData as MakerModel).gender),
                    // DataGridCell<String>(columnName: 'minority', valu
                    GridColumn(
                      columnName: 'student id/affiliation',
                      columnWidthMode: ColumnWidthMode.fitByCellValue,
                      label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.centerLeft,
                        child: const Text('Student ID/Affiliation'),
                      ),
                    ),
                    GridColumn(
                      columnName: 'contact number',
                      columnWidthMode: ColumnWidthMode.fitByCellValue,
                      label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.centerLeft,
                        child: const Text('Contact Number'),
                      ),
                    ),
                    GridColumn(
                      columnName: 'company name/academic program',
                      columnWidthMode: ColumnWidthMode.fitByCellValue,
                      label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.centerLeft,
                        child: const Text('Company Name/Academic Program'),
                      ),
                    ),
                    GridColumn(
                      columnName: 'user type/academe',
                      columnWidthMode: ColumnWidthMode.fitByCellValue,
                      label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.centerLeft,
                        child: const Text('User Type/Academe'),
                      ),
                    ),
                    GridColumn(
                      columnName: 'email',
                      columnWidthMode: ColumnWidthMode.fitByCellValue,
                      label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.centerLeft,
                        child: const Text('Email'),
                      ),
                    ),
                    GridColumn(
                      columnName: 'gender',
                      columnWidthMode: ColumnWidthMode.fitByCellValue,
                      label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.centerLeft,
                        child: const Text('gender'),
                      ),
                    ),
                    GridColumn(
                      columnName: 'minority',
                      columnWidthMode: ColumnWidthMode.fitByCellValue,
                      label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.centerLeft,
                        child: const Text('Minority'),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FloatingActionButton(
            onPressed: () {
              context.router.push(const PurposeAndServicesRoute());
            },
            backgroundColor: Colors.amber,
            child: const Icon(
              Icons.add,
            ),
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
  List<DataGridRow> get rows {
    return dataList
        .map<DataGridRow>((data) => DataGridRow(cells: [
              if (data.userData is MakerModel) ...[
                DataGridCell<String>(columnName: 'name', value: (data.userData as MakerModel).fullName),
                DataGridCell<String>(columnName: 'datetime', value: (data.userData as MakerModel).dateTime),
                DataGridCell<String>(columnName: 'purpose', value: (data.userData as MakerModel).purpose),
                DataGridCell<String>(columnName: 'service', value: (data.userData as MakerModel).service),
                DataGridCell<String>(columnName: 'machine', value: (data.userData as MakerModel).machine),
                DataGridCell<String>(columnName: 'student id/affiliation', value: (data.userData as MakerModel).affiliation),
                DataGridCell<String>(columnName: 'contact number', value: (data.userData as MakerModel).contactNumber),
                DataGridCell<String>(columnName: 'company name/academic program', value: (data.userData as MakerModel).companyName),
                DataGridCell<String>(columnName: 'user type/academe', value: (data.userData as MakerModel).userType),
                DataGridCell<String>(columnName: 'email', value: (data.userData as MakerModel).email),
                DataGridCell<String>(columnName: 'gender', value: (data.userData as MakerModel).gender),
                DataGridCell<String>(columnName: 'minority', value: (data.userData as MakerModel).minority),
              ],
              if (data.userData is StudentModel) ...[
                DataGridCell<String>(columnName: 'name', value: (data.userData as StudentModel).fullName),
                DataGridCell<String>(columnName: 'datetime', value: (data.userData as StudentModel).dateTime),
                DataGridCell<String>(columnName: 'purpose', value: (data.userData as StudentModel).purpose),
                DataGridCell<String>(columnName: 'service', value: (data.userData as StudentModel).service),
                DataGridCell<String>(columnName: 'machine', value: (data.userData as StudentModel).machine),
                DataGridCell<String>(columnName: 'student id/affiliation', value: (data.userData as StudentModel).studentId),
                DataGridCell<String>(columnName: 'contact number', value: (data.userData as StudentModel).contactNumber),
                DataGridCell<String>(columnName: 'company name/academic program', value: (data.userData as StudentModel).academicProgram),
                DataGridCell<String>(columnName: 'user type/academe', value: (data.userData as StudentModel).academe),
                DataGridCell<String>(columnName: 'email', value: (data.userData as StudentModel).universityEmail),
                DataGridCell<String>(columnName: 'gender', value: (data.userData as StudentModel).gender),
                DataGridCell<String>(columnName: 'minority', value: (data.userData as StudentModel).minority),
              ]
            ]))
        .toList();
  }

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
