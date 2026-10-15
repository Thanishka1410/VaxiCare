import 'dart:convert';

class ChildProfile {
  final String id;
  final String name;
  final DateTime dateOfBirth;
  final String gender; // 'Male', 'Female', 'Other'
  final String bloodGroup;
  final String avatarEmoji;

  ChildProfile({
    required this.id,
    required this.name,
    required this.dateOfBirth,
    required this.gender,
    required this.bloodGroup,
    this.avatarEmoji = '👶',
  });

  int get ageInMonths {
    final now = DateTime.now();
    int months = (now.year - dateOfBirth.year) * 12 + now.month - dateOfBirth.month;
    if (now.day < dateOfBirth.day) {
      months--;
    }
    return months < 0 ? 0 : months;
  }

  String get ageFormatted {
    final months = ageInMonths;
    if (months < 1) {
      final days = DateTime.now().difference(dateOfBirth).inDays;
      return '$days days old';
    } else if (months < 12) {
      return '$months months old';
    } else {
      final years = months ~/ 12;
      final remainingMonths = months % 12;
      if (remainingMonths == 0) return '$years years old';
      return '$years yr $remainingMonths mo old';
    }
  }

  ChildProfile copyWith({
    String? id,
    String? name,
    DateTime? dateOfBirth,
    String? gender,
    String? bloodGroup,
    String? avatarEmoji,
  }) {
    return ChildProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      avatarEmoji: avatarEmoji ?? this.avatarEmoji,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'gender': gender,
      'bloodGroup': bloodGroup,
      'avatarEmoji': avatarEmoji,
    };
  }

  factory ChildProfile.fromMap(Map<String, dynamic> map) {
    return ChildProfile(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      dateOfBirth: DateTime.parse(map['dateOfBirth']),
      gender: map['gender'] ?? 'Male',
      bloodGroup: map['bloodGroup'] ?? 'O+',
      avatarEmoji: map['avatarEmoji'] ?? '👶',
    );
  }

  String toJson() => json.encode(toMap());

  factory ChildProfile.fromJson(String source) =>
      ChildProfile.fromMap(json.decode(source));
}
