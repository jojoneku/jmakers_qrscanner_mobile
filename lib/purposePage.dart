import 'package:flutter/material.dart';
import 'package:jmaker_qrscanner_mobile/qr_scanner.dart';
import 'package:jmaker_qrscanner_mobile/styles/buttons.dart';
import 'package:jmaker_qrscanner_mobile/styles/color.dart';
import 'package:jmaker_qrscanner_mobile/styles/text_style.dart';


class PurposeAndServices extends StatefulWidget {
  @override
  _PurposeAndServicesState createState() => _PurposeAndServicesState();
}

class _PurposeAndServicesState extends State<PurposeAndServices> {
  String? selectedPurpose;
  String? selectedService;
  String? selectedMachine;
  String? errorText;

  List<String> purposeOptions = [
    "School Project",
    "Research",
    "Business",
    "For Startup Product Development",
    "Personal DIY",
    "Community Project",
    "Company/Org. Event",
  ];

  List<String> serviceOptions = [
    "Digital Fabrication",
    "Design Development/Consultation",
    "Project Development/Prototyping",
    "Workshop Training",
    "Benchmark",
  ];

  List<String> machineOptions = [
    "None",
    "3D Printer",
    "3D Scanner",
    "Laser Cutter",
    "Vinyl Cutter",
    "Vacuum Forming",
    "Embroidery Machine",
    "CNC Milling",
    "CNC Shopbot",
    "Print and Cut",
  ];

  void _submitForm() {
    if (selectedPurpose == null || selectedService == null || selectedMachine == null) {
      setState(() {
        errorText = 'Please select all options';
      });
    } else {
      // Store selected options in variables for later use
      String selectedPurposeValue = selectedPurpose!;
      String selectedServiceValue = selectedService!;
      String selectedMachineValue = selectedMachine!;

      // Navigate to the next page and pass data
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => QRScanner(
            selectedPurpose: selectedPurposeValue,
            selectedService: selectedServiceValue,
            selectedMachine: selectedMachineValue,
          ),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainYellow,
        title: Text('Purpose and Services'),
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
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset('assets/image/landingvector.png',
              height: 350),
              DropdownButtonFormField<String>(
                value: selectedPurpose,
                hint: const Text('Select Purpose'),
                items: purposeOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedPurpose = value;
                  });
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedService,
                hint: const Text('Select Service'),
                items: serviceOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedService = value;
                  });
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedMachine,
                hint: const Text('Select Machine to be Used'),
                items: machineOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedMachine = value;
                  });
                },
              ),
              SizedBox(height: 16),
              if (errorText != null)
                Text(
                  errorText!,
                  style: TextStyle(color: Colors.red),
                ),
              SizedBox(height: 32),
              ElevatedButton(
                style: selectedPurpose != null && selectedService != null && selectedMachine != null
                    ? longYellow // Yellow color when all dropdowns have selections
                    : longGrey,
                onPressed: _submitForm,
                child: Text(
                  'Submit',
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
