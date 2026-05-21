import 'package:ar_flutter_plugin_plus/ar_flutter_plugin_plus.dart';
import 'package:ar_flutter_plugin_plus/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin_plus/datatypes/node_types.dart';
import 'package:ar_flutter_plugin_plus/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin_plus/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin_plus/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin_plus/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin_plus/models/ar_anchor.dart';
import 'package:ar_flutter_plugin_plus/models/ar_hittest_result.dart';
import 'package:ar_flutter_plugin_plus/models/ar_node.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'dart:io';
import 'dart:math' as math;

class ARViewPage extends StatefulWidget {
  final String productName;

  const ARViewPage({super.key, required this.productName});

  @override
  State<ARViewPage> createState() => _ARViewPageState();
}

class _ARViewPageState extends State<ARViewPage> {
  ARSessionManager? _arSessionManager;
  ARObjectManager? _arObjectManager;
  ARAnchorManager? _arAnchorManager;
  ARNode? _modelNode;

  final String _threeDFile = 'assets/3dfiles/right_angle.glb';
  static const double _modelScaleValue = 0.02;
  static const double _nudgeStep = 0.03;
  static const double _scaleStep = 0.1;
  static const double _minScale = 0.003;
  static const double _maxScale = 0.4;

  String get _statusText => _modelPlaced
      ? 'Model placed in AR environment'
      : 'Searching for flat surface';
  bool _modelPlaced = false;
  double _currentScale = _modelScaleValue;
  final TextEditingController _rotationController =
      TextEditingController(text: '15');
  String _selectedRotationAxis = 'Y';
  bool _controlsExpanded = true;

  bool get _isRemoteModel => _threeDFile.toLowerCase().startsWith('http');

  String get _resolvedModelUri {
    if (_isRemoteModel) return _threeDFile;
    return _threeDFile.startsWith('assets/')
        ? _threeDFile.substring('assets/'.length)
        : _threeDFile;
  }

  Future<String?> _prepareLocalModelFile() async {
    try {
      final data = await rootBundle.load(_threeDFile);
      final bytes = data.buffer.asUint8List();
      final safeName = _threeDFile.split('/').last.replaceAll(' ', '_');
      final file = File('${Directory.systemTemp.path}/$safeName');
      await file.writeAsBytes(bytes, flush: true);
      return file.path;
    } catch (_) {
      return null;
    }
  }

