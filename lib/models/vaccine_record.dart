import 'dart:convert';

enum VaccineStatus {
  completed,
  upcoming,
  overdue,
}

class VaccineRecord {
  final String id;
  final String childId;
  final String vaccineName;
  final String diseasePrevented;
  final String doseNumber; // e.g. "Dose 1", "Booster"
  final DateTime dueDate;
  final DateTime? administeredDate;
  final VaccineStatus status;
  final String? administeredLocation;
  final String? notes;
  final String? batchNumber;

  VaccineRecord({
    required this.id,
    required this.childId,
    required this.vaccineName,
    required this.diseasePrevented,
    required this.doseNumber,
    required this.dueDate,
    this.administeredDate,
    required this.status,
    this.administeredLocation,
    this.notes,
    this.batchNumber,
  });

  bool get isCompleted => status == VaccineStatus.completed;
  bool get isOverdue => status == VaccineStatus.overdue;
  bool get isUpcoming => status == VaccineStatus.upcoming;

  VaccineRecord copyWith({
    String? id,
    String? childId,
    String? vaccineName,
    String? diseasePrevented,
    String? doseNumber,
    DateTime? dueDate,
    DateTime? administeredDate,
    VaccineStatus? status,
    String? administeredLocation,
    String? notes,
    String? batchNumber,
  }) {
    return VaccineRecord(
      id: id ?? this.id,
      childId: childId ?? this.childId,
      vaccineName: vaccineName ?? this.vaccineName,
      diseasePrevented: diseasePrevented ?? this.diseasePrevented,
      doseNumber: doseNumber ?? this.doseNumber,
      dueDate: dueDate ?? this.dueDate,
      administeredDate: administeredDate ?? this.administeredDate,
      status: status ?? this.status,
      administeredLocation: administeredLocation ?? this.administeredLocation,
      notes: notes ?? this.notes,
      batchNumber: batchNumber ?? this.batchNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'childId': childId,
      'vaccineName': vaccineName,
      'diseasePrevented': diseasePrevented,
      'doseNumber': doseNumber,
      'dueDate': dueDate.toIso8601String(),
      'administeredDate': administeredDate?.toIso8601String(),
      'status': status.name,
      'administeredLocation': administeredLocation,
      'notes': notes,
      'batchNumber': batchNumber,
    };
  }

  factory VaccineRecord.fromMap(Map<String, dynamic> map) {
    return VaccineRecord(
      id: map['id'] ?? '',
      childId: map['childId'] ?? '',
      vaccineName: map['vaccineName'] ?? '',
      diseasePrevented: map['diseasePrevented'] ?? '',
      doseNumber: map['doseNumber'] ?? 'Dose 1',
      dueDate: DateTime.parse(map['dueDate']),
      administeredDate: map['administeredDate'] != null
          ? DateTime.parse(map['administeredDate'])
          : null,
      status: VaccineStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => VaccineStatus.upcoming,
      ),
      administeredLocation: map['administeredLocation'],
      notes: map['notes'],
      batchNumber: map['batchNumber'],
    );
  }

  String toJson() => json.encode(toMap());

  factory VaccineRecord.fromJson(String source) =>
      VaccineRecord.fromMap(json.decode(source));
}
