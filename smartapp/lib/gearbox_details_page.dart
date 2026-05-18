import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ar_view_page.dart';

class GearboxDetailsPage extends StatelessWidget {
  final Map<String, String> product;

  const GearboxDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final outputText = product['output'] ??
        'Solid cylindrical shaft\nSolid shaft with keyway\nSolid shaft with supporting feet\nSolid shaft with keyway and supporting feet\nHollow shaft with shrink disc';

    return Scaffold(
      appBar: AppBar(
        title: Text(product['name'] ?? 'Gearbox Details'),
        backgroundColor: const Color(0xFF00648F),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (product['image'] != null && product['image']!.isNotEmpty)
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      product['image']!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 220,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 220,
                          color: const Color(0xFFE9F6FB),
                          child: const Center(
                            child: Icon(
                              Icons.broken_image,
                              size: 48,
                              color: Color(0xFF00648F),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.88),
                        foregroundColor: const Color(0xFF00648F),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.view_in_ar),
                      label: const Text('AR View'),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ARViewPage(
                              productName: product['name'] ?? 'Gearbox',
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 20),
            Text(
              product['name'] ?? 'Gearbox',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product['sku'] ?? '',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailTile('Torque range', product['torqueRange'] ?? 'N/A'),
            _buildDetailTile('Torque range (IU)', product['torqueRangeIU'] ?? 'N/A'),
            _buildDetailTile('Gear ratios', product['gearRatios'] ?? 'N/A'),
            _buildDetailTile('Certifications', product['certifications'] ?? 'Certificate of compliance\nInspection certificate'),
            _buildDetailTile('Inspection certificate', product['inspectionCertificate'] ?? 'Inspection certificate'),
            _buildDetailTile('Output', outputText),
            const SizedBox(height: 24),
            _buildActionButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F8FB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.black87,
                height: 1.55,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00648F),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text(
          'Back to catalogue',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
