import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:shared_preferences/shared_preferences.dart';
import 'Memories.dart';
import '../../NewScreens/ChooseWorkout.dart';
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

  // User data variables - will be populated from saved answers
  String userGender = 'Female'; // Default values, will be overridden
  double userWeightKg = 70.0;
  double userHeightCm = 165.0;
  int userAge = 30;
  String userGoal = 'lose';
  double goalSpeedKgPerWeek = 0.5;
  double dailyCalorieAdjustment = 0.0; // Add this line to track the adjustment

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Load the user's actual data from storage
  }

  // For testing calculations with manual data
  void _setTestUserData(String testCase) {
    if (testCase == 'male_lose') {
      setState(() {
        userGender = 'Male';
        userWeightKg = 80.0;
        userHeightCm = 180.0;
        userAge = 35;
        userGoal = 'lose';
        goalSpeedKgPerWeek = 0.7;
      });
    } else if (testCase == 'female_gain') {
      setState(() {
        userGender = 'Female';
        userWeightKg = 60.0;
        userHeightCm = 165.0;
        userAge = 28;
        userGoal = 'gain';
        goalSpeedKgPerWeek = 0.3;
      });
    } else if (testCase == 'custom') {
      // Try to match what might be causing the fixed value of 1644/1684
      setState(() {
        userGender =
            'Female'; // Try Female since BMR equation has -161 constant
        userWeightKg = 65.0; // Adjusted to potentially result in ~1684 calories
        userHeightCm = 170.0;
        userAge = 25;
        userGoal = 'lose';
        goalSpeedKgPerWeek = 0.5; // 0.5 kg per week is standard
      });
    }

    print('Set test data to $testCase:');
    print('Gender: $userGender');
    print('Weight: $userWeightKg kg');
    print('Height: $userHeightCm cm');
    print('Age: $userAge');
    print('Goal: $userGoal');
    print('Goal Speed: $goalSpeedKgPerWeek kg/week');

    double calories = _calculateTargetCalories();
    print('Calculated calories: $calories');
  }

  // Load user data from SharedPreferences (or your storage mechanism)
  Future<void> _loadUserData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Log all keys for debugging
      print('All SharedPreferences keys: ${prefs.getKeys().toList()}');

      // Check if we have any user data at all
      bool hasUserData = prefs.containsKey('user_gender') ||
          prefs.containsKey('user_weight_kg') ||
          prefs.containsKey('user_goal');

      if (!hasUserData) {
        print(
            'WARNING: No user data found in SharedPreferences. Using test data instead.');
        _setTestUserData('custom'); // Use custom test case to check calculation
        return;
      }

      // Load data using the exact keys from the onboarding screens
      setState(() {
        // From gender_screen.dart
        userGender = prefs.getString('user_gender') ?? 'Female';

        // From weight_height_screen.dart
        userWeightKg = prefs.getDouble('user_weight_kg') ?? 70.0;
        userHeightCm = prefs.getDouble('user_height_cm') ?? 165.0;

        // From speed_screen.dart
        userAge = prefs.getInt('user_age') ?? 30;

        // From weight_goal_screen.dart
        userGoal = prefs.getString('user_goal') ?? 'lose';

        // From speed_screen.dart
        goalSpeedKgPerWeek = prefs.getDouble('goal_speed_kg_per_week') ?? 0.5;
      });

      // Print loaded data for debugging
      print('Loaded User Data:');
      print('Gender: $userGender');
      print('Weight: $userWeightKg kg');
      print('Height: $userHeightCm cm');
      print('Age: $userAge');
      print('Goal: $userGoal');
      print('Goal Speed: $goalSpeedKgPerWeek kg/week');

      // Calculate and print calories for debugging
      double calories = _calculateTargetCalories();
      print('Calculated calories from loaded data: $calories');

      // Force rebuild to update displayed calories with new data
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print('Error loading user data: $e');
      // Fall back to test data on error
      print('Using test data due to error');
      _setTestUserData('custom');
    }
  }

  // Calculate target calories based on user data
  double _calculateTargetCalories() {
    // Print input values
    print('Calculating for:');
    print('Gender: $userGender');
    print('Weight: $userWeightKg kg');
    print('Height: $userHeightCm cm');
    print('Age: $userAge');
    print('Goal: $userGoal');
    print('Goal Speed: $goalSpeedKgPerWeek kg/week');

    // Calculate BMR (Mifflin-St Jeor Formula)
    double bmr;
    if (userGender == 'Male') {
      bmr = (10 * userWeightKg) + (6.25 * userHeightCm) - (5 * userAge) + 5;
    } else {
      // Female or Other
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

    // Calculate Final Target Calories based on Goal
    double targetCalories;
    if (userGoal == 'lose') {
      targetCalories = tdee - dailyCalorieAdjustment;
    } else if (userGoal == 'gain') {
      targetCalories = tdee + dailyCalorieAdjustment;
    } else {
      // maintain
      targetCalories = tdee;
    }

    // Print calculation steps for debugging
    print('Calculation Steps:');
    print('BMR: $bmr');
    print('Activity Multiplier: $activityMultiplier');
    print('TDEE (BMR * Activity): $tdee');
    print('Weekly Calorie Adjustment: $weeklyCalorieAdjustment');
    print('Daily Calorie Adjustment: $dailyCalorieAdjustment');
    print('Target Calories: $targetCalories');

    // Set a minimum healthy calorie limit
    double minimumCalories = userGender == 'Male' ? 1500 : 1200;
    if (targetCalories < minimumCalories && userGoal == 'lose') {
      print(
          'Warning: Calculated target below minimum. Setting to $minimumCalories calories');
      targetCalories = minimumCalories;
    }

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
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const FoodCardOpen()),
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
                                          borderRadius: BorderRadius.circular(11),
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

                                  SizedBox(height: 7), // Increased by 15% from 6

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

                                  SizedBox(height: 7), // Increased by 15% from 6

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
    // Calculate exact target calories
    double targetCalories = _calculateTargetCalories();

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
              // Deficit
              Column(
                children: [
                  Text(
                    '-${userGoal == 'lose' ? dailyCalorieAdjustment.round() : 0}',
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
                          targetCalories.toStringAsFixed(
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
                      widthFactor: 0.5, // 50% progress
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
                    '60 / 120 g',
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
                      widthFactor: 0.5, // 50% progress
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
                    '32 / 64 g',
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
                      widthFactor: 0.5, // 50% progress
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
                    '125 / 250 g',
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
