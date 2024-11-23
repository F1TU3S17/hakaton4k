import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerPage extends StatefulWidget {
  @override
  _QRScannerPageState createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> with WidgetsBindingObserver {
  late final MobileScannerController _controller;
  String? _displayMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = MobileScannerController();
    _controller.start();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_controller.value.hasCameraPermission) return;

    switch (state) {
      case AppLifecycleState.resumed:
        _controller.start();
        break;
      case AppLifecycleState.paused:
        _controller.stop();
        break;
      default:
        break;
    }
  }

  void _handleBarcode(BarcodeCapture capture) {
    final barcode = capture.barcodes.first;
    final rawValue = barcode.rawValue;

    if (rawValue == null) {
      _showMessage('Не удалось распознать QR-код');
      return;
    }

    final isValid = RegExp(
      r'^t=\d{8}T\d{4}&s=\d+\.\d{2}&fn=\d+&i=\d+&fp=\d+&n=\d+$',
    ).hasMatch(rawValue);

    if (isValid) {
      _showMessage('QR-код успешно распознан: $rawValue');
    } else {
      _showMessage('Неверный формат QR-кода');
    }
  }

  void _showMessage(String message) {
    setState(() {
      _displayMessage = message;
    });

    // Сбрасываем сообщение через 3 секунды
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _displayMessage = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Сканер QR-кода')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: MobileScanner(
              controller: _controller,
              onDetect: _handleBarcode,
              errorBuilder: (context, error, child) {
                return Center(child: Text('Ошибка камеры: $error'));
              },
            ),
          ),
          if (_displayMessage != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _displayMessage!,
                style: TextStyle(
                  fontSize: 16,
                  color: _displayMessage!.startsWith('QR-код успешно')
                      ? Colors.green
                      : Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.flash_on),
        onPressed: () {
          _controller.toggleTorch();
        },
      ),
    );
  }
}
