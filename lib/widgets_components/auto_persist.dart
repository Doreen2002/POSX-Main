import 'package:flutter/material.dart';
import '../data_source/local/user_preference.dart';

/// AutoPersist<T>
/// Generic helper that loads a preference key and persists changes automatically.
/// Use AutoPersist to wrap any control that represents a single primitive preference.
class AutoPersist<T> extends StatefulWidget {
  final String prefKey;
  final T defaultValue;
  final Widget Function(BuildContext context, T value, void Function(T) onChanged) builder;

  const AutoPersist({required this.prefKey, required this.defaultValue, required this.builder, super.key});

  @override
  State<AutoPersist<T>> createState() => _AutoPersistState<T>();
}

class _AutoPersistState<T> extends State<AutoPersist<T>> {
  late T _value;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _value = widget.defaultValue;
    _load();
  }

  Future<void> _load() async {
    await UserPreference.getInstance();
    dynamic v;
    if (T == bool) v = UserPreference.getBool(widget.prefKey);
    else if (T == int) v = UserPreference.getInt(widget.prefKey);
    else if (T == double) v = UserPreference.getDouble(widget.prefKey);
    else if (T == List<String>) v = UserPreference.getStringList(widget.prefKey);
    else v = UserPreference.getString(widget.prefKey);

    if (v != null) {
      setState(() {
        _value = v as T;
        _loaded = true;
      });
    } else {
      setState(() => _loaded = true);
    }
  }

  Future<void> _save(T newVal) async {
    await UserPreference.getInstance();
    if (newVal is bool) await UserPreference.putBool(widget.prefKey, newVal);
    else if (newVal is int) await UserPreference.putInt(widget.prefKey, newVal);
    else if (newVal is double) await UserPreference.putDouble(widget.prefKey, newVal);
    else if (newVal is List<String>) await UserPreference.putStringList(widget.prefKey, newVal as List<String>);
    else await UserPreference.putString(widget.prefKey, newVal?.toString() ?? '');
  }

  void _onChanged(T newVal) {
    setState(() => _value = newVal);
    _save(newVal);
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) return const SizedBox(height: 24, child: Center(child: CircularProgressIndicator()));
    return widget.builder(context, _value, _onChanged);
  }
}
