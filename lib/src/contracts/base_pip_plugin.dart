import 'dart:async';
import 'package:pip_plugin/src/contracts/pip_plugin_platform_interface.dart';
import 'package:pip_plugin/pip_configuration.dart';

abstract class BasePipPlugin extends PipPluginPlatform {
  final StreamController<bool> _pipStatusController =
      StreamController<bool>.broadcast();

  bool _isInitialized = false;

  @override
  bool get isInitialized => _isInitialized;

  void handlePipEntered() => _pipStatusController.add(true);

  void handlePipExited() => _pipStatusController.add(false);

  @override
  Stream<bool> get pipActiveStream => _pipStatusController.stream;

  void markInitialized() {
    _isInitialized = true;
  }

  void checkInitialized() {
    if (!_isInitialized) {
      throw Exception('PipPlugin not initialized. Call setupPip() first.');
    }
  }

  @override
  Future<bool> setupPip({
    String? windowTitle,
    PipConfiguration? configuration,
  }) async {
    if (_isInitialized) return true;
    if (!await isPipSupported()) {
      throw Exception('PIP is not supported on this device.');
    }

    return performSetup(windowTitle, configuration);
  }

  Future<bool> performSetup(
      String? windowTitle, PipConfiguration? configuration);

  @override
  void dispose() {
    stopPip().ignore();
    _pipStatusController.add(false);
    _isInitialized = false;
  }
}
