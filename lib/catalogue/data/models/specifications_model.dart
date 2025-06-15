import '../../domain/entities/component.dart';

class SpecificationsModel {
  final String socket;
  final String memoryType;
  final int powerConsumptionWatts;
  final String formFactor;

  SpecificationsModel({
    required this.socket,
    required this.memoryType,
    required this.powerConsumptionWatts,
    required this.formFactor,
  });

  factory SpecificationsModel.fromJson(Map<String, dynamic> json) {
    return SpecificationsModel(
      socket: json['socket'],
      memoryType: json['memoryType'],
      powerConsumptionWatts: json['powerConsumptionWatts'],
      formFactor: json['formFactor'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'socket': socket,
      'memoryType': memoryType,
      'powerConsumptionWatts': powerConsumptionWatts,
      'formFactor': formFactor,
    };
  }

  Specifications toEntity() {
    return Specifications(
      socket: socket,
      memoryType: memoryType,
      powerConsumptionWatts: powerConsumptionWatts,
      formFactor: formFactor,
    );
  }

  static SpecificationsModel fromEntity(Specifications entity) {
    return SpecificationsModel(
      socket: entity.socket,
      memoryType: entity.memoryType,
      powerConsumptionWatts: entity.powerConsumptionWatts,
      formFactor: entity.formFactor,
    );
  }
}