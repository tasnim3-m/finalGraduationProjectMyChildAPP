class VaccineScheduleModel {
  final String vaccineName;
  final int doseNumber;
  final DateTime validFrom;
  final DateTime validTo;
  final int maxDelayDays;
   final String status;

  VaccineScheduleModel({
    required this.vaccineName,
    required this.doseNumber,
    required this.validFrom,
    required this.validTo,
    required this.maxDelayDays,
    required this.status,
  });
factory VaccineScheduleModel.fromMap(Map<String, dynamic> map) {
  return VaccineScheduleModel(
    vaccineName: map['vaccineName'],
    doseNumber: map['doseNumber'],
    validFrom: DateTime.parse(map['validFrom']),
    validTo: DateTime.parse(map['validTo']),
    maxDelayDays: map['maxDelayDays'],
    status: map['status'],  // تضمين status
  );
}

Map<String, dynamic> toMap() {
  return {
    'vaccineName': vaccineName,
    'doseNumber': doseNumber,
    'validFrom': validFrom.toIso8601String(),
    'validTo': validTo.toIso8601String(),
    'maxDelayDays': maxDelayDays,
    'status': status,  // تضمين status
  };
}

  @override
  String toString() {
    return '💉 $vaccineName | Dose: $doseNumber | From: $validFrom | To: $validTo | Delay: $maxDelayDays days';
  }
}