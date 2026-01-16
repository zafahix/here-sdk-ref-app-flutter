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

import 'package:here_sdk/routing.dart';
import 'package:here_sdk/transport.dart';
import 'package:here_sdk_reference_application_flutter/l10n/generated/app_localizations.dart';

extension TruckOptionsUtil on TruckOptions {
  TruckOptions copyTruckOptionsWith({
    required TruckSpecifications truckSpecifications,
  }) {
    return TruckOptions()
      ..routeOptions = routeOptions
      ..textOptions = textOptions
      ..avoidanceOptions = avoidanceOptions
      ..truckSpecifications = truckSpecifications
      ..linkTunnelCategory = linkTunnelCategory
      ..hazardousMaterials = hazardousMaterials;
  }
}

extension TruckSpecificationsUtils on TruckSpecifications {
  TruckSpecifications copyTruckSpecificationsWith({
    String? grossWeightInKilograms,
    String? currentWeightInKilograms,
    String? weightPerAxleInKilograms,
    WeightPerAxleGroup? weightPerAxleGroup,
    String? heightInCentimeters,
    String? widthInCentimeters,
    String? lengthInCentimeters,
    String? axleCount,
    String? trailerCount,
    bool? isTruckLight,
    TruckType? truckType,
    String? payloadCapacityInKilograms,
    String? trailerAxleCount,
  }) {
    int? _parse(String? value, int? fallback) =>
        value != null ? int.tryParse(value) : fallback;

    return TruckSpecifications.withDefaults()
      ..grossWeightInKilograms = _parse(
        grossWeightInKilograms,
        this.grossWeightInKilograms,
      )
      ..currentWeightInKilograms = _parse(
        currentWeightInKilograms,
        this.currentWeightInKilograms,
      )
      ..weightPerAxleInKilograms = _parse(
        weightPerAxleInKilograms,
        this.weightPerAxleInKilograms,
      )
      ..weightPerAxleGroup = weightPerAxleGroup ?? this.weightPerAxleGroup
      ..heightInCentimeters = _parse(
        heightInCentimeters,
        this.heightInCentimeters,
      )
      ..widthInCentimeters = _parse(widthInCentimeters, this.widthInCentimeters)
      ..lengthInCentimeters = _parse(
        lengthInCentimeters,
        this.lengthInCentimeters,
      )
      ..axleCount = _parse(axleCount, this.axleCount)
      ..isTruckLight = isTruckLight ?? this.isTruckLight
      ..truckType = truckType ?? this.truckType
      ..trailerCount = _parse(trailerCount, this.trailerCount)
      ..trailerAxleCount = _parse(trailerAxleCount, this.trailerAxleCount)
      ..payloadCapacityInKilograms = _parse(
        payloadCapacityInKilograms,
        this.payloadCapacityInKilograms,
      );
  }

  String specificationsString(AppLocalizations localizations) {
    final specs = <String>[];

    void addSpec(String? label, Object? value) {
      if (value != null) {
        specs.add('$label = $value');
      }
    }

    addSpec(localizations.truckAxleCountRowTitle, axleCount);
    addSpec(localizations.truckCurrentWeightRowTitle, currentWeightInKilograms);
    addSpec(localizations.truckGrossWeightRowTitle, grossWeightInKilograms);
    addSpec(localizations.truckHeightRowTitle, heightInCentimeters);
    addSpec(localizations.truckLengthRowTitle, lengthInCentimeters);
    addSpec(localizations.payloadCapacity, payloadCapacityInKilograms);
    addSpec(localizations.truckSpecTrailerAxleCount, trailerAxleCount);
    addSpec(localizations.truckSpecTrailerCount, trailerCount);
    addSpec(localizations.truckWeightPerAxleRowTitle, weightPerAxleInKilograms);
    addSpec(localizations.truckWidthRowTitle, widthInCentimeters);

    if (weightPerAxleGroup != null) {
      addSpec(
        localizations.singleAxleGroup,
        weightPerAxleGroup!.singleAxleGroupInKilograms,
      );
      addSpec(
        localizations.tandemAxleGroup,
        weightPerAxleGroup!.tandemAxleGroupInKilograms,
      );
      addSpec(
        localizations.tripleAxleGroup,
        weightPerAxleGroup!.tripleAxleGroupInKilograms,
      );
      addSpec(
        localizations.quadAxleGroup,
        weightPerAxleGroup!.quadAxleGroupInKilograms,
      );
      addSpec(
        localizations.quintAxleGroup,
        weightPerAxleGroup!.quintAxleGroupInKilograms,
      );
    }

    return specs.join(', ');
  }
}

extension WeightPerAxleGroupUtils on WeightPerAxleGroup {
  WeightPerAxleGroup? copyWeightPerAxleGroupWith({
    String? singleAxleGroupInKilograms,
    String? tandemAxleGroupInKilograms,
    String? tripleAxleGroupInKilograms,
    String? quadAxleGroupInKilograms,
    String? quintAxleGroupInKilograms,
  }) {
    return WeightPerAxleGroup()
      ..singleAxleGroupInKilograms = singleAxleGroupInKilograms != null
          ? int.tryParse(singleAxleGroupInKilograms) ?? null
          : this.singleAxleGroupInKilograms
      ..tandemAxleGroupInKilograms = tandemAxleGroupInKilograms != null
          ? int.tryParse(tandemAxleGroupInKilograms) ?? null
          : this.tandemAxleGroupInKilograms
      ..tripleAxleGroupInKilograms = tripleAxleGroupInKilograms != null
          ? int.tryParse(tripleAxleGroupInKilograms) ?? null
          : this.tripleAxleGroupInKilograms
      ..quadAxleGroupInKilograms = quadAxleGroupInKilograms != null
          ? int.tryParse(quadAxleGroupInKilograms) ?? null
          : this.quadAxleGroupInKilograms
      ..quintAxleGroupInKilograms = quintAxleGroupInKilograms != null
          ? int.tryParse(quintAxleGroupInKilograms) ?? null
          : this.quintAxleGroupInKilograms;
  }
}
