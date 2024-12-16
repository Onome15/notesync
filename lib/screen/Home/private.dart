import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrivatePage extends StatefulWidget {
  const PrivatePage({Key? key}) : super(key: key);

  @override
  State<PrivatePage> createState() => _PrivatePageState();
}

class _PrivatePageState extends State<PrivatePage> {
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

  Future<void> _loadSavedPin() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedPin = prefs.getString('private_pin');
      _isPinSet = _savedPin != null;
    });
  }

  Future<void> _savePin(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('private_pin', pin);
    setState(() {
      _savedPin = pin;
      _isPinSet = true;
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Private Notes"),
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
                            builder: (context) => const NoPrivateNotesPage()),
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

class NoPrivateNotesPage extends StatelessWidget {
  const NoPrivateNotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Private Notes"),
      ),
      body: const Center(
        child: Text(
          "No private notes yet, add private notes from My Notes.",
          style: TextStyle(fontSize: 16, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
