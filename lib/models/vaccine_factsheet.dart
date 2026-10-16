import 'package:flutter/material.dart';

class VaccineFactsheet {
  final String sideEffects;
  final String careTips;
  final String emergencyAlert;

  const VaccineFactsheet({
    required this.sideEffects,
    required this.careTips,
    required this.emergencyAlert,
  });

  static VaccineFactsheet getFactsheet(String vaccineName) {
    final lower = vaccineName.toLowerCase();

    if (lower.contains('bcg')) {
      return const VaccineFactsheet(
        sideEffects: 'Mild redness or small papule at the injection site appearing after 2-3 weeks, healing with a tiny scar.',
        careTips: 'Keep the injection site clean and dry. Do not apply creams, antiseptics, or bandages.',
        emergencyAlert: 'Consult doctor if persistent deep ulceration or swollen glands in armpit occur.',
      );
    } else if (lower.contains('hep') || lower.contains('hepatitis')) {
      return const VaccineFactsheet(
        sideEffects: 'Mild soreness or low-grade fever within 24 hours of administration.',
        careTips: 'Offer plenty of fluids and breastmilk. Apply cold, damp cloth to relieve injection soreness.',
        emergencyAlert: 'Call doctor if fever exceeds 102°F or if infant refuses feeding for over 12 hours.',
      );
    } else if (lower.contains('dtp') || lower.contains('dtwp') || lower.contains('dtap')) {
      return const VaccineFactsheet(
        sideEffects: 'Fever, localized swelling, fussiness, mild loss of appetite for 24-48 hours.',
        careTips: 'Administer pediatric paracetamol syrup only as prescribed by your pediatrician. Keep baby cool.',
        emergencyAlert: 'Immediate consult if high-pitched crying exceeds 3 hours or body temperature rises above 103°F.',
      );
    } else if (lower.contains('mmr')) {
      return const VaccineFactsheet(
        sideEffects: 'Mild rash or fever may develop 6 to 12 days post vaccination.',
        careTips: 'Dress child in light, breathable cotton clothing. Ensure adequate hydration.',
        emergencyAlert: 'Contact clinic if seizures, stiff neck, or extreme lethargy occur.',
      );
    } else if (lower.contains('polio') || lower.contains('opv') || lower.contains('ipv')) {
      return const VaccineFactsheet(
        sideEffects: 'Generally very well tolerated. Rare mild soreness with IPV injectable shot.',
        careTips: 'For OPV drops: avoid feeding or drinking for 15-20 minutes before and after administration.',
        emergencyAlert: 'Report any signs of allergic reaction or persistent vomiting.',
      );
    } else if (lower.contains('rota') || lower.contains('rotavirus')) {
      return const VaccineFactsheet(
        sideEffects: 'Mild, temporary diarrhea or irritability within 7 days.',
        careTips: 'Wash hands thoroughly after diaper changes. Continue regular feeding schedule.',
        emergencyAlert: 'Seek emergency care if severe stomach pain, persistent vomiting, or bloody stools occur.',
      );
    } else {
      return const VaccineFactsheet(
        sideEffects: 'Mild localized tenderness, slight redness at injection site, low-grade fever.',
        careTips: 'Rest, plenty of fluids, and gentle cold compress at the injection site.',
        emergencyAlert: 'Consult healthcare provider if fever persists over 48 hours or swelling spreads.',
      );
    }
  }
}
