import 'dart:io' show Platform;
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'private_notes.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class PinScreen extends StatefulWidget {
  const PinScreen({super.key});

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  final List<TextEditingController> _pinControllers =
      List.generate(4, (index) => TextEditingController());
  final List<TextEditingController> _confirmPinControllers =
      List.generate(4, (index) => TextEditingController());
  final List<TextEditingController> _entryPinControllers =
      List.generate(4, (index) => TextEditingController());

  String? _savedPin;
  bool _isPinSet = false; // Track if a PIN has been set
  String? _errorMessage;

  Color primaryColor = const Color.fromRGBO(33, 133, 176, 1);
  Color secColor = const Color.fromRGBO(33, 133, 176, 0.3);

  @override
  void initState() {
    super.initState();
    _loadSavedPin();
  }

  final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  Future<void> _savePin(String pin) async {
    try {
      if (kIsWeb) {
        // Web storage implementation
        html.window.localStorage['private_pin'] = pin;
      } else if (Platform.isAndroid) {
        // Android secure storage
        await _storage.write(key: 'private_pin', value: pin);
      } else {
        // Fallback for other platforms
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('private_pin', pin);
      }

      setState(() {
        _savedPin = pin;
        _isPinSet = true;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Error saving PIN. Please try again.";
      });
    }
  }

  Future<void> _loadSavedPin() async {
    try {
      String? savedPin;
      if (!Platform.isAndroid) {
        // Fallback to regular storage for non-mobile platforms
        final prefs = await SharedPreferences.getInstance();
        savedPin = prefs.getString('private_pin');
      } else {
        savedPin = await _storage.read(key: 'private_pin');
      }
      setState(() {
        _savedPin = savedPin;
        _isPinSet = savedPin != null;
      });
    } catch (e) {
      setState(() {
        _savedPin = null;
        _isPinSet = false;
      });
    }
  }

  Future<void> _resetPin() async {
    try {
      if (!Platform.isAndroid) {
        // Fallback to regular storage for non-mobile platforms
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('private_pin');
      } else {
        await _storage.delete(key: 'private_pin');
      }
      setState(() {
        _savedPin = null;
        _isPinSet = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Error resetting PIN. Please try again.";
      });
    }
  }

  String _collectPin(List<TextEditingController> controllers) {
    return controllers.map((controller) => controller.text).join();
  }

  bool _isPinValid(List<TextEditingController> controllers) {
    return controllers.every((controller) =>
        controller.text.isNotEmpty && controller.text.length == 1);
  }

  void _clearControllers(List<TextEditingController> controllers) {
    for (var controller in controllers) {
      controller.clear();
    }
  }

  Widget _buildPinRow(List<TextEditingController> controllers) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        4,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: SizedBox(
            width: 50,
            child: TextField(
              controller: controllers[index],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 1,
              obscureText: true,
              decoration: InputDecoration(
                counterText: "",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                      color: controllers[index].text.isEmpty
                          ? secColor
                          : primaryColor,
                      width: controllers[index].text.isEmpty ? 2 : 3),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: primaryColor, width: 3),
                ),
              ),
              onChanged: (value) {
                if (value.isEmpty && index > 0) {
                  FocusScope.of(context).previousFocus();
                } else if (value.isNotEmpty && index < 3) {
                  FocusScope.of(context).nextFocus();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  void _showResetConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Reset PIN"),
        content: const Text(
            "Are you sure you want to reset your PIN? This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resetPin();
            },
            child: const Text("Reset"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Private Notes"),
        actions: [
          if (_isPinSet)
            IconButton(
              icon: const Icon(Icons.lock_reset),
              onPressed: _showResetConfirmationDialog,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (!_isPinSet) ...[
              const Text(
                "Set a 4-digit PIN",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildPinRow(_pinControllers),
              const SizedBox(height: 20),
              const Text("Confirm your PIN",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              _buildPinRow(_confirmPinControllers),
              if (_errorMessage != null) ...[
                const SizedBox(height: 10),
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ],
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (_isPinValid(_pinControllers) &&
                      _isPinValid(_confirmPinControllers)) {
                    final pin = _collectPin(_pinControllers);
                    final confirmPin = _collectPin(_confirmPinControllers);

                    if (pin == confirmPin) {
                      _savePin(pin);
                      _clearControllers(_pinControllers);
                      _clearControllers(_confirmPinControllers);
                    } else {
                      setState(() {
                        _errorMessage = "PINs do not match. Please try again.";
                      });
                    }
                  } else {
                    setState(() {
                      _errorMessage = "Please fill in all fields correctly.";
                    });
                  }
                },
                child: const Text("Save PIN"),
              ),
            ] else ...[
              const Text(
                "Enter your PIN",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildPinRow(_entryPinControllers),
              if (_errorMessage != null) ...[
                const SizedBox(height: 10),
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ],
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (_isPinValid(_entryPinControllers)) {
                    final enteredPin = _collectPin(_entryPinControllers);
                    if (enteredPin == _savedPin) {
                      // PIN validated successfully
                      setState(() {
                        _errorMessage = null;
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PrivateNotes()),
                      );
                    } else {
                      setState(() {
                        _errorMessage = "Incorrect PIN. Please try again.";
                      });
                    }
                  } else {
                    setState(() {
                      _errorMessage = "Please fill in all fields correctly.";
                    });
                  }
                },
                child: const Text("Enter"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
