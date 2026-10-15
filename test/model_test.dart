import 'package:flutter_test/flutter_test.dart';
import 'package:vaxicare/models/child_profile.dart';
import 'package:vaxicare/models/vaccine_record.dart';

void main() {
  group('ChildProfile Unit Tests', () {
    test('Calculates age formatted correctly for infant', () {
      final now = DateTime.now();
      final child = ChildProfile(
        id: 'test_child_1',
        name: 'Baby Sharma',
        dateOfBirth: DateTime(now.year, now.month - 3, now.day),
        gender: 'Male',
        bloodGroup: 'B+',
      );

      expect(child.ageInMonths, equals(3));
      expect(child.ageFormatted, contains('months old'));
    });

    test('Serializes to and from Map correctly', () {
      final dob = DateTime(2025, 5, 10);
      final child = ChildProfile(
        id: 'c1',
        name: 'Rohan',
        dateOfBirth: dob,
        gender: 'Male',
        bloodGroup: 'O+',
        avatarEmoji: '👦',
      );

      final map = child.toMap();
      final reconstructed = ChildProfile.fromMap(map);

      expect(reconstructed.id, equals('c1'));
      expect(reconstructed.name, equals('Rohan'));
      expect(reconstructed.gender, equals('Male'));
      expect(reconstructed.bloodGroup, equals('O+'));
      expect(reconstructed.avatarEmoji, equals('👦'));
    });
  });

  group('VaccineRecord Unit Tests', () {
    test('Correctly checks status properties', () {
      final now = DateTime.now();
      final recordUpcoming = VaccineRecord(
        id: 'v1',
        childId: 'c1',
        vaccineName: 'Polio',
        diseasePrevented: 'Poliomyelitis',
        doseNumber: 'Dose 1',
        dueDate: now.add(const Duration(days: 7)),
        status: VaccineStatus.upcoming,
      );

      expect(recordUpcoming.isUpcoming, isTrue);
      expect(recordUpcoming.isCompleted, isFalse);
      expect(recordUpcoming.isOverdue, isFalse);

      final recordCompleted = recordUpcoming.copyWith(
        status: VaccineStatus.completed,
        administeredDate: now,
      );

      expect(recordCompleted.isCompleted, isTrue);
      expect(recordCompleted.isUpcoming, isFalse);
    });

    test('Serializes and deserializes correctly', () {
      final now = DateTime.now();
      final record = VaccineRecord(
        id: 'v2',
        childId: 'c1',
        vaccineName: 'MMR',
        diseasePrevented: 'Measles',
        doseNumber: 'Dose 1',
        dueDate: now,
        status: VaccineStatus.overdue,
        notes: 'Needs doctor consult',
      );

      final map = record.toMap();
      final fromMap = VaccineRecord.fromMap(map);

      expect(fromMap.id, equals('v2'));
      expect(fromMap.vaccineName, equals('MMR'));
      expect(fromMap.status, equals(VaccineStatus.overdue));
      expect(fromMap.notes, equals('Needs doctor consult'));
    });
  });
}
