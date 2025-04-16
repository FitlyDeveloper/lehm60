import 'package:flutter/material.dart';
import 'package:fitness_app/Features/onboarding/presentation/screens/next_intro_screen_3.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NextIntroScreen2 extends StatefulWidget {
  final bool isMetric;
  final int initialWeight;

  const NextIntroScreen2({
    super.key,
    required this.isMetric,
    required this.initialWeight,
  });

  @override
  State<NextIntroScreen2> createState() => _NextIntroScreen2State();
}

class _NextIntroScreen2State extends State<NextIntroScreen2> {
  double _sliderValue = 45.0; // Start at 45 minutes

  String _formatTime(double minutes) {
    if (minutes < 60) {
      return '${minutes.toInt()} minutes';
    } else {
      int hours = (minutes / 60).floor();
      int remainingMinutes = (minutes % 60).toInt();
      if (remainingMinutes == 0) {
        return '$hours ${hours == 1 ? 'hour' : 'hours'}';
      } else {
        return '$hours ${hours == 1 ? 'hour' : 'hours'} $remainingMinutes minutes';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Box 4 (background with gradient)
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  Colors.grey[100]!.withOpacity(0.9),
                ],
              ),
            ),
          ),

          // Header content (back arrow and progress bar)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.07),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back,
                            color: Colors.black, size: 24),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 40),
                          child: const LinearProgressIndicator(
                            value: 4 / 13,
                            minHeight: 2,
                            backgroundColor: Color(0xFFE5E5EA),
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 21.2),
                  // Title
                  const Text(
                    'How long can you work out in one session?',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                      height: 1.21,
                      fontFamily: '.SF Pro Display',
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(
                      height:
                          MediaQuery.of(context).size.height * 0.01), // 1% gap
                  // Subtitle
                  Text(
                    'This helps us create the best gym workout plan for you.', // We'll change this text later
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                      height: 1.3,
                      fontFamily: '.SF Pro Display',
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Slider content
          Positioned(
            left: 24,
            right: 24,
            top: MediaQuery.of(context).size.height * 0.52,
            child: Column(
              children: [
                SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 2,
                    activeTrackColor: Colors.black,
                    inactiveTrackColor: Colors.grey[300],
                    thumbColor: Colors.white,
                    overlayColor: Colors.black.withOpacity(0.05),
                    overlayShape: const RoundSliderOverlayShape(
                      overlayRadius: 17,
                    ),
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 12,
                      elevation: 4,
                    ),
                  ),
                  child: Slider(
                    value: _sliderValue,
                    min: 15,
                    max: 120,
                    divisions: 7,
                    onChanged: (value) {
                      if ((value - _sliderValue).abs() > 15) {
                        setState(() {
                          _sliderValue = (value / 15).round() * 15;
                        });
                      } else {
                        setState(() {
                          _sliderValue = (value / 15).round() * 15;
                        });
                      }
                    },
                    mouseCursor: MaterialStateMouseCursor.clickable,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _formatTime(_sliderValue),
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    fontFamily: '.SF Pro Display',
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          // Box 5 (white box at bottom)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: MediaQuery.of(context).size.height * 0.148887,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.zero,
              ),
            ),
          ),

          // Box 6 (black button)
          Positioned(
            left: 24,
            right: 24,
            bottom: MediaQuery.of(context).size.height * 0.06,
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.0689,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(28),
              ),
              child: TextButton(
                onPressed: () {
                  _loadHeightAndNavigate();
                },
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    fontFamily: '.SF Pro Display',
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper to load height from SharedPreferences before navigating
  Future<void> _loadHeightAndNavigate() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Default height only as last resort
      int heightInCm = 0;
      bool heightFound = false;

      print('DEBUG: Loading height from SharedPreferences in NextIntroScreen2');

      // First check if we have original height in feet/inches (most accurate for imperial)
      if (prefs.containsKey('original_height_feet') &&
          prefs.containsKey('original_height_inches')) {
        try {
          int? feet = prefs.getInt('original_height_feet');
          int? inches = prefs.getInt('original_height_inches');

          if (feet != null && inches != null) {
            // Convert feet/inches to cm using the same formula as in weight_height_screen
            heightInCm = ((feet * 12 + inches) * 2.54).round();
            print(
                'Calculated height from feet($feet) and inches($inches): $heightInCm cm');
            heightFound = true;
          }
        } catch (e) {
          print('Error reading original height feet/inches: $e');
        }
      }

      // Try all possible height keys if we didn't find it above
      if (!heightFound) {
        List<String> heightKeys = [
          'user_height_cm',
          'heightInCm',
          'height_cm',
          'height'
        ];

        // Try each key
        for (String key in heightKeys) {
          if (prefs.containsKey(key)) {
            try {
              // Try as int first
              int? height = prefs.getInt(key);
              if (height != null) {
                heightInCm = height;
                print('Found height (as int) in key "$key": $heightInCm cm');
                heightFound = true;
                break;
              }

              // Then try as double
              double? heightDouble = prefs.getDouble(key);
              if (heightDouble != null) {
                heightInCm = heightDouble.round();
                print('Found height (as double) in key "$key": $heightInCm cm');
                heightFound = true;
                break;
              }
            } catch (e) {
              print('Error reading height from key "$key": $e');
            }
          }
        }
      }

      // Use default height only if all attempts fail
      if (!heightFound) {
        heightInCm = 170; // Default height
        print(
            'WARNING: No height found in SharedPreferences, using default: $heightInCm cm');
      }

      print('NextIntroScreen2: Final height value to use: $heightInCm cm');

      // Navigate to next screen with workout time and height data
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NextIntroScreen3(
            isMetric: widget.isMetric,
            initialWeight: widget.initialWeight,
            workoutTime: _sliderValue.toInt(),
            heightInCm: heightInCm,
          ),
        ),
      );
    } catch (e) {
      print('Error loading height from SharedPreferences: $e');
      // Continue with navigation using default height
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NextIntroScreen3(
            isMetric: widget.isMetric,
            initialWeight: widget.initialWeight,
            workoutTime: _sliderValue.toInt(),
            heightInCm: 170, // Default height if loading fails
          ),
        ),
      );
    }
  }
}
