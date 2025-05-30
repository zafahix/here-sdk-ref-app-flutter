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

import 'package:flutter/material.dart';

/// A widget that displays a toggle button.
class RoutePoiOptionsItem extends StatefulWidget {
  /// Checkbox value.
  final bool value;

  /// Title of the button.
  final Widget title;

  /// Called when the value is changed.
  final ValueChanged<bool> onChanged;

  /// Constructs a widget.
  RoutePoiOptionsItem({
    this.value = false,
    required this.title,
    required this.onChanged,
  });

  @override
  _RoutePoiOptionsItemState createState() => _RoutePoiOptionsItemState();
}

class _RoutePoiOptionsItemState extends State<RoutePoiOptionsItem> {
  late bool _value;

  @override
  void initState() {
    _value = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      value: _value,
      title: widget.title,
      onChanged: (value) {
        setState(() => _value = value);
        widget.onChanged(value);
      },
    );
  }
}
