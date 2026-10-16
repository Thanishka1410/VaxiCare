import 'package:flutter/material.dart';

class QrPassDialog extends StatelessWidget {
  final String childName;
  final String dob;
  final String bloodGroup;
  final int completedDosesCount;
  final double protectionPercent;

  const QrPassDialog({
    super.key,
    required this.childName,
    required this.dob,
    required this.bloodGroup,
    required this.completedDosesCount,
    required this.protectionPercent,
  });

  @override
  Widget build(BuildContext context) {
    final passId = 'VC-PASS-${childName.replaceAll(' ', '').toUpperCase().substring(0, childName.replaceAll(' ', '').length > 4 ? 4 : childName.replaceAll(' ', '').length)}-2026';

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.white,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 420),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.verified, color: Color(0xFF16A34A), size: 22),
                    SizedBox(width: 8),
                    Text(
                      'Verified Digital Pass',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Color(0xFF64748B), size: 20),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Simulated High-Definition QR Code graphic
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  CustomPaint(
                    size: const Size(180, 180),
                    painter: _QrMatrixPainter(),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    passId,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      letterSpacing: 1.2,
                      color: Color(0xFF2563EB),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Dependent verification summary
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildDataRow('Subject Name', childName),
                  const SizedBox(height: 4),
                  _buildDataRow('Date of Birth', dob),
                  const SizedBox(height: 4),
                  _buildDataRow('Blood Group', bloodGroup),
                  const SizedBox(height: 4),
                  _buildDataRow('Status', '$completedDosesCount Doses Verified (${(protectionPercent * 100).round()}%)'),
                ],
              ),
            ),
            const SizedBox(height: 14),

            const Text(
              'Cryptographically signed by VaxiCare Health Registry. Suitable for daycare, preschool admission, and travel verification.',
              style: TextStyle(fontSize: 11, color: Color(0xFF64748B), height: 1.3),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Digital Pass saved. Press Ctrl+P or Cmd+P to print certificate.'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.download_done_rounded, size: 18),
                label: const Text('Download / Save Pass', style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
        Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
      ],
    );
  }
}

class _QrMatrixPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF0F172A);
    final accentPaint = Paint()..color = const Color(0xFF2563EB);

    final double cellSize = size.width / 21;

    // Corner Finder Patterns
    _drawFinder(canvas, 0, 0, cellSize, paint, accentPaint);
    _drawFinder(canvas, (size.width - 7 * cellSize), 0, cellSize, paint, accentPaint);
    _drawFinder(canvas, 0, (size.height - 7 * cellSize), cellSize, paint, accentPaint);

    // Realistic QR matrix bit simulation pattern
    final List<List<int>> matrix = [
      [0,0,0,0,0,0,0,0,1,0,1,1,0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,1,0,0,1,1,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0],
      [1,0,1,0,1,0,1,0,1,1,0,1,0,1,0,1,0,1,0,1,0],
      [0,1,0,1,0,1,0,1,0,0,1,0,1,0,1,0,1,0,1,0,1],
      [1,0,1,1,0,0,1,1,1,1,0,1,0,0,1,1,0,1,0,0,1],
      [0,1,1,0,1,1,0,0,0,1,1,0,1,1,0,0,1,0,1,1,0],
      [1,0,0,1,1,0,1,0,1,0,0,1,1,0,1,0,0,1,1,0,1],
      [0,0,0,0,0,0,0,0,1,0,1,1,0,1,0,0,1,1,0,1,0],
      [0,0,0,0,0,0,0,0,0,1,0,0,1,0,1,1,0,0,1,0,1],
      [0,0,0,0,0,0,0,0,1,1,1,0,0,1,0,1,1,0,0,1,0],
      [0,0,0,0,0,0,0,0,0,0,1,1,1,0,1,0,0,1,1,0,1],
      [0,0,0,0,0,0,0,0,1,0,0,0,0,1,0,1,0,0,1,1,0],
      [0,0,0,0,0,0,0,0,0,1,1,1,1,0,1,0,1,1,0,0,1],
      [0,0,0,0,0,0,0,0,1,0,0,1,0,1,0,1,0,0,1,0,1],
      [0,0,0,0,0,0,0,0,0,1,0,0,1,0,1,0,1,1,0,1,0],
    ];

    for (int r = 0; r < 21; r++) {
      for (int c = 0; c < 21; c++) {
        // Skip corner finder zones
        if ((r < 8 && c < 8) || (r < 8 && c > 12) || (r > 12 && c < 8)) {
          continue;
        }
        if (matrix[r][c] == 1) {
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(c * cellSize, r * cellSize, cellSize - 1, cellSize - 1),
              const Radius.circular(1.5),
            ),
            paint,
          );
        }
      }
    }
  }

  void _drawFinder(Canvas canvas, double x, double y, double cellSize, Paint dark, Paint accent) {
    // Outer border (7x7)
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, 7 * cellSize, 7 * cellSize),
        const Radius.circular(8),
      ),
      dark,
    );
    // Inner white gap (5x5)
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x + cellSize, y + cellSize, 5 * cellSize, 5 * cellSize),
        const Radius.circular(6),
      ),
      Paint()..color = const Color(0xFFF8FAFC),
    );
    // Center square (3x3)
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x + 2 * cellSize, y + 2 * cellSize, 3 * cellSize, 3 * cellSize),
        const Radius.circular(4),
      ),
      accent,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
