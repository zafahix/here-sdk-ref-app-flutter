/*
 * Copyright (C) 2020-2026 HERE Europe B.V.
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

import 'package:flutter/material.dart';
import 'package:here_sdk_reference_application_flutter/common/hds_icons/hds_assets_paths.dart';
import 'package:here_sdk_reference_application_flutter/common/hds_icons/hds_icon_widget.dart';

/// Available transport modes currently supported by the Ref App.
/// The HERE SDK supports more transport modes than featured by this application.
enum TransportModes { car, truck, scooter, walk }

/// Widget for switching between transport modes.
class TransportModesWidget extends StatefulWidget {
  /// This widget's selection and animation state.
  final TabController tabController;

  /// List of transport modes to be shown.
  final List<TransportModes> transportModes;

  /// Constructs a widget.
  TransportModesWidget({
    Key? key,
    required this.tabController,
    this.transportModes = TransportModes.values,
  }) : super(key: key);

  @override
  State<TransportModesWidget> createState() => _TransportModesWidgetState();
}

class _TransportModesWidgetState extends State<TransportModesWidget> {
  late int _currentTabIndex;

  @override
  void initState() {
    super.initState();
    _currentTabIndex = widget.tabController.index;
    widget.tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    widget.tabController.removeListener(_handleTabChange);
    super.dispose();
  }

  void _handleTabChange() {
    if (mounted && _currentTabIndex != widget.tabController.index) {
      setState(() {
        _currentTabIndex = widget.tabController.index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: widget.tabController,
      tabs: List<Widget>.generate(widget.transportModes.length, (index) {
        /// Determine if the tab is currently selected.
        bool isSelected = _currentTabIndex == index;

        /// Theme color setup.
        ColorScheme colorScheme = Theme.of(context).colorScheme;
        Color color = isSelected
            ? colorScheme.primary
            : colorScheme.onSecondary;

        return Tab(
          icon: HdsIconWidget(widget.transportModes[index].icon, color: color),
        );
      }),
    );
  }
}

extension _TransportModeIcon on TransportModes {
  String get icon {
    switch (this) {
      case TransportModes.car:
        return HdsAssetsPaths.carDrivingIcon;
      case TransportModes.truck:
        return HdsAssetsPaths.truck;
      case TransportModes.scooter:
        return HdsAssetsPaths.scooter;
      case TransportModes.walk:
        return HdsAssetsPaths.walk;
    }
  }
}
