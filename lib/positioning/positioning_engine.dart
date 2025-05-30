/*
 * Copyright (C) 2020-2025 HERE Europe B.V.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * SPDX-License-Identifier: Apache-2.0
 * License-Filename: LICENSE
 */

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/location.dart';
import 'package:here_sdk_reference_application_flutter/common/device_info.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../common/application_preferences.dart';
import 'here_privacy_notice_handler.dart';

/// Class that implements logic for positioning. It asks for user consent, obtains the necessary permissions,
/// and provides current location updates.
/// The current implementation will only ask for user consent on Android devices.
class PositioningEngine {
  static const int _locationServicePeriodicDurationInSeconds = 3;
  static const int _androidApiLevel30 = 30;
  LocationEngine? _locationEngine;

  StreamController<Location> _locationUpdatesController = StreamController.broadcast();
  StreamController<LocationEngineStatus> _locationEngineStatusController = StreamController.broadcast();

  /// Initializes the location engine.
  Future initLocationEngine({required BuildContext context}) async {
    return _initialize(context);
  }

  /// Gets last known location.
  Location? get lastKnownLocation => _locationEngine?.lastKnownLocation;

  /// Gets the state of the location engine.
  bool get isLocationEngineStarted => _locationEngine != null ? _locationEngine!.isStarted : false;

  /// Gets stream with location updates.
  Stream<Location> get getLocationUpdates => _locationUpdatesController.stream;

  /// Gets stream with location engine status updates.
  Stream<LocationEngineStatus> get getLocationEngineStatusUpdates => _locationEngineStatusController.stream;

  /// Returns [true] by check if permission location service status is enabled.
  Future<bool> get _didLocationServicesEnabled => Permission.location.serviceStatus.isEnabled;

  /// This flag helps to request the location permission, when location service status is enabled.
  bool _didLocationPermissionsRequested = false;

  Future<void> _initialize(BuildContext context) async {
    /// Important: This dialog is required to inform users about HERE SDK's privacy terms,
    /// and must be accepted before calling `confirmHEREPrivacyNoticeInclusion()` and initializing the LocationEngine.
    ///
    /// This check determines whether the HERE Privacy Notice dialog has already been shown.
    /// Defaults to false if the key does not exist (e.g., on first app launch).
    if (!Provider.of<AppPreferences>(context, listen: false).isHerePrivacyDialogShown) {
      // Show the dialog if it hasn't been shown before.
      await showHerePrivacyDialog(context);
    }

    final didLocationServicesEnabled = await _didLocationServicesEnabled;

    // Check location services status
    if (!didLocationServicesEnabled) {
      _locationEngineStatusController.add(LocationEngineStatus.notAllowed);
    } else if (didLocationServicesEnabled && !await _requestLocationPermissions()) {
      _didLocationPermissionsRequested = true;
      // Request location permission on engine creation.
      _locationEngineStatusController.add(LocationEngineStatus.missingPermissions);
    } else {
      await _createLocationEngineIfPermissionsGranted();
    }
    _checkLocationServicesPeriodically();
  }

  /// Periodically checks location services and permissions.
  /// Creates a location engine if all necessary permissions are
  /// granted and engine is not already created.
  void _checkLocationServicesPeriodically() {
    Future.delayed(Duration(seconds: _locationServicePeriodicDurationInSeconds), () async {
      await _checkLocationServicesStatus();
      _checkLocationServicesPeriodically();
    });
  }

  /// Requests [Permission.location] and [Permission.locationAlways].
  /// Returns [true] if both [Permission.location] and [Permission.locationAlways]
  /// are granted, otherwise returns [false].
  ///
  /// Returns [false] if location services is not enabled.
  Future<bool> _requestLocationPermissions() async {
    if (await _didLocationServicesEnabled) {
      final PermissionStatus locationPermission = await Permission.location.request();
      PermissionStatus locationAlwaysPermission = await Permission.locationAlways.request();
      if (Platform.isAndroid && await getAndroidApiVersion() >= _androidApiLevel30) {
        // Checking background location permission status again because result of request is denied even if user granted
        // this permission (on Android 11). It looks like a permission_handler plugin bug.
        locationAlwaysPermission = await Permission.locationAlways.status;
      }
      return locationPermission == PermissionStatus.granted && locationAlwaysPermission == PermissionStatus.granted;
    } else {
      return false;
    }
  }

  /// Returns [true] if both [Permission.location] and [Permission.locationAlways]
  /// are granted, otherwise returns [false].
  ///
  /// Returns [false] if location services is not enabled.
  Future<bool> _didLocationPermissionsGranted() async {
    if (!await _didLocationServicesEnabled) {
      return false;
    }

    final bool isLocationPermissionGranted = await Permission.location.isGranted;
    if (Platform.isAndroid && await getAndroidApiVersion() >= _androidApiLevel30) {
      // Checking background location permission status again because result of request is denied even if user granted
      // this permission (on Android 11). It looks like a permission_handler plugin bug.
      final bool isLocationAlwaysPermissionGranted = await Permission.locationAlways.status.isGranted;
      return isLocationPermissionGranted && isLocationAlwaysPermissionGranted;
    }
    return isLocationPermissionGranted;
  }

  void _createAndInitLocationEngine() {
    _locationEngine = LocationEngine();
    _locationUpdatesController.onCancel = () => _locationEngine!.stop();
    _locationEngine!.setBackgroundLocationAllowed(false);
    _locationEngine!.addLocationListener(LocationListener((location) => _locationUpdatesController.add(location)));
    _locationEngine!.addLocationStatusListener(LocationStatusListener(
      (status) => _locationEngineStatusController.add(status),
      (features) {},
    ));

    /// Important: The HERE Privacy Notice must be shown and accepted by the user
    /// before starting the LocationEngine. Ensure the FTU/privacy screen is displayed
    /// at app start-up. This method must be called every time before starting the engine.
    _locationEngine!.confirmHEREPrivacyNoticeInclusion();
    _locationEngine!.startWithLocationAccuracy(LocationAccuracy.bestAvailable);
  }

  /// Creates and initialises the location engine if all required permissions
  /// are granted.
  Future<void> _createLocationEngineIfPermissionsGranted() async {
    if (await _didLocationPermissionsGranted()) {
      // The required permissions have been granted, let's start the location engine
      _createAndInitLocationEngine();
    } else if (!_didLocationPermissionsRequested) {
      _didLocationPermissionsRequested = true;
      final isGranted = await _requestLocationPermissions();
      if (!isGranted) {
        _locationEngineStatusController.add(LocationEngineStatus.missingPermissions);
      }
    }
  }

  Future<void> _checkLocationServicesStatus() async {
    final bool didLocationServicesEnabled = await _didLocationServicesEnabled;
    if (didLocationServicesEnabled && _locationEngine != null) {
      return; // As location engine is already created, we do not need to create a new one.
    }
    if (didLocationServicesEnabled) {
      await _createLocationEngineIfPermissionsGranted();
    }
  }
}
