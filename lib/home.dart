import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jmaker_qrscanner_mobile/purposePage.dart';
import 'package:jmaker_qrscanner_mobile/qr_scanner.dart';
import 'package:jmaker_qrscanner_mobile/styles/buttons.dart';
import 'package:jmaker_qrscanner_mobile/styles/text_style.dart';



class home extends StatelessWidget {
  const home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 200),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Image.asset('assets/image/jmaker_symbol.png',
                    height: 100),
                    SizedBox(height: 16),
                    Text('FabLab Attendance Management System',
                      style: CustomTextStyle.primaryBlack,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 48),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    style: yellowPrimary,
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PurposeAndServices()),
                      );
                    },
                      child: Text('Proceed',
                      style: CustomTextStyle.primaryBlack),
                  ),
                ),
              ),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