  bool get _supportsArAsset {
    final lower = _threeDFile.toLowerCase();
    return lower.endsWith('.glb') ||
        lower.endsWith('.gltf') ||
        lower.endsWith('.usdz');
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _arSessionManager?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AR View • ${widget.productName}'),
        backgroundColor: const Color(0xFF00648F),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                ARView(
                  onARViewCreated: _onARViewCreated,
                  planeDetectionConfig: PlaneDetectionConfig.horizontal,
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.92),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _statusText,
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.92),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: Colors.blue,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _supportsArAsset
                              ? (_modelPlaced
                                    ? 'Model placed'
                                    : 'Tap to place model')
                              : 'STEP file needs conversion',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 12,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 24,
                  left: 24,
                  right: 24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (!_modelPlaced) ...[
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00648F),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: _supportsArAsset
                              ? _placeModel
                              : _showUnsupportedAssetMessage,
                          child: Text(
                            _supportsArAsset
                                ? 'Place 3D model in AR'
                                : 'STEP asset not supported',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'AR Guidance',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildInfoRow('File', _threeDFile.split('/').last),
                            const SizedBox(height: 10),
                            _buildInfoRow(
                              'Status',
                              _supportsArAsset
                                  ? 'Ready to place'
                                  : 'Convert to .glb/.gltf',
                            ),
                            const SizedBox(height: 10),
                            _buildInfoRow(
                              'Tip',
                              _modelPlaced
                                  ? 'Drag to move • Two-finger rotate'
                                  : 'Move device slowly and keep plane in view',
                            ),
                          ],
                        ),
                      ),
                      if (_modelPlaced) ...[
                        const SizedBox(height: 12),
                        _buildControlsSheet(),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onARViewCreated(
    ARSessionManager arSessionManager,
    ARObjectManager arObjectManager,
    ARAnchorManager arAnchorManager,
    ARLocationManager _,
  ) {
    _arSessionManager = arSessionManager;
    _arObjectManager = arObjectManager;
    _arAnchorManager = arAnchorManager;

    _arSessionManager?.onInitialize(
      showFeaturePoints: false,
      showPlanes: true,
      customPlaneTexturePath: "",
      showWorldOrigin: true,
      handleTaps: true,
      handlePans: true,
      handleRotation: true,
    );

    _arObjectManager?.onInitialize();
    _arSessionManager?.onPlaneOrPointTap = _onPlaneTapped;
    _arObjectManager?.onPanEnd = (_, transform) {
      _modelNode?.transform = transform;
    };
    _arObjectManager?.onRotationEnd = (_, transform) {
      _modelNode?.transform = transform;
    };
  }

  Future<void> _onPlaneTapped(List<ARHitTestResult> hitTestResults) async {
    if (hitTestResults.isEmpty || !_supportsArAsset) {
      return;
    }

    final hit = hitTestResults.first;
    final newAnchor = ARPlaneAnchor(transformation: hit.worldTransform);
    await _arAnchorManager?.addAnchor(newAnchor);

    NodeType nodeType = _isRemoteModel ? NodeType.webGLB : NodeType.localGLB;
    String nodeUri = _resolvedModelUri;

    if (!_isRemoteModel) {
      final localPath = await _prepareLocalModelFile();
      if (localPath != null) {
        nodeType = NodeType.fileSystemAppFolderGLB;
        nodeUri = localPath;
      }
    }

    final node = ARNode(
      type: nodeType,
      uri: nodeUri,
      scale: vector.Vector3.all(_modelScaleValue),
      position: vector.Vector3(0.0, 0.0, 0.0),
    );

    final didAddNode = await _arObjectManager?.addNode(
      node,
      planeAnchor: newAnchor,
    );
    if (didAddNode == true) {
      setState(() {
        _modelNode = node;
        _modelPlaced = true;
        _currentScale = _modelScaleValue;
        _controlsExpanded = true;
      });
    }
  }

  void _nudgeModel(double x, double y, double z) {
    final node = _modelNode;
    if (node == null) return;
    final p = node.position;
    node.position = vector.Vector3(p.x + x, p.y + y, p.z + z);
    setState(() {});
  }

  void _scaleModel(double factorDelta) {
    final node = _modelNode;
    if (node == null) return;
    final nextScale = (_currentScale * (1 + factorDelta)).clamp(
      _minScale,
      _maxScale,
    );
    _currentScale = nextScale;
    node.scale = vector.Vector3.all(_currentScale);
    setState(() {});
  }

  void _rotateModelByDegrees(double degrees) {
    final node = _modelNode;
    if (node == null) return;
    final current = node.eulerAngles;
    final radians = degrees * (math.pi / 180.0);
    switch (_selectedRotationAxis) {
      case 'X':
        node.eulerAngles = vector.Vector3(
          current.x + radians,
          current.y,
          current.z,
        );
        break;
      case 'Z':
        node.eulerAngles = vector.Vector3(
          current.x,
          current.y,
          current.z + radians,
        );
        break;
      case 'Y':
      default:
        node.eulerAngles = vector.Vector3(
          current.x,
          current.y + radians,
          current.z,
        );
        break;
    }
    setState(() {});
  }

  double _rotationStepFromInput() {
    final parsed = double.tryParse(_rotationController.text.trim());
    if (parsed == null || parsed == 0) return 15.0;
    return parsed.abs();
  }

  void _showUnsupportedAssetMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'STEP files are not supported by ARCore/ARKit. Convert to .glb or .gltf for AR.',
        ),
      ),
    );
  }

  Future<void> _placeModel() async {
    if (!_supportsArAsset) {
      _showUnsupportedAssetMessage();
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tap a detected plane to place the model.')),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Text(
            label,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Text(
            value,
            style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[800]),
          ),
        ),
      ],
    );
  }

  Widget _buildControlsSheet() {
    return GestureDetector(
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity == null) return;
        if (details.primaryVelocity! > 100) {
          setState(() => _controlsExpanded = false);
        } else if (details.primaryVelocity! < -100) {
          setState(() => _controlsExpanded = true);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.96),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () => setState(() => _controlsExpanded = !_controlsExpanded),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    _controlsExpanded ? 'Hide Controls' : 'Show Controls',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF00648F),
                    ),
                  ),
                  Icon(
                    _controlsExpanded
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_up,
                    color: const Color(0xFF00648F),
                  ),
                ],
              ),
            ),
            if (_controlsExpanded) ...[
              const SizedBox(height: 10),
              _buildAdjustControlsContent(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAdjustControlsContent() {
    return Column(
      children: [
        Text(
          'Align Model',
          style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _controlButton('Left', Icons.west, () => _nudgeModel(-_nudgeStep, 0, 0)),
            _controlButton('Right', Icons.east, () => _nudgeModel(_nudgeStep, 0, 0)),
            _controlButton('Forward', Icons.north, () => _nudgeModel(0, 0, -_nudgeStep)),
            _controlButton('Back', Icons.south, () => _nudgeModel(0, 0, _nudgeStep)),
            _controlButton('Up', Icons.arrow_upward, () => _nudgeModel(0, _nudgeStep, 0)),
            _controlButton('Down', Icons.arrow_downward, () => _nudgeModel(0, -_nudgeStep, 0)),
            _controlButton('Scale +', Icons.zoom_in, () => _scaleModel(_scaleStep)),
            _controlButton('Scale -', Icons.zoom_out, () => _scaleModel(-_scaleStep)),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            SegmentedButton<String>(
              segments: const [
                ButtonSegment<String>(value: 'X', label: Text('X')),
                ButtonSegment<String>(value: 'Y', label: Text('Y')),
                ButtonSegment<String>(value: 'Z', label: Text('Z')),
              ],
              selected: <String>{_selectedRotationAxis},
              onSelectionChanged: (selection) {
                setState(() {
                  _selectedRotationAxis = selection.first;
                });
              },
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _rotationController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: false,
                ),
                decoration: const InputDecoration(
                  isDense: true,
                  labelText: 'Rotation angle (deg)',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            _controlButton(
              'Rotate -',
              Icons.rotate_left,
              () => _rotateModelByDegrees(-_rotationStepFromInput()),
            ),
            const SizedBox(width: 8),
            _controlButton(
              'Rotate +',
              Icons.rotate_right,
              () => _rotateModelByDegrees(_rotationStepFromInput()),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Current scale: ${_currentScale.toStringAsFixed(3)} • Rotate axis: $_selectedRotationAxis',
          style: GoogleFonts.jetBrainsMono(fontSize: 11, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _controlButton(String label, IconData icon, VoidCallback onPressed) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 14),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF00648F),
        side: const BorderSide(color: Color(0xFF00648F)),
        textStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
