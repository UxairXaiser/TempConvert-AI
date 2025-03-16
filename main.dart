import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:async';
import 'splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TempConvert AI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) =>  SplashScreen(),
        '/home': (context) => const ConverterPage(),
      },
    );
  }
}

class ConverterPage extends StatefulWidget {
  const ConverterPage({super.key});

  @override
  State<ConverterPage> createState() => _ConverterPageState();
}

class _ConverterPageState extends State<ConverterPage> {
  Interpreter? interpreterCF;
  Interpreter? interpreterFC;
  final TextEditingController _controller = TextEditingController();
  double? _result;
  String _status = 'Loading models...';
  bool _isProcessing = false;
  bool _modelsLoaded = false;
  String _conversionType = 'C to F';

  @override
  void initState() {
    super.initState();
    loadModels();
  }

  Future<void> loadModels() async {
    try {
      interpreterCF = await Interpreter.fromAsset('assets/c_to_f_model.tflite');
      interpreterFC = await Interpreter.fromAsset('assets/f_to_c_model.tflite');
      setState(() {
        _modelsLoaded = true;
        _status = "Models loaded successfully!";
      });
    } catch (e) {
      setState(() {
        _status = "Error loading models: $e";
      });
    }
  }

  void convert() async {
    if (_controller.text.isEmpty) return;
    double? inputValue = double.tryParse(_controller.text);
    if (inputValue == null) return;

    setState(() {
      _isProcessing = true;
      _status = "Running model, please wait...";
    });

    try {
      var input = npFromDouble(inputValue);
      var output = List.filled(1, 0.0).reshape([1, 1]);

      if (_conversionType == 'C to F') {
        interpreterCF!.run(input, output);
      } else {
        interpreterFC!.run(input, output);
      }
      setState(() {
        _result = output[0][0];
        _status = "Conversion Successful!";
        _isProcessing = false;
      });
    } catch (e) {
      setState(() {
        _status = "Error during inference: $e";
        _isProcessing = false;
      });
    }
  }

  List<List<double>> npFromDouble(double value) {
    return [[value]];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TempConvert AI'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _modelsLoaded
            ? SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton<String>(
                value: _conversionType,
                items: const [
                  DropdownMenuItem(value: 'C to F', child: Text('Celsius to Fahrenheit')),
                  DropdownMenuItem(value: 'F to C', child: Text('Fahrenheit to Celsius')),
                ],
                onChanged: (value) {
                  setState(() {
                    _conversionType = value!;
                    _result = null;
                  });
                },
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: _conversionType == 'C to F'
                      ? 'Enter temperature in Celsius'
                      : 'Enter temperature in Fahrenheit',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isProcessing ? null : convert,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                child: _isProcessing
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Convert', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 20),
              Text(
                _status,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
              const SizedBox(height: 20),
              if (_result != null)
                Card(
                  color: Colors.blue[100],
                  margin: const EdgeInsets.all(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _conversionType == 'C to F'
                          ? 'Result: ${_result!.toStringAsFixed(2)} °F'
                          : 'Result: ${_result!.toStringAsFixed(2)} °C',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        )
            : const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        ),
      ),
    );
  }
}
