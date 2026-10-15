import 'package:flutter/foundation.dart';
import '../models/child_profile.dart';
import '../models/vaccine_record.dart';
import '../services/storage_service.dart';

class VaccineProvider with ChangeNotifier {
  final StorageService _storage;

  List<ChildProfile> _profiles = [];
  List<VaccineRecord> _vaccines = [];
  String? _selectedChildId;
  bool _isLoading = true;

  // Filter & Search states
  String _searchQuery = '';
  VaccineStatus? _statusFilter;

  VaccineProvider(this._storage) {
    loadData();
  }

  bool get isLoading => _isLoading;
  List<ChildProfile> get profiles => _profiles;
  String? get selectedChildId => _selectedChildId;
  String get searchQuery => _searchQuery;
  VaccineStatus? get statusFilter => _statusFilter;

  ChildProfile? get selectedChild {
    if (_profiles.isEmpty) return null;
    return _profiles.firstWhere(
      (p) => p.id == _selectedChildId,
      orElse: () => _profiles.first,
    );
  }

  // Active Child's All Vaccines
  List<VaccineRecord> get childVaccines {
    if (selectedChild == null) return [];
    return _vaccines.where((v) => v.childId == selectedChild!.id).toList();
  }

  // Filtered & Searched Vaccines
  List<VaccineRecord> get filteredVaccines {
    return childVaccines.where((v) {
      final matchesSearch = _searchQuery.isEmpty ||
          v.vaccineName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          v.diseasePrevented.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesStatus = _statusFilter == null || v.status == _statusFilter;

      return matchesSearch && matchesStatus;
    }).toList();
  }

  // Dashboard Metrics
  int get completedCount =>
      childVaccines.where((v) => v.status == VaccineStatus.completed).length;

  int get upcomingCount =>
      childVaccines.where((v) => v.status == VaccineStatus.upcoming).length;

  int get overdueCount =>
      childVaccines.where((v) => v.status == VaccineStatus.overdue).length;

  double get completionProgress {
    if (childVaccines.isEmpty) return 0.0;
    return completedCount / childVaccines.length;
  }

  List<VaccineRecord> get upcomingVaccines {
    final list = childVaccines.where((v) => v.status == VaccineStatus.upcoming).toList();
    list.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    return list;
  }

  List<VaccineRecord> get overdueVaccines {
    final list = childVaccines.where((v) => v.status == VaccineStatus.overdue).toList();
    list.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    return list;
  }

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    _profiles = await _storage.getProfiles();
    _vaccines = await _storage.getVaccines();
    _selectedChildId = _storage.getActiveChildId();

    if (_selectedChildId == null && _profiles.isNotEmpty) {
      _selectedChildId = _profiles.first.id;
      await _storage.saveActiveChildId(_selectedChildId!);
    }

