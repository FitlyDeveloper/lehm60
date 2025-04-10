import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

class MemoriesScreen extends StatefulWidget {
  const MemoriesScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MemoriesScreenState();
}

class _MemoriesScreenState extends State<MemoriesScreen> {
  late DateTime _currentDate;
  late DateTime _previousMonth;
  late int _currentYear;
  late int _currentMonth;
  late int _previousMonthYear;
  late int _previousMonthNum;
  late int _today;
  late int _daysInCurrentMonth;
  late int _daysInPreviousMonth;

  @override
  void initState() {
    super.initState();
    _currentDate = DateTime.now();
    _currentYear = _currentDate.year;
    _currentMonth = _currentDate.month;
    _today = _currentDate.day;

    // Calculate previous month
    _previousMonth = DateTime(_currentDate.year, _currentDate.month - 1, 1);
    _previousMonthYear = _previousMonth.year;
    _previousMonthNum = _previousMonth.month;

    // Calculate days in each month
    _daysInCurrentMonth = DateTime(_currentYear, _currentMonth + 1, 0).day;
    _daysInPreviousMonth =
        DateTime(_previousMonthYear, _previousMonthNum + 1, 0).day;
  }

  String _getMonthName(int month) {
    return DateFormat('MMMM yyyy').format(DateTime(_currentYear, month, 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background4.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                // Header with back button and title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 29)
                      .copyWith(top: 16, bottom: 8.5),
              child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                      // Back button (styled like signin.dart - simple IconButton)
                      IconButton(
                        icon: const Icon(Icons.arrow_back,
                            color: Colors.black, size: 24),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                      ),

                      // Memories title (sized like 'Today' text but centered position)
                    Text(
                        'Memories',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SF Pro Display',
                          color: Colors.black,
                          decoration: TextDecoration.none,
                        ),
                      ),

                      // Empty space to balance the header (same width as back button)
                      SizedBox(width: 24),
                  ],
                ),
              ),

                // Slim gray divider line
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 29),
                  height: 1,
                  color: Color(0xFFBDBDBD),
                ),

                // Current Month Calendar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 29)
                      .copyWith(top: 20, bottom: 0),
                        child: Container(
                    padding: EdgeInsets.all(14),
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
                children: [
                        // Month header
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            _getMonthName(_currentMonth),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                          ),
                        ),
                      ),

                        // Weekday headers
                  Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                            _buildWeekdayHeader('Mon'),
                            _buildWeekdayHeader('Tue'),
                            _buildWeekdayHeader('Wed'),
                            _buildWeekdayHeader('Thu'),
                            _buildWeekdayHeader('Fri'),
                            _buildWeekdayHeader('Sat'),
                            _buildWeekdayHeader('Sun'),
                          ],
                        ),

                        SizedBox(height: 8),

                        // Calendar days
                        _buildCalendarGrid(_daysInCurrentMonth,
                            _today), // Current month with today highlighted
                      ],
                    ),
                  ),
                ),

                // Previous Month Calendar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 29)
                      .copyWith(top: 15, bottom: 6),
                        child: Container(
                    padding: EdgeInsets.all(14),
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
                children: [
                        // Month header
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            _getMonthName(_previousMonthNum),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                          ),
                        ),
                      ),

                        // Weekday headers
                  Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                            _buildWeekdayHeader('Mon'),
                            _buildWeekdayHeader('Tue'),
                            _buildWeekdayHeader('Wed'),
                            _buildWeekdayHeader('Thu'),
                            _buildWeekdayHeader('Fri'),
                            _buildWeekdayHeader('Sat'),
                            _buildWeekdayHeader('Sun'),
                          ],
                        ),

                        SizedBox(height: 8),

                        // Calendar days
                        _buildCalendarGrid(_daysInPreviousMonth,
                            null), // Previous month, no highlight
                      ],
                    ),
                  ),
                ),

                // Add space at the bottom
                SizedBox(height: 90),
              ],
            ),
                          ),
                        ),
                      ),
    );
  }

  Widget _buildWeekdayHeader(String day) {
    return Text(
      day,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }

  Widget _buildCalendarGrid(int daysInMonth, int? highlightDay) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: daysInMonth,
      itemBuilder: (context, index) {
        final day = index + 1;
        return _buildCalendarDay(day, isHighlighted: day == highlightDay);
      },
    );
  }

  Widget _buildCalendarDay(int day, {bool isHighlighted = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: null,
        shape: BoxShape.rectangle,
      ),
      child: Center(
                          child: Text(
          day.toString(),
          style: TextStyle(
            fontSize: 14,
            fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
