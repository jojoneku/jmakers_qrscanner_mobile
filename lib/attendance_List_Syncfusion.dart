import 'package:flutter/material.dart';
import 'package:jmaker_qrscanner_mobile/purposePage.dart';
import 'package:jmaker_qrscanner_mobile/styles/color.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

// Define your CollectedData class if it's not already defined
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
  final List<CollectedUserData> dataList;
  final CollectedUserData collectedData; // Add this variable

  const DataDisplayPageSyncfusion({
    Key? key,
    required this.dataList,
    required this.collectedData, // Update the constructor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserDataSource userDataSource =
    UserDataSource(dataList: dataList);

    return Scaffold(
      appBar: AppBar(
        title: Text('Data Display'),
        backgroundColor: mainYellow,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 16, right: 16),
          child: SfDataGrid(
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
                      padding: EdgeInsets.all(8.0),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Purpose',
                      ))),
              GridColumn(
                  columnName: 'service',
                  label: Container(
                      padding: EdgeInsets.all(8.0),
                      alignment: Alignment.centerLeft,
                      child: Text('Service'))),
              GridColumn(
                  columnName: 'machine',
                  label: Container(
                      padding: EdgeInsets.all(8.0),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Machine',
                        overflow: TextOverflow.ellipsis,
                      ))),
              GridColumn(
                  columnName: 'qrData',
                  columnWidthMode: ColumnWidthMode.fitByCellValue,
                  label: Container(
                      padding: EdgeInsets.all(8.0),
                      alignment: Alignment.centerLeft,
                      child: Text('QR Data'))),
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
            child: Icon(Icons.add,),
            backgroundColor: Colors.amber,

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
          padding: EdgeInsets.all(8.0),
          child: Text(dataCell.value.toString()), // Adjust this based on your cell content
        );
      }).toList(),
    );
  }
}
