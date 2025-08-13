import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Devuelve un XFile (foto) al cerrar el Navigator.
/// Si el usuario cancela, retorna null.
class CustomCameraScreen extends ConsumerStatefulWidget {
  const CustomCameraScreen({super.key});

  @override
  ConsumerState<CustomCameraScreen> createState() => _CustomCameraScreenState();
}

class _CustomCameraScreenState extends ConsumerState<CustomCameraScreen> {
  CameraController? _controller;
  bool _isCameraInitialized = false;
  bool _isTakingPicture = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        _controller = CameraController(
          cameras[0],
          ResolutionPreset.medium,
        );
        await _controller!.initialize();
        setState(() => _isCameraInitialized = true);
      } else {
        _showError('No se encontró cámara en el dispositivo');
      }
    } catch (e) {
      _showError('Error iniciando la cámara: $e');
      Navigator.pop(context, null);
    }
  }

  void _showError(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    if (_isTakingPicture) return;
    setState(() => _isTakingPicture = true);
    try {
      final pic = await _controller!.takePicture();
      Navigator.pop(context, pic); // Devuelve el XFile
    } catch (e) {
      _showError('Error al tomar foto: $e');
    } finally {
      setState(() => _isTakingPicture = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraInitialized || _controller == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Cámara')),
      body: Column(
        children: [
          Expanded(child: CameraPreview(_controller!)),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton.icon(
              onPressed: _isTakingPicture ? null : _takePicture,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Capturar'),
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(40)),
            ),
          )
        ],
      ),
    );
  }
}
