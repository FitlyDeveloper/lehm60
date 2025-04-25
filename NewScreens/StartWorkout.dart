import 'package:flutter/material.dart';

class StartWorkoutScreen extends StatelessWidget {
  const StartWorkoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('StartWorkoutScreen build called');
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            debugPrint('Back button pressed');
            Navigator.pop(context);
          },
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
      body: Column(
        children: [
          // Stats Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatItem('Duration', '0'),
                    _buildStatItem('Volume', '0'),
                    _buildStatItem('PRs', '0'),
                  ],
                ),
                const SizedBox(height: 20),
                Divider(height: 1, color: Colors.grey.withOpacity(0.2)),
              ],
            ),
          ),
          
          // Empty State
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.fitness_center,
                    size: 48,
                    color: Colors.black,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Get Started',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'SF Pro Display',
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Add an exercise to get started',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black53,
                      fontFamily: 'SF Pro Display',
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Bottom Buttons
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      // Add exercise logic
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Add Exercise',
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                            fontFamily: 'SF Pro Display',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.delete_outline, color: Color(0xFFE97372)),
                            SizedBox(width: 8),
                            Text(
                              'Discard',
                              style: TextStyle(
                                fontSize: 17,
                                color: Color(0xFFE97372),
                                fontFamily: 'SF Pro Display',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          // Finish workout logic
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check, color: Colors.black),
                            SizedBox(width: 8),
                            Text(
                              'Finish',
                              style: TextStyle(
                                fontSize: 17,
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontFamily: 'SF Pro Display',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black.withOpacity(0.53),
            fontFamily: 'SF Pro Display',
          ),
        ),
      ],
    );
  }
}
