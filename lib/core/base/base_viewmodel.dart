import 'package:flutter/foundation.dart';

/// Base class for all ViewModels. Provides:
/// - Guarded [notifyListeners] that silently no-ops after [dispose]
/// - Safe [dispose] that sets the disposed flag
abstract class BaseViewModel extends ChangeNotifier {
  bool _disposed = false;

  bool get disposed => _disposed;

  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
