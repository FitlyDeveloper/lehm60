import 'package:flutter/material.dart';

class SnapMealScreen extends StatefulWidget {
  const SnapMealScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SnapMealScreenState();
}

class _SnapMealScreenState extends State<SnapMealScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: 394,
        height: 854,
        child: Stack(
          children: [
            // Back button
            Positioned(
              left: 34,
              width: 36,
              top: 69,
              height: 36,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Image.asset('assets/images/arrow.png',
                      width: 36, height: 36),
                ),
              ),
            ),
            // Main image
            Positioned(
              left: 34,
              width: 326,
              top: 160,
              child: Image.asset('assets/images/Foodstart.png', width: 326),
            ),
            // Scan Food button
            Positioned(
              left: 34,
              width: 99,
              top: 646,
              height: 69,
              child: Container(
                width: 99,
                height: 69,
                decoration: BoxDecoration(
                  color: const Color(0xffffffff),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 0, top: 7, right: 0, bottom: 7),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/foodscan.png',
                          width: 33, height: 33, fit: BoxFit.cover),
                      const SizedBox(height: 5),
                      const SizedBox(
                        width: 98,
                        child: Text(
                          'Scan Food',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              fontSize: 13,
                              color: Color(0xff000000),
                              fontFamily: 'SFProDisplay-Regular',
                              fontWeight: FontWeight.normal),
                          maxLines: 9999,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Scan Code button
            Positioned(
              left: 148,
              width: 99,
              top: 646,
              height: 69,
              child: Container(
                width: 99,
                height: 69,
                decoration: BoxDecoration(
                  color: const Color(0xb2ffffff),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 0, top: 7, right: 0, bottom: 7),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/qrcodescan.png',
                          width: 33, height: 33, fit: BoxFit.cover),
                      const SizedBox(height: 5),
                      const SizedBox(
                        width: 98,
                        child: Text(
                          'Scan Code',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              fontSize: 13,
                              color: Color(0xff000000),
                              fontFamily: 'SFProDisplay-Regular',
                              fontWeight: FontWeight.normal),
                          maxLines: 9999,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Add Photo button
            Positioned(
              left: 261,
              width: 99,
              top: 646,
              height: 69,
              child: Container(
                width: 99,
                height: 69,
                decoration: BoxDecoration(
                  color: const Color(0xb2ffffff),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 0, top: 6, right: 0, bottom: 6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/camera.png',
                          width: 32, height: 32, fit: BoxFit.cover),
                      const SizedBox(height: 7),
                      const SizedBox(
                        width: 98,
                        child: Text(
                          'Add Photo',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              fontSize: 13,
                              color: Color(0xff000000),
                              fontFamily: 'SFProDisplay-Regular',
                              fontWeight: FontWeight.normal),
                          maxLines: 9999,
                          overflow: TextOverflow.ellipsis,
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
    );
  }
}
