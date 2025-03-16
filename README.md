# TempConvert AI

## Description
TempConvert AI is a Flutter-based mobile application that converts temperatures between Celsius and Fahrenheit using AI models. It uses two TensorFlow Lite (TFLite) models for offline conversion, making it highly efficient and accessible without the need for an internet connection.

## Features
- Convert Celsius to Fahrenheit and vice versa.
- Offline inference with TFLite models.
- Simple and user-friendly interface.

## Requirements
- Flutter SDK
- TFLite Flutter Plugin
- TensorFlow Lite models (`c_to_f_model.tflite` and `f_to_c_model.tflite`)

## Installation
1. Clone the repository:
```bash
https://github.com/yourusername/TempConvertAI.git
```
2. Navigate to the project directory:
```bash
cd TempConvertAI
```
3. Install dependencies:
```bash
flutter pub get
```
4. Run the app:
```bash
flutter run
```

## Usage
- Choose the conversion type from the dropdown menu (Celsius to Fahrenheit or Fahrenheit to Celsius).
- Enter the temperature value and press the "Convert" button.
- View the converted temperature result.

## Model Details
- The app uses two TensorFlow Lite models:
  - `c_to_f_model.tflite`: Converts Celsius to Fahrenheit.
  - `f_to_c_model.tflite`: Converts Fahrenheit to Celsius.
- Both models are optimized for mobile devices and run entirely offline.

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License
MIT License. See `LICENSE` for more information.

