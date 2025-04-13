import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';

class CodiaPage extends StatefulWidget {
  CodiaPage({super.key});

  @override
  State<StatefulWidget> createState() => _CodiaPage();
}

class _CodiaPage extends State<CodiaPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SizedBox(
        height: 852,
        child: Stack(
          children: [
            Positioned(
              left: -16,
              right: -16,
              top: 0,
              height: 852,
              child: Image.asset('images/image1_434205.png', height: 852, fit: BoxFit.cover,),
            ),
            Positioned(
              left: 206,
              width: 150,
              top: 296,
              height: 93,
              child: Container(
                width: 150,
                height: 93,
                decoration: BoxDecoration(
                  color: const Color(0xffffffff),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [BoxShadow(color: const Color(0x14000000), offset: Offset(0, 3), blurRadius: 8),],
                ),
              ),
            ),
            Positioned(
              left: 28,
              top: 119,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Quick Start',
                      textAlign: TextAlign.left,
                      style: TextStyle(decoration: TextDecoration.none, fontSize: 24, color: const Color(0xff000000), fontFamily: 'SFProDisplay-Bold', fontWeight: FontWeight.normal),
                      maxLines: 9999,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 28,
              top: 237,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Routines',
                      textAlign: TextAlign.left,
                      style: TextStyle(decoration: TextDecoration.none, fontSize: 24, color: const Color(0xff000000), fontFamily: 'SFProDisplay-Bold', fontWeight: FontWeight.normal),
                      maxLines: 9999,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 28,
              width: 338,
              top: 168,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset('images/image2_60392.png', width: 338,),
              ),
            ),
            Positioned(
              left: 38,
              width: 318,
              top: 456,
              height: 161,
              child: Container(
                width: 318,
                height: 161,
                decoration: BoxDecoration(
                  color: const Color(0xffffffff),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [BoxShadow(color: const Color(0x14000000), offset: Offset(0, 3), blurRadius: 8),],
                ),
              ),
            ),
            Positioned(
              left: 60,
              width: 21,
              top: 191,
              height: 21,
              child: Stack(
                children: [
                  Positioned(
                    left: -1.355,
                    width: 24.387,
                    top: -0.339,
                    height: 23.032,
                    child: Container(
                      width: 24.387,
                      height: 23.032,
                      decoration: BoxDecoration(
                        color: const Color(0xff000000),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 105,
              top: 183,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Start Workout',
                      textAlign: TextAlign.left,
                      style: TextStyle(decoration: TextDecoration.none, fontSize: 16, color: const Color(0xff000000), fontFamily: 'SFProDisplay-Medium', fontWeight: FontWeight.normal),
                      maxLines: 9999,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 49,
              top: 458,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Push',
                      textAlign: TextAlign.left,
                      style: TextStyle(decoration: TextDecoration.none, fontSize: 18, color: const Color(0xff000000), fontFamily: 'SFProDisplay-Bold', fontWeight: FontWeight.normal),
                      maxLines: 9999,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 49,
              top: 486,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Bench Press (Barbell), Incline Chest\nPress (Machine), Triceps Pushdown...',
                      textAlign: TextAlign.left,
                      style: TextStyle(decoration: TextDecoration.none, fontSize: 16, color: const Color(0x7f000000), fontFamily: 'SFProDisplay-Medium', fontWeight: FontWeight.normal),
                      maxLines: 9999,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 38,
              width: 150,
              top: 296,
              height: 93,
              child: Container(
                width: 150,
                height: 93,
                decoration: BoxDecoration(
                  color: const Color(0xffffffff),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [BoxShadow(color: const Color(0x14000000), offset: Offset(0, 3), blurRadius: 8),],
                ),
              ),
            ),
            Positioned(
              left: 88,
              top: 303,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset('images/image3_60395.png',),
              ),
            ),
            Positioned(
              left: 71,
              top: 358,
              child: Text(
                'Add Routine',
                textAlign: TextAlign.left,
                style: TextStyle(decoration: TextDecoration.none, fontSize: 16, color: const Color(0xff000000), fontFamily: 'SFProDisplay-Medium', fontWeight: FontWeight.normal),
                maxLines: 9999,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Positioned(
              left: 213,
              top: 348,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Routines For You',
                      textAlign: TextAlign.left,
                      style: TextStyle(decoration: TextDecoration.none, fontSize: 16, color: const Color(0xff000000), fontFamily: 'SFProDisplay-Medium', fontWeight: FontWeight.normal),
                      maxLines: 9999,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 254,
              top: 298,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset('images/image4_60396.png',),
              ),
            ),
            Positioned(
              left: 100,
              top: 58,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Weight Lifting',
                      textAlign: TextAlign.center,
                      style: TextStyle(decoration: TextDecoration.none, fontSize: 26, color: const Color(0xff000000), fontFamily: 'SFProDisplay-Bold', fontWeight: FontWeight.normal),
                      maxLines: 9999,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 28,
              width: 338,
              top: 99,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset('images/image5_60390.png', width: 338,),
              ),
            ),
            Positioned(
              left: 31.62,
              width: 33.684,
              top: 68.5,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Image.asset('images/image6_434221.png', width: 33.684,),
              ),
            ),
            Positioned(
              left: 38,
              width: 118,
              top: 409,
              height: 27,
              child: Container(
                width: 118,
                height: 27,
                decoration: BoxDecoration(
                  color: const Color(0xcceeeeee),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 7, top: 6, right: 7, bottom: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 85,
                        height: 15,
                        child: Text(
                          'My Routines ( 1 )',
                          textAlign: TextAlign.left,
                          style: TextStyle(decoration: TextDecoration.none, fontSize: 12, color: const Color(0xff000000), fontFamily: 'SFProDisplay-Regular', fontWeight: FontWeight.normal),
                          maxLines: 9999,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Image.asset('images/image_434225.png', width: 11, height: 11, fit: BoxFit.cover,),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 52,
              width: 291,
              top: 549,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset('images/image7_603102.png', width: 291,),
              ),
            ),
            Positioned(
              left: 136,
              top: 559,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Start Routine',
                      textAlign: TextAlign.left,
                      style: TextStyle(decoration: TextDecoration.none, fontSize: 17, color: const Color(0xffffffff), fontFamily: 'SFProDisplay-Regular', fontWeight: FontWeight.normal),
                      maxLines: 9999,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
