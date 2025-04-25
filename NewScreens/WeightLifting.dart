import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:fitness_app/NewScreens/StartWorkout.dart';

class WeightLifting extends StatefulWidget {
  const WeightLifting({Key? key}) : super(key: key);

  @override
  State<WeightLifting> createState() => _WeightLiftingState();
}

class _WeightLiftingState extends State<WeightLifting> {
  bool _isRoutineExpanded = false;

  @override
  void initState() {
    super.initState();
    debugPrint('DEBUG: WeightLifting screen initialized');
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('DEBUG: WeightLifting screen building');
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Weight Lifting',
          style: TextStyle(
            color: Colors.black,
            fontSize: 26,
            fontWeight: FontWeight.bold,
            fontFamily: 'SF Pro Display',
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Quick Start',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'SF Pro Display',
                  ),
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () {
                    debugPrint('DEBUG: Start Workout button tapped');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StartWorkoutScreen(),
                      ),
                    );
                    debugPrint('DEBUG: Navigation completed');
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.add, color: Colors.black, size: 24),
                        SizedBox(width: 12),
                        Text(
                          'Start Workout',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Routines Section
                Text(
                  'Routines',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'SF Pro Display',
                  ),
                ),
                SizedBox(height: 20),
                // Routines Grid
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 93,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              offset: Offset(0, 3),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_circle_outline, size: 30),
                            SizedBox(height: 8),
                            Text(
                              'Add Routine',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                fontFamily: 'SF Pro Display',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        height: 93,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              offset: Offset(0, 3),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.fitness_center, size: 30),
                            SizedBox(height: 8),
                            Text(
                              'Routines For You',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                fontFamily: 'SF Pro Display',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // My Routines Section
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Color(0xFFEEEEEE),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'My Routines (1)',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontFamily: 'SF Pro Display',
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(Icons.keyboard_arrow_down, size: 16),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                // Routine Card
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        offset: Offset(0, 3),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Push',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily: 'SF Pro Display',
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Bench Press (Barbell), Incline Chest Press (Machine), Triceps Pushdown...',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black.withOpacity(0.5),
                          fontFamily: 'SF Pro Display',
                        ),
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Start routine logic
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Start Routine',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                              fontFamily: 'SF Pro Display',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
