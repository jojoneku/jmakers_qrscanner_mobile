import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jmaker_qrscanner_mobile/routes/app_router.gr.dart';
import 'package:jmaker_qrscanner_mobile/styles/buttons.dart';
import 'package:jmaker_qrscanner_mobile/styles/color.dart';
import 'package:jmaker_qrscanner_mobile/styles/text_style.dart';

@RoutePage()
class PurposeAndServicesScreen extends StatefulWidget {
  const PurposeAndServicesScreen({super.key});

  @override
  State<PurposeAndServicesScreen> createState() => _PurposeAndServicesScreenState();
}

class _PurposeAndServicesScreenState extends State<PurposeAndServicesScreen> {
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
    "Others",
  ];

  List<String> serviceOptions = [
    "Digital Fabrication",
    "Design Development/Consultation",
    "Product Development/Prototyping",
    "Workshop/Training",
    "Benchmark & Tours",
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
      context.router.push(QRScannerRoute(
        selectedPurpose: selectedPurposeValue,
        selectedService: selectedServiceValue,
        selectedMachine: selectedMachineValue,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainYellow,
        title: const Text('Purpose and Services'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 32),
              Image.asset('assets/image/landingvector.png', height: 200),
              const SizedBox(height: 32),
              Column(
                children: [
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
                  const SizedBox(height: 24),
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
                  const SizedBox(height: 24),
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
                  const SizedBox(height: 24),
                ],
              ),
              if (errorText != null)
                Text(
                  errorText!,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 32),
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
