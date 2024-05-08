// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i5;
import 'package:flutter/material.dart' as _i6;
import 'package:jmaker_qrscanner_mobile/views/attendance_list_syncfusion_screen.dart'
    as _i1;
import 'package:jmaker_qrscanner_mobile/views/home_screen.dart' as _i2;
import 'package:jmaker_qrscanner_mobile/views/purpose_screen.dart' as _i3;
import 'package:jmaker_qrscanner_mobile/views/qr_scanner_screen.dart' as _i4;

abstract class $AppRouter extends _i5.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i5.PageFactory> pagesMap = {
    DataDisplayRouteSyncfusionRoute.name: (routeData) {
      final args = routeData.argsAs<DataDisplayRouteSyncfusionRouteArgs>(
          orElse: () => const DataDisplayRouteSyncfusionRouteArgs());
      return _i5.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i1.DataDisplayPageSyncfusionScreen(key: args.key),
      );
    },
    HomeRoute.name: (routeData) {
      return _i5.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.HomeScreen(),
      );
    },
    PurposeAndServicesRoute.name: (routeData) {
      return _i5.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.PurposeAndServicesScreen(),
      );
    },
    QRScannerRoute.name: (routeData) {
      final args = routeData.argsAs<QRScannerRouteArgs>();
      return _i5.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i4.QRScannerScreen(
          key: args.key,
          selectedPurpose: args.selectedPurpose,
          selectedService: args.selectedService,
          selectedMachine: args.selectedMachine,
        ),
      );
    },
  };
}

/// generated route for
/// [_i1.DataDisplayPageSyncfusionScreen]
class DataDisplayRouteSyncfusionRoute
    extends _i5.PageRouteInfo<DataDisplayRouteSyncfusionRouteArgs> {
  DataDisplayRouteSyncfusionRoute({
    _i6.Key? key,
    List<_i5.PageRouteInfo>? children,
  }) : super(
          DataDisplayRouteSyncfusionRoute.name,
          args: DataDisplayRouteSyncfusionRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'DataDisplayRouteSyncfusionRoute';

  static const _i5.PageInfo<DataDisplayRouteSyncfusionRouteArgs> page =
      _i5.PageInfo<DataDisplayRouteSyncfusionRouteArgs>(name);
}

class DataDisplayRouteSyncfusionRouteArgs {
  const DataDisplayRouteSyncfusionRouteArgs({this.key});

  final _i6.Key? key;

  @override
  String toString() {
    return 'DataDisplayRouteSyncfusionRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i2.HomeScreen]
class HomeRoute extends _i5.PageRouteInfo<void> {
  const HomeRoute({List<_i5.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const _i5.PageInfo<void> page = _i5.PageInfo<void>(name);
}

/// generated route for
/// [_i3.PurposeAndServicesScreen]
class PurposeAndServicesRoute extends _i5.PageRouteInfo<void> {
  const PurposeAndServicesRoute({List<_i5.PageRouteInfo>? children})
      : super(
          PurposeAndServicesRoute.name,
          initialChildren: children,
        );

  static const String name = 'PurposeAndServicesRoute';

  static const _i5.PageInfo<void> page = _i5.PageInfo<void>(name);
}

/// generated route for
/// [_i4.QRScannerScreen]
class QRScannerRoute extends _i5.PageRouteInfo<QRScannerRouteArgs> {
  QRScannerRoute({
    _i6.Key? key,
    required String selectedPurpose,
    required String selectedService,
    required String selectedMachine,
    List<_i5.PageRouteInfo>? children,
  }) : super(
          QRScannerRoute.name,
          args: QRScannerRouteArgs(
            key: key,
            selectedPurpose: selectedPurpose,
            selectedService: selectedService,
            selectedMachine: selectedMachine,
          ),
          initialChildren: children,
        );

  static const String name = 'QRScannerRoute';

  static const _i5.PageInfo<QRScannerRouteArgs> page =
      _i5.PageInfo<QRScannerRouteArgs>(name);
}

class QRScannerRouteArgs {
  const QRScannerRouteArgs({
    this.key,
    required this.selectedPurpose,
    required this.selectedService,
    required this.selectedMachine,
  });

  final _i6.Key? key;

  final String selectedPurpose;

  final String selectedService;

  final String selectedMachine;

  @override
  String toString() {
    return 'QRScannerRouteArgs{key: $key, selectedPurpose: $selectedPurpose, selectedService: $selectedService, selectedMachine: $selectedMachine}';
  }
}