    _isLoading = false;
    notifyListeners();
  }

  void selectChild(String childId) {
    _selectedChildId = childId;
    _storage.saveActiveChildId(childId);
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setStatusFilter(VaccineStatus? status) {
    _statusFilter = status;
    notifyListeners();
  }

  // --- CRUD for Profiles ---
  Future<void> addChildProfile({
    required String name,
    required DateTime dateOfBirth,
    required String gender,
    required String bloodGroup,
    String avatarEmoji = '👶',
  }) async {
    final newId = 'child_${DateTime.now().millisecondsSinceEpoch}';
    final newChild = ChildProfile(
      id: newId,
      name: name,
      dateOfBirth: dateOfBirth,
      gender: gender,
      bloodGroup: bloodGroup,
      avatarEmoji: avatarEmoji,
    );

    _profiles.add(newChild);
    _selectedChildId = newId;

    // Generate standard schedule for this new child
    _seedStandardScheduleForChild(newId, dateOfBirth);

    await _storage.saveProfiles(_profiles);
    await _storage.saveVaccines(_vaccines);
    await _storage.saveActiveChildId(newId);
    notifyListeners();
  }

  Future<void> updateChildProfile(ChildProfile updated) async {
    final index = _profiles.indexWhere((p) => p.id == updated.id);
    if (index != -1) {
      _profiles[index] = updated;
      await _storage.saveProfiles(_profiles);
      notifyListeners();
    }
  }

  Future<void> deleteChildProfile(String childId) async {
    _profiles.removeWhere((p) => p.id == childId);
    _vaccines.removeWhere((v) => v.childId == childId);

    if (_selectedChildId == childId) {
      _selectedChildId = _profiles.isNotEmpty ? _profiles.first.id : null;
      if (_selectedChildId != null) {
        await _storage.saveActiveChildId(_selectedChildId!);
      }
    }

    await _storage.saveProfiles(_profiles);
    await _storage.saveVaccines(_vaccines);
    notifyListeners();
  }

  // --- CRUD for Vaccines ---
  Future<void> addVaccineRecord({
    required String vaccineName,
    required String diseasePrevented,
    required String doseNumber,
    required DateTime dueDate,
    DateTime? administeredDate,
    required VaccineStatus status,
    String? administeredLocation,
    String? notes,
    String? batchNumber,
  }) async {
    if (selectedChild == null) return;

    final newVaccine = VaccineRecord(
      id: 'vac_${DateTime.now().millisecondsSinceEpoch}',
      childId: selectedChild!.id,
      vaccineName: vaccineName,
      diseasePrevented: diseasePrevented,
      doseNumber: doseNumber,
      dueDate: dueDate,
      administeredDate: administeredDate,
      status: status,
      administeredLocation: administeredLocation,
      notes: notes,
      batchNumber: batchNumber,
    );

    _vaccines.add(newVaccine);
    await _storage.saveVaccines(_vaccines);
    notifyListeners();
  }

  Future<void> markVaccineAdministered({
    required String vaccineId,
    required DateTime administeredDate,
    String? location,
    String? batchNumber,
    String? notes,
  }) async {
    final index = _vaccines.indexWhere((v) => v.id == vaccineId);
    if (index != -1) {
      final old = _vaccines[index];
      _vaccines[index] = old.copyWith(
        status: VaccineStatus.completed,
        administeredDate: administeredDate,
        administeredLocation: location ?? old.administeredLocation,
        batchNumber: batchNumber ?? old.batchNumber,
        notes: notes ?? old.notes,
      );
      await _storage.saveVaccines(_vaccines);
      notifyListeners();
    }
  }

  Future<void> updateVaccineRecord(VaccineRecord updated) async {
    final index = _vaccines.indexWhere((v) => v.id == updated.id);
    if (index != -1) {
      _vaccines[index] = updated;
      await _storage.saveVaccines(_vaccines);
      notifyListeners();
    }
  }

  Future<void> deleteVaccineRecord(String vaccineId) async {
    _vaccines.removeWhere((v) => v.id == vaccineId);
    await _storage.saveVaccines(_vaccines);
    notifyListeners();
  }

  Future<void> resetDemoData() async {
    await _storage.resetToDemoData();
    await loadData();
  }

  void _seedStandardScheduleForChild(String childId, DateTime dob) {
    final schedule = [
      {'name': 'BCG', 'disease': 'Tuberculosis', 'dose': 'Single Dose', 'days': 0},
      {'name': 'Hepatitis B 1', 'disease': 'Hepatitis B', 'dose': 'Dose 1 (Birth)', 'days': 0},
      {'name': 'OPV 0', 'disease': 'Polio', 'dose': 'Birth Dose', 'days': 0},
      {'name': 'DTwP / DTaP 1', 'disease': 'Diphtheria, Tetanus, Pertussis', 'dose': 'Dose 1 (6 Wks)', 'days': 42},
      {'name': 'IPV 1', 'disease': 'Polio', 'dose': 'Dose 1 (6 Wks)', 'days': 42},
      {'name': 'Rotavirus 1', 'disease': 'Rotavirus Diarrhea', 'dose': 'Dose 1 (6 Wks)', 'days': 42},
      {'name': 'PCV 1', 'disease': 'Pneumococcal Pneumonia', 'dose': 'Dose 1 (6 Wks)', 'days': 42},
      {'name': 'DTwP / DTaP 2', 'disease': 'Diphtheria, Tetanus, Pertussis', 'dose': 'Dose 2 (10 Wks)', 'days': 70},
      {'name': 'Rotavirus 2', 'disease': 'Rotavirus Diarrhea', 'dose': 'Dose 2 (10 Wks)', 'days': 70},
      {'name': 'PCV 2', 'disease': 'Pneumococcal Pneumonia', 'dose': 'Dose 2 (10 Wks)', 'days': 70},
      {'name': 'DTwP / DTaP 3', 'disease': 'Diphtheria, Tetanus, Pertussis', 'dose': 'Dose 3 (14 Wks)', 'days': 98},
      {'name': 'MMR 1', 'disease': 'Measles, Mumps, Rubella', 'dose': 'Dose 1 (9 Mos)', 'days': 270},
    ];

    final now = DateTime.now();

    for (int i = 0; i < schedule.length; i++) {
      final item = schedule[i];
      final dueDate = dob.add(Duration(days: item['days'] as int));
      VaccineStatus status = VaccineStatus.upcoming;
      DateTime? administeredDate;

      if (dueDate.isBefore(now.subtract(const Duration(days: 1)))) {
        // If due date was in past
        if (i < 3) {
          status = VaccineStatus.completed;
          administeredDate = dueDate;
        } else {
          status = VaccineStatus.overdue;
        }
      }

      _vaccines.add(
        VaccineRecord(
          id: 'vac_${childId}_$i',
          childId: childId,
          vaccineName: item['name'] as String,
          diseasePrevented: item['disease'] as String,
          doseNumber: item['dose'] as String,
          dueDate: dueDate,
          administeredDate: administeredDate,
          status: status,
          administeredLocation: status == VaccineStatus.completed ? 'General Hospital' : null,
        ),
      );
    }
  }
}
