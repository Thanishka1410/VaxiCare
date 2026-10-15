import 'child_profile.dart';
import 'vaccine_record.dart';

class MockData {
  static List<ChildProfile> get initialProfiles {
    final now = DateTime.now();
    return [
      ChildProfile(
        id: 'child_1',
        name: 'Aarav Sharma',
        dateOfBirth: DateTime(now.year, now.month - 4, now.day - 5),
        gender: 'Male',
        bloodGroup: 'B+',
        avatarEmoji: '👦',
      ),
      ChildProfile(
        id: 'child_2',
        name: 'Ananya Sharma',
        dateOfBirth: DateTime(now.year - 2, now.month - 1, now.day + 10),
        gender: 'Female',
        bloodGroup: 'O+',
        avatarEmoji: '👧',
      ),
    ];
  }

  static List<VaccineRecord> getInitialVaccines(String child1Id, String child2Id) {
    final now = DateTime.now();

    return [
      // Aarav (4 months old)
      VaccineRecord(
        id: 'vac_1',
        childId: child1Id,
        vaccineName: 'BCG',
        diseasePrevented: 'Tuberculosis',
        doseNumber: 'Single Dose',
        dueDate: now.subtract(const Duration(days: 120)),
        administeredDate: now.subtract(const Duration(days: 119)),
        status: VaccineStatus.completed,
        administeredLocation: 'City Maternity Hospital',
        batchNumber: 'BCG-2026-90',
        notes: 'Administered at birth. Small mark visible.',
      ),
      VaccineRecord(
        id: 'vac_2',
        childId: child1Id,
        vaccineName: 'Hepatitis B (Birth)',
        diseasePrevented: 'Hepatitis B',
        doseNumber: 'Dose 1',
        dueDate: now.subtract(const Duration(days: 120)),
        administeredDate: now.subtract(const Duration(days: 119)),
        status: VaccineStatus.completed,
        administeredLocation: 'City Maternity Hospital',
        batchNumber: 'HEP-5521',
      ),
      VaccineRecord(
        id: 'vac_3',
        childId: child1Id,
        vaccineName: 'DTwP / DTaP 1',
        diseasePrevented: 'Diphtheria, Tetanus, Pertussis',
        doseNumber: 'Dose 1 (6 Weeks)',
        dueDate: now.subtract(const Duration(days: 75)),
        administeredDate: now.subtract(const Duration(days: 74)),
        status: VaccineStatus.completed,
        administeredLocation: 'Lotus Pediatric Clinic',
        batchNumber: 'DTP-8841',
        notes: 'Mild fever managed with paracetamol syrup.',
      ),
      VaccineRecord(
        id: 'vac_4',
        childId: child1Id,
        vaccineName: 'Rotavirus 2',
        diseasePrevented: 'Rotavirus Diarrhea',
        doseNumber: 'Dose 2 (10 Weeks)',
        dueDate: now.subtract(const Duration(days: 45)),
        administeredDate: now.subtract(const Duration(days: 44)),
        status: VaccineStatus.completed,
        administeredLocation: 'Lotus Pediatric Clinic',
        batchNumber: 'ROTA-773',
      ),
      VaccineRecord(
        id: 'vac_5',
        childId: child1Id,
        vaccineName: 'Pneumococcal (PCV 3)',
        diseasePrevented: 'Pneumonia & Meningitis',
        doseNumber: 'Dose 3 (14 Weeks)',
        dueDate: now.subtract(const Duration(days: 7)),
        administeredDate: null,
        status: VaccineStatus.overdue,
        notes: 'Due last week. Call Dr. Verma to book appointment.',
      ),
      VaccineRecord(
        id: 'vac_6',
        childId: child1Id,
        vaccineName: 'OPV 3 & IPV 2',
        diseasePrevented: 'Polio',
        doseNumber: 'Dose 3 (14 Weeks)',
        dueDate: now.add(const Duration(days: 5)),
        administeredDate: null,
        status: VaccineStatus.upcoming,
        notes: 'Can be co-administered with PCV.',
      ),
      VaccineRecord(
        id: 'vac_7',
        childId: child1Id,
        vaccineName: 'Influenza (Flu Shot)',
        diseasePrevented: 'Seasonal Flu',
        doseNumber: 'Dose 1 (6 Months)',
        dueDate: now.add(const Duration(days: 60)),
        administeredDate: null,
        status: VaccineStatus.upcoming,
      ),

      // Ananya (2 years old)
      VaccineRecord(
        id: 'vac_8',
        childId: child2Id,
        vaccineName: 'MMR 1',
        diseasePrevented: 'Measles, Mumps, Rubella',
        doseNumber: 'Dose 1 (9 Months)',
        dueDate: now.subtract(const Duration(days: 450)),
        administeredDate: now.subtract(const Duration(days: 448)),
        status: VaccineStatus.completed,
        administeredLocation: 'Fortis Pediatric Ward',
        batchNumber: 'MMR-901',
      ),
      VaccineRecord(
        id: 'vac_9',
        childId: child2Id,
        vaccineName: 'Typhoid Conjugate',
        diseasePrevented: 'Typhoid Fever',
        doseNumber: 'Dose 1 (12 Months)',
        dueDate: now.subtract(const Duration(days: 360)),
        administeredDate: now.subtract(const Duration(days: 358)),
        status: VaccineStatus.completed,
        administeredLocation: 'Lotus Pediatric Clinic',
      ),
      VaccineRecord(
        id: 'vac_10',
        childId: child2Id,
        vaccineName: 'Hepatitis A Booster',
        diseasePrevented: 'Hepatitis A',
        doseNumber: 'Booster (18-24 Months)',
        dueDate: now.subtract(const Duration(days: 12)),
        administeredDate: null,
        status: VaccineStatus.overdue,
        notes: 'Required before preschool admission.',
      ),
      VaccineRecord(
        id: 'vac_11',
        childId: child2Id,
        vaccineName: 'DTP Booster 1',
        diseasePrevented: 'Diphtheria, Tetanus, Pertussis',
        doseNumber: 'Booster 1 (2 Years)',
        dueDate: now.add(const Duration(days: 20)),
        administeredDate: null,
        status: VaccineStatus.upcoming,
      ),
      VaccineRecord(
        id: 'vac_12',
        childId: child2Id,
        vaccineName: 'Varicella (Chickenpox 2)',
        diseasePrevented: 'Chickenpox',
        doseNumber: 'Dose 2 (3 Years)',
        dueDate: now.add(const Duration(days: 300)),
        administeredDate: null,
        status: VaccineStatus.upcoming,
      ),
    ];
  }
}
