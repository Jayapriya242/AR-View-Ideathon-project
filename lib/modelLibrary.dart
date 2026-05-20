import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'gearbox_details_page.dart';

class ModelLibraryWidget extends StatefulWidget {
  const ModelLibraryWidget({super.key});

  static String routeName = 'ModelLibrary';
  static String routePath = '/modelLibrary';

  @override
  State<ModelLibraryWidget> createState() => _ModelLibraryWidgetState();
}

class _ModelLibraryWidgetState extends State<ModelLibraryWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Map<String, String>> _products = [
    {
      'name': 'Right Angle Gearbox 90 Series',
      'type': 'Gearbox',
      'sku': 'RG-90-100',
      'price': '€ 199',
      'specs': 'Ratio 5:1 • 1.2 kW',
      'image': 'assets/images/right-angle.png',
      'torqueRange': '135,000 ... 1,750,000 Nm',
      'torqueRangeIU': '1,194,850 … 15,488,805 in-lb',
      'gearRatios': '89.1 ... 1,070',
      'certifications': 'Certificate of compliance\nInspection certificate',
      'inspectionCertificate': 'Inspection certificate',
      'output': 'Solid cylindrical shaft\nSolid shaft with keyway\nSolid shaft with supporting feet\nSolid shaft with keyway and supporting feet\nHollow shaft with shrink disc',
    },
    {
      'name': 'Right Angle Gearbox 120 Series',
      'type': 'Gearbox',
      'sku': 'RG-120-200',
      'price': '€ 259',
      'specs': 'Ratio 7:1 • 2.5 kW',
      'image': 'assets/images/right-angle.png',
      'torqueRange': '135,000 ... 1,750,000 Nm',
      'torqueRangeIU': '1,194,850 … 15,488,805 in-lb',
      'gearRatios': '89.1 ... 1,070',
      'certifications': 'Certificate of compliance\nInspection certificate',
      'inspectionCertificate': 'Inspection certificate',
      'output': 'Solid cylindrical shaft\nSolid shaft with keyway\nSolid shaft with supporting feet\nSolid shaft with keyway and supporting feet\nHollow shaft with shrink disc',
    },
    {
      'name': 'Helical Bevel Gearbox',
      'type': 'Gearbox',
      'sku': 'HB-070',
      'price': '€ 345',
      'specs': 'Ratio 10:1 • 3.0 kW',
      'image': 'assets/images/parallel.png',
      'torqueRange': '135,000 ... 1,750,000 Nm',
      'torqueRangeIU': '1,194,850 … 15,488,805 in-lb',
      'gearRatios': '89.1 ... 1,070',
      'certifications': 'Certificate of compliance\nInspection certificate',
      'inspectionCertificate': 'Inspection certificate',
      'output': 'Solid cylindrical shaft\nSolid shaft with keyway\nSolid shaft with supporting feet\nSolid shaft with keyway and supporting feet\nHollow shaft with shrink disc',
    },
    {
      'name': 'Servo Motor Drive',
      'type': 'Motor',
      'sku': 'SM-45',
      'price': '€ 529',
      'specs': '48V • 4.5 Nm',
      'image': 'assets/images/inline.png',
    },
    {
      'name': 'Planetary Gearbox P-14',
      'type': 'Gearbox',
      'sku': 'PG-14-80',
      'price': '€ 389',
      'specs': 'Ratio 14:1 • 1.8 kW',
      'image': 'assets/images/parallel.png',
      'torqueRange': '135,000 ... 1,750,000 Nm',
      'torqueRangeIU': '1,194,850 … 15,488,805 in-lb',
      'gearRatios': '89.1 ... 1,070',
      'certifications': 'Certificate of compliance\nInspection certificate',
      'inspectionCertificate': 'Inspection certificate',
      'output': 'Solid cylindrical shaft\nSolid shaft with keyway\nSolid shaft with supporting feet\nSolid shaft with keyway and supporting feet\nHollow shaft with shrink disc',
    },
    {
      'name': 'Lubrication Kit',
      'type': 'Accessory',
      'sku': 'LK-01',
      'price': '€ 49',
      'specs': 'Grease + Seals',
      'image': 'assets/images/inline.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = ((MediaQuery.of(context).size.width ~/ 280).clamp(1, 3)).toInt();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1),
              ),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'BONFIGLIOLI',
                          style: GoogleFonts.inter(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          'PRODUCT CATALOG',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF00648F),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'SEARCH_PRODUCTS...',
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Color(0xFF00648F),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFF00648F).withOpacity(0.2),
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(
                        Icons.tune,
                        color: Color(0xFF00648F),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: _buildStatCard('TOTAL_PRODUCTS', '${_products.length}')),
                      const SizedBox(width: 16),
                      Expanded(child: _buildStatCard('CATEGORY', 'Gearboxes')),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: GridView.builder(
                      itemCount: _products.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.1,
                      ),
                      itemBuilder: (context, index) {
                        final product = _products[index];
                        return _buildProductTile(product);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductTile(Map<String, String> product) {
    final name = product['name'] ?? '';
    final type = product['type'] ?? '';
    final sku = product['sku'] ?? '';
    final price = product['price'] ?? '';
    final specs = product['specs'] ?? '';
    final imageAsset = product['image'] ?? '';

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => GearboxDetailsPage(product: product),
            ),
          );
        },

        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 190,
                decoration: BoxDecoration(
                  color: const Color(0xFFE9F6FB),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: imageAsset.isNotEmpty
                      ? Image.asset(
                          imageAsset,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: const Color(0xFFE9F6FB),
                              child: const Center(
                                child: Icon(
                                  Icons.broken_image,
                                  size: 42,
                                  color: Color(0xFF00648F),
                                ),
                              ),
                            );
                          },
                        )
                      : Container(
                          color: const Color(0xFFE9F6FB),
                          child: const Center(
                            child: Icon(
                              Icons.precision_manufacturing,
                              size: 42,
                              color: Color(0xFF00648F),
                            ),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                type.toUpperCase(),
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11,
                  color: Colors.grey[600],
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                sku,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      specs,
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 11,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  Text(
                    price,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF00648F),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
