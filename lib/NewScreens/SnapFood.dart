import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SnapFood extends StatefulWidget {
  const SnapFood({super.key});

  @override
  State<StatefulWidget> createState() => _SnapFoodState();
}

class _SnapFoodState extends State<SnapFood> {
  // Track the active button
  String _activeButton = 'Scan Food'; // Default active button
  bool _permissionsRequested = false;

  // Image related variables
  File? _imageFile;
  String? _webImagePath;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _checkAndRequestPermissions();
    print("SnapFood screen initialized");
  }

  Future<void> _checkAndRequestPermissions() async {
    if (Platform.isIOS) {
      final prefs = await SharedPreferences.getInstance();
      bool permissionsShown =
          prefs.getBool('snapfood_permissions_shown') ?? false;

      if (!permissionsShown && mounted) {
        // Wait a moment for the screen to build before showing dialog
        Future.delayed(const Duration(milliseconds: 500), () {
          _showPermissionsDialog();
          prefs.setBool('snapfood_permissions_shown', true);
        });
      }
    }
  }

  void _showPermissionsDialog() {
    if (Platform.isIOS && mounted) {
      showCupertinoDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text("Permission Required"),
            content: const Text(
              "Snap Meal needs access to your camera and photo library to take and save food photos. "
              "This helps you track your meals and get nutritional information.",
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                child: const Text("Don't Allow"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              CupertinoDialogAction(
                isDefaultAction: true,
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                  _requestCameraPermission();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _requestCameraPermission() async {
    // This will trigger the actual iOS system permission dialog for camera
    try {
      // Just check availability, don't actually pick
      await _picker
          .pickImage(source: ImageSource.camera)
          .then((_) => _requestPhotoLibraryPermission());
    } catch (e) {
      print("Camera permission denied or error occurred: $e");
      _requestPhotoLibraryPermission();
    }
  }

  Future<void> _requestPhotoLibraryPermission() async {
    // This will trigger the actual iOS system permission dialog for photo library
    try {
      // Just check availability, don't actually pick
      await _picker.pickImage(source: ImageSource.gallery);
    } catch (e) {
      print("Photo library permission denied or error occurred: $e");
    }
  }

  Future<void> _pickImage() async {
    try {
      print("Opening image picker gallery...");
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        print("Image file selected: ${pickedFile.path}");

        if (mounted) {
          setState(() {
            if (kIsWeb) {
              // For web platform
              _webImagePath = pickedFile.path;
              _imageFile = null;
            } else {
              // For mobile platforms
              _imageFile = File(pickedFile.path);
              _webImagePath = null;
            }
          });
          print(
              "Image set to state: ${kIsWeb ? _webImagePath : _imageFile?.path}");
        } else {
          print("Widget not mounted, can't update state");
        }
      } else {
        print("No image selected from gallery");
      }
    } catch (e) {
      print("Error picking image: $e");

      if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) {
        // For desktop or web
        _showUnsupportedPlatformDialog();
      }
    }
  }

  Future<void> _takePicture() async {
    try {
      print("Opening camera...");

      // Check if camera is available (important for web platforms)
      bool isCameraAvailable = true;
      if (kIsWeb) {
        // For web, we'll just assume camera might not be available
        isCameraAvailable = false;
      } else if (Platform.isAndroid || Platform.isIOS) {
        // For mobile platforms, camera should be available
        isCameraAvailable = true;
      } else {
        // For desktop platforms, camera might not be available
        isCameraAvailable = false;
      }

      if (!isCameraAvailable) {
        print("Camera not available on this platform");
        if (mounted) {
          _showCameraUnavailableDialog();
        }
        return;
      }

      // Try to access camera directly, with no gallery fallback
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
      );

      if (pickedFile != null) {
        print("Photo taken: ${pickedFile.path}");

        if (mounted) {
          setState(() {
            if (kIsWeb) {
              // For web platform
              _webImagePath = pickedFile.path;
              _imageFile = null;
            } else {
              // For mobile platforms
              _imageFile = File(pickedFile.path);
              _webImagePath = null;
            }
          });
          print(
              "Photo set to state: ${kIsWeb ? _webImagePath : _imageFile?.path}");
        } else {
          print("Widget not mounted, can't update state");
        }
      } else {
        print("No photo taken");
      }
    } catch (e) {
      print("Error taking picture: $e");

      if (mounted) {
        _showCameraErrorDialog();
      }
    }
  }

  void _showCameraUnavailableDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Camera Unavailable"),
          content: const Text(
            "The camera is not available on this device. Please use the 'Add Photo' button to select an existing image.",
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showCameraErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Camera Error"),
          content: const Text(
            "There was an error accessing the camera. Please check your camera permissions and try again.",
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showUnsupportedPlatformDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Camera Unavailable"),
          content: const Text(
            "Camera access is not available on this platform. Please use the 'Add Photo' button to select an image from your gallery.",
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _scanFood() {
    print("Scanning food...");
    // Placeholder for food scanning functionality
  }

  void _scanCode() {
    print("Scanning QR/Barcode...");
    // Placeholder for code scanning functionality
  }

  void _setActiveButton(String buttonName) {
    setState(() {
      _activeButton = buttonName;
    });
    print("Active button changed to: $_activeButton");

    // Perform action based on the selected button
    switch (buttonName) {
      case 'Scan Food':
        _scanFood();
        break;
      case 'Scan Code':
        _scanCode();
        break;
      case 'Add Photo':
        _pickImage();
        break;
    }
  }

  // Helper method to check if we have an image
  bool get _hasImage => _imageFile != null || _webImagePath != null;

  // Function for camera only with no gallery fallback
  Future<void> _cameraOnly() async {
    try {
      print("Opening camera (shutter button)...");

      // Don't even attempt on web or desktop
      if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) {
        print("Camera not available on this platform");
        if (mounted) {
          _showCameraUnavailableDialog();
        }
        return;
      }

      // Try to access camera directly, with no fallback
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
      );

      if (pickedFile != null) {
        print("Photo taken with shutter button: ${pickedFile.path}");

        if (mounted) {
          setState(() {
            _imageFile = File(pickedFile.path);
            _webImagePath = null;
          });
        }
      } else {
        print("No photo taken with shutter button");
      }
    } catch (e) {
      print("Error accessing camera from shutter button: $e");
      if (mounted) {
        _showCameraErrorDialog();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Building SnapFood widget, has image: $_hasImage");
    if (_imageFile != null) {
      print("Image file path: ${_imageFile!.path}");
      print("Image file exists: ${_imageFile!.existsSync()}");
    }
    if (_webImagePath != null) {
      print("Web image path: $_webImagePath");
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Background - either selected image or black background
            if (_hasImage)
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: _getImageProvider(),
                    fit: BoxFit.contain, // Show original size, not zoomed in
                  ),
                  color: Colors.black, // Black background for letterboxing
                ),
              )
            else
              Container(
                color: Colors.black,
                width: double.infinity,
                height: double.infinity,
              ),

            // Top corner frames as a group
            Positioned(
              top: 102, // Distance from gray circle (21+36+45=102)
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 29),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCornerFrame(topLeft: true),
                    _buildCornerFrame(topRight: true),
                  ],
                ),
              ),
            ),

            // Bottom corner frames as a group
            Positioned(
              bottom: 223, // Adjusted for 45px gap (109+69+45=223)
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 29),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCornerFrame(bottomLeft: true),
                    _buildCornerFrame(bottomRight: true),
                  ],
                ),
              ),
            ),

            // Gray circle behind back button
            Positioned(
              top: 21,
              left: 29,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // Back button
            Positioned(
              top: 21,
              left: 29,
              child: SizedBox(
                width: 36,
                height: 36,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                    size: 24,
                  ),
                  iconSize: 24,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  padding: EdgeInsets.zero,
                  alignment: Alignment.center,
                  constraints: const BoxConstraints
                      .expand(), // Fill the entire container
                ),
              ),
            ),

            // Bottom action buttons (Scan Food, Scan Code, Add Photo)
            Positioned(
              bottom:
                  109, // Adjusted to create 24px gap with shutter button (15 + 70 + 24 = 109)
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 29),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Scan Food button
                    GestureDetector(
                      onTap: () {
                        _setActiveButton('Scan Food');
                      },
                      child: Container(
                        width: 99,
                        height: 69, // Increased to 69px as requested
                        decoration: BoxDecoration(
                          color: _activeButton == 'Scan Food'
                              ? Colors.white
                              : Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Image.asset(
                                'assets/images/foodscan.png',
                                width: 31,
                                height: 31,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Scan Food',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Scan Code button
                    GestureDetector(
                      onTap: () {
                        _setActiveButton('Scan Code');
                      },
                      child: Container(
                        width: 99,
                        height: 69, // Increased to 69px as requested
                        decoration: BoxDecoration(
                          color: _activeButton == 'Scan Code'
                              ? Colors.white
                              : Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Image.asset(
                                'assets/images/qrcodescan.png',
                                width: 31,
                                height: 31,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Scan Code',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Add Photo button
                    GestureDetector(
                      onTap: () {
                        _setActiveButton('Add Photo');
                      },
                      child: Container(
                        width: 99,
                        height: 69, // Increased to 69px as requested
                        decoration: BoxDecoration(
                          color: _activeButton == 'Add Photo'
                              ? Colors.white
                              : Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 8.0,
                                  left:
                                      2.0), // Added 2px padding to the left to shift image right
                              child: Image.asset(
                                'assets/images/addphoto.png',
                                width: 31,
                                height: 31,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Add Photo',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Shutter button - camera only, no gallery fallback
            Positioned(
              bottom: 15,
              left: 29, // Adjusted to match 29px padding
              right: 29, // Adjusted to match 29px padding
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Flash button
                  Padding(
                    padding: const EdgeInsets.only(right: 40),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        'assets/images/flashwhite.png',
                        width: 37,
                        height: 37,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  // Shutter button - camera only, no gallery fallback
                  GestureDetector(
                    onTap:
                        _cameraOnly, // New dedicated camera function with no gallery fallback
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Empty space to balance the layout
                  const SizedBox(width: 80),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to get the appropriate image provider based on platform
  ImageProvider _getImageProvider() {
    if (kIsWeb && _webImagePath != null) {
      // For web platform, use NetworkImage for blob URLs
      return NetworkImage(_webImagePath!);
    } else if (_imageFile != null && _imageFile!.existsSync()) {
      // For mobile platforms, use FileImage
      return FileImage(_imageFile!);
    } else {
      // Fallback to a placeholder
      return const AssetImage('assets/images/placeholder.png');
    }
  }

  // Helper method to build corner frames
  Widget _buildCornerFrame({
    bool topLeft = false,
    bool topRight = false,
    bool bottomLeft = false,
    bool bottomRight = false,
  }) {
    return SizedBox(
      width: 50,
      height: 50,
      child: CustomPaint(
        painter: CornerPainter(
          topLeft: topLeft,
          topRight: topRight,
          bottomLeft: bottomLeft,
          bottomRight: bottomRight,
        ),
      ),
    );
  }
}

// Custom painter for the corner frames
class CornerPainter extends CustomPainter {
  final bool topLeft;
  final bool topRight;
  final bool bottomLeft;
  final bool bottomRight;

  CornerPainter({
    this.topLeft = false,
    this.topRight = false,
    this.bottomLeft = false,
    this.bottomRight = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final width = size.width;
    final height = size.height;
    final lineLength = size.width * 0.7;

    if (topLeft) {
      // Top line
      canvas.drawLine(
        Offset(0, 0),
        Offset(lineLength, 0),
        paint,
      );
      // Left line
      canvas.drawLine(
        Offset(0, 0),
        Offset(0, lineLength),
        paint,
      );
    } else if (topRight) {
      // Top line
      canvas.drawLine(
        Offset(width, 0),
        Offset(width - lineLength, 0),
        paint,
      );
      // Right line
      canvas.drawLine(
        Offset(width, 0),
        Offset(width, lineLength),
        paint,
      );
    } else if (bottomLeft) {
      // Bottom line
      canvas.drawLine(
        Offset(0, height),
        Offset(lineLength, height),
        paint,
      );
      // Left line
      canvas.drawLine(
        Offset(0, height),
        Offset(0, height - lineLength),
        paint,
      );
    } else if (bottomRight) {
      // Bottom line
      canvas.drawLine(
        Offset(width, height),
        Offset(width - lineLength, height),
        paint,
      );
      // Right line
      canvas.drawLine(
        Offset(width, height),
        Offset(width, height - lineLength),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CornerPainter oldDelegate) => false;
}
