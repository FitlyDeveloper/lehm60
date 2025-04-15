import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:shared_preferences/shared_preferences.dart';
import 'Memories.dart';
import '../../NewScreens/ChooseWorkout.dart';
import '../../NewScreens/Coach.dart';
import 'flip_card.dart';
import 'home_card2.dart';
import '../../NewScreens/FoodCardOpen.dart';

class CodiaPage extends StatefulWidget {
  CodiaPage({super.key});

  @override
  State<StatefulWidget> createState() => _CodiaPageState();
}

class _CodiaPageState extends State<CodiaPage> {
  int _selectedIndex = 0; // Track selected nav item
  bool _showFrontCard = true; // Track which card is showing
  bool isLoading = true; // Add this if it doesn't exist
  int targetCalories = 0; // Add this if it doesn't exist
  int remainingCalories = 0; // Add this to track remaining calories
  bool isImperial = false; // Track metric/imperial setting
  double originalGoalSpeed = 0.0; // Track original goal speed for logs

  // User data variables - will be populated from saved answers
  String userGender = 'Female'; // Default values, will be overridden
  double userWeightKg = 70.0;
  double userHeightCm = 165.0;
  int userAge = 30;
  String userGoal = 'maintain'; // FIXED: Default to maintain instead of lose
  double goalSpeedKgPerWeek = 0.5;
  double dailyCalorieAdjustment = 0.0; // Add this line to track the adjustment
  String userGymGoal =
      "null"; // FIXED: Default to "null" for balanced macros, not "Build Muscle"

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Load the user's actual data from storage
  }

  // Load user data from SharedPreferences
  Future<void> _loadUserData() async {
    isLoading = true;

    final prefs = await SharedPreferences.getInstance();

    debugPrint('Loading user data and calculating nutrition needs...');
    debugPrint('Keys in SharedPreferences: ${prefs.getKeys().toString()}');

    // Debug - dump all data in the console to inspect
    debugPrint('\nALL SHAREDPREFERENCES DATA:');
    for (var key in prefs.getKeys()) {
      if (key == 'user_weight_kg') {
        debugPrint('$key: ${prefs.getDouble(key)}');
      } else if (key == 'user_height_cm') {
        debugPrint('$key: ${prefs.getInt(key)}');
      } else if (key.contains('gender')) {
        debugPrint('GENDER KEY FOUND: $key: ${prefs.getString(key)}');
      } else {
        try {
          debugPrint(
              '$key: ${prefs.getString(key) ?? prefs.getDouble(key) ?? prefs.getInt(key) ?? prefs.getBool(key)}');
        } catch (e) {
          debugPrint('$key: Error reading');
        }
      }
    }

    // Get birth date and calculate age exactly like before - this works correctly
    String? birthDateStr = prefs.getString('birth_date');
    debugPrint('Loaded birth_date: $birthDateStr');

    int age = 25; // Default age
    if (birthDateStr != null) {
      try {
        DateTime birthDate = DateTime.parse(birthDateStr);
        age = DateTime.now().year - birthDate.year;
        if (DateTime.now().month < birthDate.month ||
            (DateTime.now().month == birthDate.month &&
                DateTime.now().day < birthDate.day)) {
          age--;
        }
        debugPrint(
            'Successfully calculated age: $age from birth date: $birthDateStr');
      } catch (e) {
        debugPrint('Error parsing birth date: $e');
      }
    }

    // Read the user's gender selection
    String gender;

    // Check SharedPreferences for gender (reduced logging)
    if (prefs.containsKey('user_gender')) {
      gender = prefs.getString('user_gender')!;
    } else if (prefs.containsKey('gender')) {
      gender = prefs.getString('gender')!;
    } else {
      gender = 'Female'; // Default to Female if no gender found
    }
    debugPrint('Using gender: "$gender"');

    // Get goal - exact same key as in speed_screen
    String goal = prefs.getString('goal') ?? 'maintain';
    debugPrint('Loaded goal from SharedPreferences: "$goal"');

    // CRITICAL CHECK: Explicitly look for 'maintain' goal
    bool isMaintaining = goal == 'maintain';
    if (isMaintaining) {
      debugPrint('DETECTED MAINTAIN GOAL - will use TDEE with no adjustment');
    } else {
      debugPrint('Goal is not maintain: "$goal"');
    }

    // Get gym goal - used for macro distribution
    String? gymGoal = prefs.getString('gymGoal');
    debugPrint('Loaded gymGoal: "$gymGoal"');

    // Check if gymGoal is different from common values
    if (gymGoal != null) {
      debugPrint('Found gymGoal in SharedPreferences: "$gymGoal"');
    } else {
      debugPrint(
          'gymGoal is NULL in SharedPreferences, will default to "null" string');
    }

    // Get goal speed multiplier - exact same key as in speed_screen
    double goalSpeed = prefs.getDouble('goal_speed') ?? 1.0;
    double originalGoalSpeed = goalSpeed; // Store original value for logging

    // Get is_metric setting if available
    bool isMetric = prefs.getBool('is_metric') ??
        false; // Default to false (imperial) to be safe

    // FIXED DETECTION: We need to determine if we're in imperial units
    // Since the is_metric flag isn't being saved to SharedPreferences, detect based on:
    // 1. If weightInKg is unusually high (American weights are ~2.2x higher in lbs than kg)
    // 2. If goalSpeed is a common imperial value (usually 1-2 lbs/week)
    bool isLikelyImperial = false;

    // Get weight using exact same key as weight_height_screen and weight_height_copy_screen
    double weightInKg = prefs.getDouble('user_weight_kg') ?? 70.0;
    debugPrint('Loaded weight: $weightInKg kg');

    // If weight is >100kg, it's likely in pounds
    if (weightInKg > 100) {
      isLikelyImperial = true;
      debugPrint('Detected imperial units from high weight value: $weightInKg');
    }

    // If goal speed is a common imperial value and not a clean metric value
    if (goalSpeed >= 0.5 && goalSpeed <= 2.0 && goalSpeed % 0.5 == 0) {
      isLikelyImperial = true;
      debugPrint(
          'Detected imperial units from typical imperial goal speed: $goalSpeed lb/week');
    }

    // Override the setting if we detected imperial units
    if (isLikelyImperial) {
      isMetric = false;
    }

    // Final determination of units
    isImperial = !isMetric;
    debugPrint(
        'Unit system: ${isMetric ? "Metric" : "Imperial"} (${isLikelyImperial ? "detected from values" : "from settings"})');

    // Only convert if using imperial units
    if (isImperial) {
      // Convert from lb/week to kg/week (1 lb ≈ 0.453592 kg)
      goalSpeed = goalSpeed * 0.453592;

      // Round to 1 decimal place immediately after conversion
      goalSpeed = double.parse(goalSpeed.toStringAsFixed(1));

      debugPrint(
          'UNIT CONVERSION: $originalGoalSpeed lb/week → $goalSpeed kg/week');
    } else {
      // Still round metric values to 1 decimal place for consistency
      goalSpeed = double.parse(goalSpeed.toStringAsFixed(1));
      debugPrint(
          'No unit conversion needed: $goalSpeed kg/week (already metric)');
    }

    // Set goal speed to 0.0 if goal is maintain - CRITICAL FIX
    if (isMaintaining) {
      debugPrint('Goal is "maintain", setting goalSpeed to 0.0');
      goalSpeed = 0.0;
    } else {
      debugPrint('Goal is "$goal", keeping goalSpeed at $goalSpeed');
    }

    // Clearer debug message showing original and final values
    if (isImperial) {
      debugPrint(
          'Final goal_speed: $goalSpeed kg/week (converted from $originalGoalSpeed lb/week)');
    } else {
      debugPrint('Final goal_speed: $goalSpeed kg/week');
    }

    // Get height using exact same key as weight_height_screen and weight_height_copy_screen
    int heightCm = prefs.getInt('user_height_cm') ?? 165;
    debugPrint('Loaded height: $heightCm cm');

    // Update state with loaded values
    setState(() {
      userGender = gender;
      userWeightKg = weightInKg;
      userHeightCm = heightCm.toDouble();
      userAge = age;
      userGoal = goal;
      goalSpeedKgPerWeek = goalSpeed;
      dailyCalorieAdjustment =
          goalSpeed * 1100.0; // Approx 1100 calories per kg
      userGymGoal = gymGoal ?? "null"; // Handle null case
      targetCalories = _calculateTargetCalories().toInt();
      remainingCalories = targetCalories; // Set remaining to target initially
      isLoading = false;
    });

    // Log final values with clearer unit information
    debugPrint('FINAL VALUES:');
    debugPrint('- Age: $userAge');
    debugPrint('- Gender: "$userGender"');
    debugPrint('- Weight: $userWeightKg kg');
    debugPrint('- Height: $userHeightCm cm');
    debugPrint('- Goal: "$userGoal"');
    debugPrint('- Gym Goal: $userGymGoal');

    // Show both imperial and metric values if using imperial
    if (isImperial) {
      debugPrint(
          '- Goal Speed: $goalSpeedKgPerWeek kg/week (equivalent to $originalGoalSpeed lb/week)');
    } else {
      debugPrint('- Goal Speed: $goalSpeedKgPerWeek kg/week');
    }

    debugPrint('- Target Calories: $targetCalories');
  }

  // Calculate target calories based on user data
  double _calculateTargetCalories() {
    // Add debug print to catch test data
    if (userWeightKg == 65.0 && userHeightCm == 170.0) {
      print(
          'WARNING: DETECTED TEST DATA SET! Using fixed values of 65kg and 170cm.');
      print(
          'This is likely happening because _setTestUserData() is being called somewhere.');

      // Load real data from SharedPreferences again if needed
      // Uncomment this to force loading real data:
      // _loadUserData();
      // return 0.0; // Return early and let _loadUserData update the state
    }

    // Print input values
    print('CALCULATION INPUTS:');
    print('- Gender: "$userGender"');
    print('- Weight: $userWeightKg kg');
    print('- Height: $userHeightCm cm');
    print('- Age: $userAge');
    print('- Goal: "$userGoal"');
    print('- Goal Speed: $goalSpeedKgPerWeek kg/week');
    print('- Gym Goal: "$userGymGoal"');
    if (isImperial) {
      print('  (Original: $originalGoalSpeed lb/week)');
    }

    // Calculate BMR (Mifflin-St Jeor Formula)
    double bmr;
    if (userGender == "Female") {
      bmr = (10 * userWeightKg) + (6.25 * userHeightCm) - (5 * userAge) - 161;
    } else if (userGender == "Male") {
      bmr = (10 * userWeightKg) + (6.25 * userHeightCm) - (5 * userAge) + 5;
    } else {
      // Default to female formula for "Other"
      bmr = (10 * userWeightKg) + (6.25 * userHeightCm) - (5 * userAge) - 161;
    }

    // Calculate TDEE with activity level
    // We'll use different multipliers based on activity level
    // 1.2: Sedentary (little or no exercise)
    // 1.375: Lightly active (light exercise/sports 1-3 days/week)
    // 1.55: Moderately active (moderate exercise/sports 3-5 days/week)
    // 1.725: Very active (hard exercise/sports 6-7 days a week)
    // 1.9: Extra active (very hard exercise, physical job or training twice a day)
    double activityMultiplier = 1.2; // Assuming sedentary as default
    double tdee = bmr * activityMultiplier;

    // Calculate Daily Calorie Adjustment based on Goal Speed
    double weeklyCalorieAdjustment =
        goalSpeedKgPerWeek * 7700; // 7700 kcal ≈ 1kg
    dailyCalorieAdjustment = weeklyCalorieAdjustment / 7;

    // Print clear debugging info about the goal and what we're doing
    print('GOAL PROCESSING:');
    print('- User goal from SharedPreferences: "$userGoal"');
    print('- Goal speed from SharedPreferences: $goalSpeedKgPerWeek kg/week');

    // FIX: Calculate Final Target Calories based on Goal correctly
    // IMPORTANT: Use the exact same approach as in calculation_screen.dart
    double targetCalories;
    if (userGoal == 'lose') {
      print(
          '- Goal identified as LOSE WEIGHT - subtracting daily adjustment from TDEE');
      targetCalories = tdee - dailyCalorieAdjustment;
    } else if (userGoal == 'gain') {
      print(
          '- Goal identified as GAIN WEIGHT - adding daily adjustment to TDEE');
      targetCalories = tdee + dailyCalorieAdjustment;
    } else {
      // maintain - use TDEE directly with no adjustment
      print(
          '- Goal identified as MAINTAIN WEIGHT - using TDEE with no adjustment');
      targetCalories = tdee;
      // For maintain goal, ensure daily adjustment is 0
      dailyCalorieAdjustment = 0;
    }

    // Print calculation steps for debugging
    print('CALCULATION STEPS:');
    print('- BMR: $bmr calories/day');
    print('- Activity Multiplier: $activityMultiplier');
    print('- TDEE (BMR * Activity): $tdee calories/day');
    print(
        '- Weekly Calorie Adjustment: ${weeklyCalorieAdjustment.toStringAsFixed(0)} calories (${goalSpeedKgPerWeek.toStringAsFixed(1)} kg × 7700)');
    print(
        '- Daily Calorie Adjustment: ${dailyCalorieAdjustment.toStringAsFixed(0)} calories/day');
    print(
        '- Target Calories (before minimum): ${targetCalories.toStringAsFixed(0)} calories/day');

    // Set a minimum healthy calorie limit
    double minimumCalories = userGender == "Male" ? 1500 : 1200;
    if (targetCalories < minimumCalories && userGoal == 'lose') {
      print(
          '- Warning: Calculated target below minimum. Using $minimumCalories calories/day instead');
      targetCalories = minimumCalories;
    }

    // Final debug statement to confirm actual values used in calculation
    debugPrint('FINAL CALCULATION RESULT:');
    debugPrint('- Weight: $userWeightKg kg');
    debugPrint('- Height: $userHeightCm cm');
    debugPrint('- Age: $userAge');
    debugPrint('- Gender: "$userGender"');
    debugPrint('- Goal: "$userGoal"');
    debugPrint('- Target Calories: ${targetCalories.toInt()} calories/day');

    return targetCalories;
  }

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Stack(
      children: [
        // Background and scrollable content
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background4.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Add padding for status bar
                SizedBox(height: statusBarHeight),

                // Header with Fitly title and icons
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 29, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Calendar icon
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MemoriesScreen(),
                            ),
                          );
                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 26, vertical: 8),
                          width: 70,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Image.asset(
                            'assets/images/calendar.png',
                            width: 19.4,
                            height: 19.4,
                          ),
                        ),
                      ),

                      // Fitly title
                      Text(
                        'Fitly',
                        style: TextStyle(
                          fontSize: 34.56,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SF Pro Display',
                          color: Colors.black,
                          decoration: TextDecoration.none,
                        ),
                      ),

                      // Streak icon with count
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        width: 70, // Fixed width
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/images/streak0.png',
                              width: 19.4,
                              height: 19.4,
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              '0',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Today text
                Padding(
                  padding: const EdgeInsets.only(left: 29, top: 8, bottom: 16),
                  child: Text(
                    'Today',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SF Pro Display',
                      color: Colors.black,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),

                // Flippable Calorie/Activity card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 29),
                  child: FlipCard(
                    frontSide: _buildCalorieCard(),
                    backSide: HomeCard2(),
                    onFlip: () {
                      setState(() {
                        _showFrontCard = !_showFrontCard;
                      });
                    },
                  ),
                ),

                // Pagination dots
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _showFrontCard
                                ? Colors.black
                                : Color(0xFFDADADA),
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _showFrontCard
                                ? Color(0xFFDADADA)
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Snap Meal and Coach buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 29),
                  child: Row(
                    children: [
                      // Snap Meal button
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            // Removed navigation to FoodCardOpen
                            // No functionality for now
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/camera.png',
                                  width: 24,
                                  height: 24,
                                ),
                                SizedBox(width: 14),
                                Text(
                                  'Snap Meal',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: 22),

                      // Coach button
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            // Navigate to Coach screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CoachScreen(),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/coach.png',
                                  width: 24,
                                  height: 24,
                                ),
                                SizedBox(width: 14),
                                Text(
                                  'Coach',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Recent Activity section
                Padding(
                  padding: const EdgeInsets.only(left: 29, top: 24, bottom: 16),
                  child: Text(
                    'Recent Activity',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SF Pro Display',
                      color: Colors.black,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),

                // Carrot with Meat item
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 29, vertical: 8),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FoodCardOpen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Food image placeholder
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              width:
                                  92, // Changed from 104 to 92 to make a perfect square
                              height: 92,
                              color: Color(0xFFDADADA),
                              child: Center(
                                child: Image.asset(
                                  'assets/images/meal1.png',
                                  width: 28,
                                  height: 28,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(width: 12),

                          // Food details
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical:
                                      8), // Reduced from 12 to make card smaller
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Carrot with Meat...',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 6.6, vertical: 2.2),
                                        decoration: BoxDecoration(
                                          color: Color(0xFFF2F2F2),
                                          borderRadius:
                                              BorderRadius.circular(11),
                                        ),
                                        child: Text(
                                          '12:07',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.black,
                                            decoration: TextDecoration.none,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(
                                      height: 7), // Increased by 15% from 6

                                  // Calories
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/images/energy.png',
                                        width: 18.83,
                                        height: 18.83,
                                      ),
                                      SizedBox(width: 7.7),
                                      Text(
                                        '500 calories',
                                        style: TextStyle(
                                          fontSize: 15.4,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(
                                      height: 7), // Increased by 15% from 6

                                  // Macros
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/images/steak.png',
                                        width: 14, // Increased by 6% from 13.2
                                        height: 14, // Increased by 6% from 13.2
                                      ),
                                      SizedBox(width: 7.7),
                                      Text('15g',
                                          style: TextStyle(
                                              fontSize:
                                                  14, // Increased by 6% from 13.2
                                              fontWeight: FontWeight.normal,
                                              color: Colors.black,
                                              decoration: TextDecoration.none)),
                                      SizedBox(width: 24.2),
                                      Image.asset(
                                        'assets/images/avocado.png',
                                        width: 14, // Increased by 6% from 13.2
                                        height: 14, // Increased by 6% from 13.2
                                      ),
                                      SizedBox(width: 7.7),
                                      Text('10g',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.black,
                                              decoration: TextDecoration.none)),
                                      SizedBox(width: 24.2),
                                      Image.asset(
                                        'assets/images/carbicon.png',
                                        width: 14, // Increased by 6% from 13.2
                                        height: 14, // Increased by 6% from 13.2
                                      ),
                                      SizedBox(width: 7.7),
                                      Text('101g',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.black,
                                              decoration: TextDecoration.none)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Cake with Berries item
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 29, vertical: 8),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FoodCardOpen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Food image placeholder
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              width:
                                  92, // Changed from 104 to 92 to make a perfect square
                              height: 92,
                              color: Color(0xFFDADADA),
                              child: Center(
                                child: Image.asset(
                                  'assets/images/meal1.png',
                                  width: 28,
                                  height: 28,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(width: 12),

                          // Food details
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical:
                                      8), // Reduced from 12 to make card smaller
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Cake with Berries',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 6.6, vertical: 2.2),
                                        decoration: BoxDecoration(
                                          color: Color(0xFFF2F2F2),
                                          borderRadius:
                                              BorderRadius.circular(11),
                                        ),
                                        child: Text(
                                          '09:15',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.black,
                                            decoration: TextDecoration.none,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(
                                      height: 7), // Increased by 15% from 6

                                  // Calories
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/images/energy.png',
                                        width: 18.83,
                                        height: 18.83,
                                      ),
                                      SizedBox(width: 7.7),
                                      Text(
                                        '370 calories',
                                        style: TextStyle(
                                          fontSize: 15.4,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(
                                      height: 7), // Increased by 15% from 6

                                  // Macros
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/images/steak.png',
                                        width: 14, // Increased by 6% from 13.2
                                        height: 14, // Increased by 6% from 13.2
                                      ),
                                      SizedBox(width: 7.7),
                                      Text('15g',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.black,
                                              decoration: TextDecoration.none)),
                                      SizedBox(width: 24.2),
                                      Image.asset(
                                        'assets/images/avocado.png',
                                        width: 14, // Increased by 6% from 13.2
                                        height: 14, // Increased by 6% from 13.2
                                      ),
                                      SizedBox(width: 7.7),
                                      Text('10g',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.black,
                                              decoration: TextDecoration.none)),
                                      SizedBox(width: 24.2),
                                      Image.asset(
                                        'assets/images/carbicon.png',
                                        width: 14, // Increased by 6% from 13.2
                                        height: 14, // Increased by 6% from 13.2
                                      ),
                                      SizedBox(width: 7.7),
                                      Text('101g',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.black,
                                              decoration: TextDecoration.none)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Add padding at the bottom to ensure content doesn't get cut off by the nav bar
                SizedBox(height: 90),
              ],
            ),
          ),
        ),

        // Fixed bottom navigation bar
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 90, // Increased from 60px to 90px
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Transform.translate(
                offset: Offset(0, -5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavItem('Home', 'assets/images/home.png',
                        _selectedIndex == 0, 0),
                    _buildNavItem('Social', 'assets/images/socialicon.png',
                        _selectedIndex == 1, 1),
                    _buildNavItem('Nutrition', 'assets/images/nutrition.png',
                        _selectedIndex == 2, 2),
                    _buildNavItem('Workout', 'assets/images/dumbbell.png',
                        _selectedIndex == 3, 3),
                    _buildNavItem('Profile', 'assets/images/profile.png',
                        _selectedIndex == 4, 4),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem(
      String label, String iconPath, bool isSelected, int index) {
    return GestureDetector(
      onTap: () {
        if (label == 'Workout') {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  ChooseWorkout(),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
        }
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            iconPath,
            width: 27.6,
            height: 27.6,
            color: isSelected ? Colors.black : Colors.grey,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.grey,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalorieCard() {
    // Don't recalculate here - use the value calculated in _loadUserData
    double caloriesToShow = targetCalories.toDouble();

    // Calculate TDEE for maintenance display
    double bmr;
    if (userGender == "Female") {
      bmr = (10 * userWeightKg) + (6.25 * userHeightCm) - (5 * userAge) - 161;
    } else if (userGender == "Male") {
      bmr = (10 * userWeightKg) + (6.25 * userHeightCm) - (5 * userAge) + 5;
    } else {
      // Default to female formula for "Other"
      bmr = (10 * userWeightKg) + (6.25 * userHeightCm) - (5 * userAge) - 161;
    }
    double activityMultiplier = 1.2; // Assuming sedentary as default
    double maintenanceCalories = bmr * activityMultiplier;

    // When goal is maintain, ensure deficit shows same value as remaining calories
    if (userGoal == 'maintain') {
      maintenanceCalories = caloriesToShow;
    }

    // Define macro distribution based on gym goal
    Map<String, Map<String, double>> macroTargets = {
      "Build Muscle": {
        "proteinPercent": 0.32,
        "carbPercent": 0.45,
        "fatPercent": 0.23,
      },
      "Gain Strength": {
        "proteinPercent": 0.28,
        "carbPercent": 0.42,
        "fatPercent": 0.30,
      },
      "Boost Endurance": {
        "proteinPercent": 0.18,
        "carbPercent": 0.60,
        "fatPercent": 0.22,
      },
      // Default balanced macros when no gym goal is selected
      "null": {
        "proteinPercent": 0.25,
        "carbPercent": 0.50,
        "fatPercent": 0.25,
      }
    };

    // Get the macro distribution for the selected gym goal (default to balanced macros if null or not found)
    debugPrint('Using gym goal for macros: "$userGymGoal"');
    Map<String, double> selectedMacros =
        macroTargets["null"]!; // Default to balanced macros

    // Only try to use userGymGoal if it's a valid key in the map - EXACTLY like in calculation_screen.dart
    String goalKey = userGymGoal ?? "null";
    if (macroTargets.containsKey(goalKey)) {
      selectedMacros = macroTargets[goalKey]!;
      print('Using macro distribution for: "$goalKey"');
    } else {
      print(
          'No matching macro distribution for: "$goalKey", using balanced default');
    }

    // Calculate macronutrient targets based on calorie goal and gym goal
    double proteinPercent = selectedMacros["proteinPercent"]!;
    double carbPercent = selectedMacros["carbPercent"]!;
    double fatPercent = selectedMacros["fatPercent"]!;

    // Log the selected macro distribution exactly like calculation_screen.dart
    print('Using macro distribution for gym goal: "$userGymGoal"');
    print('- Protein: ${(proteinPercent * 100).toStringAsFixed(1)}%');
    print('- Carbs: ${(carbPercent * 100).toStringAsFixed(1)}%');
    print('- Fat: ${(fatPercent * 100).toStringAsFixed(1)}%');

    // Calculate macro targets in grams
    int proteinTarget = ((caloriesToShow * proteinPercent) / 4).round();
    int fatTarget = ((caloriesToShow * fatPercent) / 9).round();
    int carbTarget = ((caloriesToShow * carbPercent) / 4).round();

    // Log the calculations with the exact same format as calculation_screen.dart
    print('Calculated macro targets for $caloriesToShow calories:');
    print(
        '- Protein: ${proteinTarget}g (${(caloriesToShow * proteinPercent).round()} kcal)');
    print(
        '- Fat: ${fatTarget}g (${(caloriesToShow * fatPercent).round()} kcal)');
    print(
        '- Carbs: ${carbTarget}g (${(caloriesToShow * carbPercent).round()} kcal)');
    print(
        '- Total: ${((caloriesToShow * proteinPercent) + (caloriesToShow * fatPercent) + (caloriesToShow * carbPercent)).round()} kcal');

    // Set current intake to 0 until user logs food
    int currentProtein = 0;
    int currentFat = 0;
    int currentCarb = 0;

    // If we're still loading or have 0 calories, show a loading indicator
    if (isLoading || targetCalories == 0) {
      print('Loading calorie data or no calories calculated yet');
      // We could return a loading indicator here if needed
    }

    return Container(
      height: 220,
      padding: EdgeInsets.fromLTRB(20, 15, 20, 15), // Reduced vertical padding
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Add this to prevent expansion
        children: [
          // Calorie stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Deficit (now showing maintenance calories)
              Column(
                children: [
                  Text(
                    '-${maintenanceCalories.round()}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  Text(
                    'Deficit',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),

              // Circular progress
              Container(
                width: 130,
                height: 130,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Circle image instead of custom painted progress
                    Transform.translate(
                      offset:
                          Offset(0, -3.9), // Move up by 3% (130 * 0.03 = 3.9)
                      child: Image.asset(
                        'assets/images/circle.png',
                        width: 130,
                        height: 130,
                        fit: BoxFit.contain,
                      ),
                    ),

                    // Remaining calories text - UPDATED to show exact calculation
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          caloriesToShow.toStringAsFixed(
                              0), // Display exact value without decimal points
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        Text(
                          'Remaining',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Burned
              Column(
                children: [
                  Text(
                    '0', // NOTE: Burned calculation is separate
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  Text(
                    'Burned',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 5), // Reduced from 10

          // Macronutrient progress bars
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Protein
              Column(
                children: [
                  Text(
                    'Protein',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  SizedBox(height: 4),
                  Container(
                    width: 80,
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Color(0xFFEEEEEE),
                    ),
                    child: FractionallySizedBox(
                      widthFactor:
                          currentProtein / proteinTarget, // Dynamic progress
                      alignment: Alignment.centerLeft,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Color(0xFFD7C1FF), // Light purple
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '$currentProtein / $proteinTarget g',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),

              // Fat
              Column(
                children: [
                  Text(
                    'Fat',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  SizedBox(height: 4),
                  Container(
                    width: 80,
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Color(0xFFEEEEEE),
                    ),
                    child: FractionallySizedBox(
                      widthFactor: currentFat / fatTarget, // Dynamic progress
                      alignment: Alignment.centerLeft,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Color(0xFFFFD8B1), // Light orange
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '$currentFat / $fatTarget g',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),

              // Carbs
              Column(
                children: [
                  Text(
                    'Carbs',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  SizedBox(height: 4),
                  Container(
                    width: 80,
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Color(0xFFEEEEEE),
                    ),
                    child: FractionallySizedBox(
                      widthFactor: currentCarb / carbTarget, // Dynamic progress
                      alignment: Alignment.centerLeft,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Color(0xFFB1EFD8), // Light green
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '$currentCarb / $carbTarget g',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CircleProgressPainter extends CustomPainter {
  final double progress;
  final Color progressColor;
  final Color backgroundColor;
  final double strokeWidth;

  CircleProgressPainter({
    required this.progress,
    required this.progressColor,
    required this.backgroundColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Draw background circle if needed
    if (backgroundColor != Colors.transparent) {
      final backgroundPaint = Paint()
        ..color = backgroundColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;

      canvas.drawCircle(center, radius, backgroundPaint);
    }

    // Draw progress arc
    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, // Start from top
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CircleProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
