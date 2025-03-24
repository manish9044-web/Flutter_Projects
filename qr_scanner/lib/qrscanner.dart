import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart' as contacts;
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  bool hasPermission = false;
  bool isFlashOn = false;

  late MobileScannerController scannerController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scannerController = MobileScannerController();
    _checkPermission();
  }

  @override
  void dispose() {
    scannerController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> _checkPermission() async {
    final status = await Permission.camera.request();
    setState(() {
      hasPermission = status.isGranted;
    });
  }

  Future<void> _processScannedData(String? data) async {
    if (data == null) return;
    scannerController.stop();
    String type = 'text';
    if (data.startsWith('BEGIN:VCARD')) {
      type = 'contact';
    } else if (data.startsWith('http://') || data.startsWith('https://')) {
      type = 'url';
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (context, controller) => Container(
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24))),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                "Scanned Result:",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                "Type: ${type.toUpperCase()}",
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              const SizedBox(height: 16),
              Expanded(
                  child: SingleChildScrollView(
                controller: controller,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SelectableText(data,
                        style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(
                      height: 24,
                    ),
                    if (type == 'url')
                      ElevatedButton.icon(
                        onPressed: () {
                          _launchURL;
                        },
                        icon: const Icon(Icons.open_in_new),
                        label: const Text("Open URL"),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                        ),
                      ),
                    if (type == 'contact')
                      ElevatedButton.icon(
                        onPressed: () {
                          _saveContact;
                        },
                        icon: const Icon(Icons.open_in_new),
                        label: const Text("Save Contact"),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                        ),
                      ),
                  ],
                ),
              )),
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Share.share(data);
                      },
                      icon: const Icon(Icons.share),
                      label: const Text("Share"),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        scannerController.start();
                      },
                      icon: const Icon(Icons.qr_code_scanner),
                      label: const Text("Scan Again"),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  Future<void> _saveContact(String vcardData) async {
    final lines = vcardData.split('\n');
    String? name, phone, email;
    for (var line in lines) {
      if (line.startsWith('FN:')) name = line.substring(3);
      if (line.startsWith('TEL:')) phone = line.substring(4);
      if (line.startsWith('EMAIL:')) email = line.substring(5);
    }
    final contact = contacts.Contact()
      ..name.first = name ?? ''
      ..phones = [contacts.Phone(phone ?? '')]
      ..emails = [contacts.Email(phone ?? '')];

    try {
      await contact.insert();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Contact Saved"),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed!"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //if permission is not granted or denied
    if (!hasPermission) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Scanner"),
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: SizedBox(
                height: 350,
                child: Card(
                  elevation: 0,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.camera_alt_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        const Text("Camera Permission Is Required"),
                        const SizedBox(
                          height: 16,
                        ),
                        ElevatedButton(
                          onPressed: _checkPermission,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo,
                              foregroundColor: Colors.white),
                          child: const Text("Grant Permission"),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      );
    } else {
      // if permission is granted, you can start scanning
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Scan QR Code"),
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  isFlashOn = !isFlashOn;
                  scannerController.toggleTorch();
                });
              },
              icon: Icon(isFlashOn ? Icons.flash_on : Icons.flash_off),
            ),
          ],
        ),
        body: Stack(
          children: [
            MobileScanner(
              controller: scannerController,
              onDetect: (capture) {
                final barcode = capture.barcodes.first;
                if (barcode.rawValue != null) {
                  final String code = barcode.rawValue!;
                  _processScannedData(code);
                }
              },
            ),
            Positioned(
                bottom: 24,
                left: 0,
                right: 0,
                child: Center(
                  child: Text("Align QR Code within the frame",
                  style: TextStyle(
                    color: Colors.white,
                    backgroundColor: Colors.black.withOpacity(0.6),
                    fontSize: 16,
                    fontWeight: FontWeight.w500
                  ),),
                ))
          ],
        ),
      );
    }
  }
}
