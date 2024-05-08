import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jmaker_qrscanner_mobile/routes/app_router.gr.dart';
import 'package:jmaker_qrscanner_mobile/styles/buttons.dart';
import 'package:jmaker_qrscanner_mobile/styles/text_style.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 200),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Image.asset('assets/image/jmaker_symbol.png', height: 100),
                    const SizedBox(height: 16),
                    Text(
                      'FabLab Attendance Management System',
                      style: CustomTextStyle.primaryBlack,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    style: yellowPrimary,
                    onPressed: () {
                      context.router.push(DataDisplayRouteSyncfusionRoute());
                    },
                    child: Text('Proceed', style: CustomTextStyle.primaryBlack),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
