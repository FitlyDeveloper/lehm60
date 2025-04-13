import 'package:flutter/material.dart';

class LogDescribeExercise extends StatefulWidget {
  const LogDescribeExercise({Key? key}) : super(key: key);

  @override
  State<LogDescribeExercise> createState() => _LogDescribeExerciseState();
}

class _LogDescribeExerciseState extends State<LogDescribeExercise> {
  final TextEditingController _exerciseController = TextEditingController();
  final TextEditingController _distanceController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  
  String? selectedDistance;
  String? selectedTime;

  final List<String> distances = ['1 km', '5 km', '10 km', '15 km'];
  final List<String> times = ['15 min', '30 min', '60 min', '90 min'];

  @override
  void dispose() {
    _exerciseController.dispose();
    _distanceController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background4.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              Column(
                children: [
                  // AppBar
                  PreferredSize(
                    preferredSize: Size.fromHeight(kToolbarHeight),
                    child: AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      automaticallyImplyLeading: false,
                      flexibleSpace: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16)
                                .copyWith(top: 16, bottom: 8.5),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.arrow_back, color: Colors.black),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      'Describe Exercise',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'SF Pro Display',
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 48),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Divider line
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 29),
                    height: 0.5,
                    color: Color(0xFFBDBDBD),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),
                          // Exercise Section
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/add.png',
                                width: 24,
                                height: 24,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Exercise',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'SF Pro Display',
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          // Exercise TextField
                          Container(
                            height: 56,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.grey[300]!),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: _exerciseController,
                              textAlign: TextAlign.left,
                              textAlignVertical: TextAlignVertical.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Swimming, football, cycling etc',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                isCollapsed: true,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          
                          // Distance Section with Intensity
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/images/Distance.png',
                                    width: 24,
                                    height: 24,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Distance',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'SF Pro Display',
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/images/intensity.png',
                                    width: 24,
                                    height: 24,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Intensity',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'SF Pro Display',
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          // Distance Chips
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: distances.map((distance) {
                                return Padding(
                                  padding: EdgeInsets.only(right: 15),
                                  child: ChoiceChip(
                                    label: Text(
                                      distance,
                                      style: TextStyle(
                                        color: selectedDistance == distance ? Colors.white : Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                      ),
                                    ),
                                    selected: selectedDistance == distance,
                                    onSelected: (bool selected) {
                                      setState(() {
                                        selectedDistance = selected ? distance : null;
                                        if (selected) {
                                          _distanceController.text = distance.replaceAll(' km', '');
                                        }
                                      });
                                    },
                                    backgroundColor: Colors.white,
                                    selectedColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: BorderSide(
                                        color: selectedDistance == distance ? Colors.black : Colors.grey[300]!,
                                      ),
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    visualDensity: VisualDensity.compact,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          SizedBox(height: 15),
                          // Distance TextField
                          Container(
                            height: 56,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.grey[300]!),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: _distanceController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.left,
                              textAlignVertical: TextAlignVertical.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Kilometers',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                isCollapsed: true,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          
                          // Time Section
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/timeicon.png',
                                width: 24,
                                height: 24,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Time',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'SF Pro Display',
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          // Time Chips
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: times.map((time) {
                                  return Padding(
                                    padding: EdgeInsets.only(right: 8),
                                    child: ChoiceChip(
                                      label: Text(
                                        time,
                                        style: TextStyle(
                                          color: selectedTime == time ? Colors.white : Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                        ),
                                      ),
                                      selected: selectedTime == time,
                                      onSelected: (bool selected) {
                                        setState(() {
                                          selectedTime = selected ? time : null;
                                          if (selected) {
                                            _timeController.text = time.replaceAll(' min', '');
                                          }
                                        });
                                      },
                                      backgroundColor: Colors.white,
                                      selectedColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        side: BorderSide(
                                          color: selectedTime == time ? Colors.black : Colors.grey[300]!,
                                        ),
                                      ),
                                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      visualDensity: VisualDensity.compact,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          // Time TextField
                          Container(
                            height: 56,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.grey[300]!),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: _timeController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.left,
                              textAlignVertical: TextAlignVertical.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Minutes',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                isCollapsed: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // White box at bottom
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: MediaQuery.of(context).size.height * 0.148887,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.zero,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, -5),
                      ),
                    ],
                  ),
                ),
              ),

              // Add button
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
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Add',
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
        ),
      ),
    );
  }
} 