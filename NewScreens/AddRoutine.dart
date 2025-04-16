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
        width: 393,
        height: 852,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              width: 393,
              top: 0,
              height: 852,
              child: Image.asset('images/image1_43463.png', width: 393, height: 852, fit: BoxFit.cover,),
            ),
            Positioned(
              left: 113,
              top: 58,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Add Routine',
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
                child: Image.asset('images/image2_43465.png', width: 338,),
              ),
            ),
            Positioned(
              left: 30.622,
              width: 33.684,
              top: 68.5,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Image.asset('images/image3_43467.png', width: 33.684,),
              ),
            ),
            Positioned(
              left: 28,
              width: 338,
              top: 129,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset('images/image4_67565.png', width: 338,),
              ),
            ),
            Positioned(
              left: 47,
              top: 152,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Routine Title',
                      textAlign: TextAlign.left,
                      style: TextStyle(decoration: TextDecoration.none, fontSize: 18, color: const Color(0x6d000000), fontFamily: 'SFProDisplay-Regular', fontWeight: FontWeight.normal),
                      maxLines: 9999,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 74,
              top: 316,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Add an exercise to get started',
                      textAlign: TextAlign.left,
                      style: TextStyle(decoration: TextDecoration.none, fontSize: 18, color: const Color(0x87000000), fontFamily: 'SFProDisplay-Regular', fontWeight: FontWeight.normal),
                      maxLines: 9999,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 124,
              top: 281,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Get Started',
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
              left: 161,
              top: 214,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset('images/image5_67567.png',),
              ),
            ),
            Positioned(
              left: 163,
              width: 104,
              top: 378,
              height: 20,
              child: Text(
                'Add Exercise',
                textAlign: TextAlign.left,
                style: TextStyle(decoration: TextDecoration.none, fontSize: 17, color: const Color(0xffffffff), fontFamily: 'SFProDisplay-Regular', fontWeight: FontWeight.normal),
                maxLines: 9999,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Positioned(
              left: 131.671,
              width: 19.527,
              top: 378.736,
              height: 19.527,
              child: Stack(
                children: [
                  Positioned(
                    left: -9.427,
                    width: 64.641,
                    top: -22.221,
                    height: 60.938,
                    child: Container(
                      width: 64.641,
                      height: 60.938,
                      decoration: BoxDecoration(
                        color: const Color(0xffffffff),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 38,
              width: 318,
              top: 368,
              height: 40,
              child: Container(
                width: 318,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xff000000),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [BoxShadow(color: const Color(0x14000000), offset: Offset(0, 3), blurRadius: 8),],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 91, top: 10, right: 91, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 19.527,
                        height: 19.527,
                        child: Stack(
                          children: [
                            Positioned(
                              left: -9.427,
                              width: 64.641,
                              top: -22.221,
                              height: 60.938,
                              child: Container(
                                width: 64.641,
                                height: 60.938,
                                decoration: BoxDecoration(
                                  color: const Color(0xffffffff),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 104,
                        height: 20,
                        child: Text(
                          'Add Exercise',
                          textAlign: TextAlign.left,
                          style: TextStyle(decoration: TextDecoration.none, fontSize: 17, color: const Color(0xffffffff), fontFamily: 'SFProDisplay-Regular', fontWeight: FontWeight.normal),
                          maxLines: 9999,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 201,
              width: 155,
              top: 424,
              height: 40,
              child: Container(
                width: 155,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xffffffff),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [BoxShadow(color: const Color(0x14000000), offset: Offset(0, 3), blurRadius: 8),],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 29, top: 8, right: 29, bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('images/image_434135.png', width: 23, height: 24, fit: BoxFit.cover,),
                      const SizedBox(width: 21),
                      SizedBox(
                        width: 40,
                        height: 20,
                        child: Text(
                          'Save',
                          textAlign: TextAlign.left,
                          style: TextStyle(decoration: TextDecoration.none, fontSize: 17, color: const Color(0xff000000), fontFamily: 'SFProDisplay-Regular', fontWeight: FontWeight.normal),
                          maxLines: 9999,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 38,
              width: 154,
              top: 424,
              height: 40,
              child: Container(
                width: 154,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xffffffff),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [BoxShadow(color: const Color(0x14000000), offset: Offset(0, 3), blurRadius: 8),],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, top: 4, right: 20, bottom: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 27.749,
                        height: 27.749,
                        child: Stack(
                          children: [
                            Positioned(
                              left: -8.222,
                              width: 41.11,
                              top: -7.194,
                              height: 39.054,
                              child: Container(
                                width: 41.11,
                                height: 39.054,
                                decoration: BoxDecoration(
                                  color: const Color(0xffe97372),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 1),
                      SizedBox(
                        width: 66,
                        height: 20,
                        child: Text(
                          'Discard ',
                          textAlign: TextAlign.center,
                          style: TextStyle(decoration: TextDecoration.none, fontSize: 17, color: const Color(0xffe97372), fontFamily: 'SFProDisplay-Regular', fontWeight: FontWeight.normal),
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
