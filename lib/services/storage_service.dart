import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/child_profile.dart';
import '../models/vaccine_record.dart';
import '../models/mock_data.dart';

class StorageService {
  static const String _keyProfiles = 'vaxicare_profiles_v1';
  static const String _keyVaccines = 'vaxicare_vaccines_v1';
  static const String _keyActiveChildId = 'vaxicare_active_child_id_v1';
  static const String _keySimulatedUser = 'vaxicare_simulated_user_v1';
  static const String _keyInitialized = 'vaxicare_initialized_v1';

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();

    final bool isInitialized = _prefs.getBool(_keyInitialized) ?? false;
    if (!isInitialized) {
      // Seed default sample data for B.Tech project presentation
      final profiles = MockData.initialProfiles;
      await saveProfiles(profiles);

      final vaccines = MockData.getInitialVaccines(profiles[0].id, profiles[1].id);
      await saveVaccines(vaccines);

      await saveActiveChildId(profiles[0].id);
      await _prefs.setBool(_keyInitialized, true);
    }
  }

  // --- Profile Storage ---
  Future<List<ChildProfile>> getProfiles() async {
    final String? raw = _prefs.getString(_keyProfiles);
    if (raw == null || raw.isEmpty) return [];
    try {
      final List<dynamic> decoded = json.decode(raw);
      return decoded.map((e) => ChildProfile.fromMap(e)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveProfiles(List<ChildProfile> profiles) async {
    final list = profiles.map((p) => p.toMap()).toList();
    await _prefs.setString(_keyProfiles, json.encode(list));
  }

  // --- Active Child ID ---
  String? getActiveChildId() {
    return _prefs.getString(_keyActiveChildId);
  }

  Future<void> saveActiveChildId(String childId) async {
    await _prefs.setString(_keyActiveChildId, childId);
  }

  // --- Vaccine Storage ---
  Future<List<VaccineRecord>> getVaccines() async {
    final String? raw = _prefs.getString(_keyVaccines);
    if (raw == null || raw.isEmpty) return [];
    try {
      final List<dynamic> decoded = json.decode(raw);
      return decoded.map((e) => VaccineRecord.fromMap(e)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveVaccines(List<VaccineRecord> vaccines) async {
    final list = vaccines.map((v) => v.toMap()).toList();
    await _prefs.setString(_keyVaccines, json.encode(list));
  }

  // --- Simulated Auth Session ---
  Map<String, String>? getSimulatedUser() {
    final raw = _prefs.getString(_keySimulatedUser);
    if (raw == null) return null;
    try {
      return Map<String, String>.from(json.decode(raw));
    } catch (_) {
      return null;
    }
  }

  Future<void> saveSimulatedUser(Map<String, String> user) async {
    await _prefs.setString(_keySimulatedUser, json.encode(user));
  }

  Future<void> clearSimulatedUser() async {
    await _prefs.remove(_keySimulatedUser);
  }

  // --- Reset to Demo Data ---
  Future<void> resetToDemoData() async {
    final profiles = MockData.initialProfiles;
    await saveProfiles(profiles);

    final vaccines = MockData.getInitialVaccines(profiles[0].id, profiles[1].id);
    await saveVaccines(vaccines);

    await saveActiveChildId(profiles[0].id);
  }
}
