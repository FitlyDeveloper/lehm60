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
              child: Image.asset('images/image1_205513.png', width: 393, height: 852, fit: BoxFit.cover,),
            ),
            Positioned(
              left: 129,
              top: 59,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Running',
                      textAlign: TextAlign.left,
                      style: TextStyle(decoration: TextDecoration.none, fontSize: 26, color: const Color(0xff000000), fontFamily: 'SFProDisplay-Bold', fontWeight: FontWeight.normal),
                      maxLines: 9999,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 59,
              top: 229,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Distance',
                      textAlign: TextAlign.left,
                      style: TextStyle(decoration: TextDecoration.none, fontSize: 20, color: const Color(0xff000000), fontFamily: 'SFProDisplay-Medium', fontWeight: FontWeight.normal),
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
                child: Image.asset('images/image2_205516.png', width: 338,),
              ),
            ),
            Positioned(
              left: 29.622,
              width: 33.684,
              top: 68.5,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Image.asset('images/image3_205518.png', width: 33.684,),
              ),
            ),
            Positioned(
              left: 22,
              width: 351,
              top: 303,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset('images/image4_55772.png', width: 351,),
              ),
            ),
            Positioned(
              left: 42,
              top: 324,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Kilometers',
                      textAlign: TextAlign.left,
                      style: TextStyle(decoration: TextDecoration.none, fontSize: 18, color: const Color(0x66000000), fontFamily: 'SFProDisplay-Regular', fontWeight: FontWeight.normal),
                      maxLines: 9999,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 247,
              width: 38,
              top: 64,
              height: 38,
              child: Image.asset('images/image5_205538.png', width: 38, height: 38, fit: BoxFit.cover,),
            ),
            Positioned(
              left: 25,
              top: 223,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset('images/image6_55766.png',),
              ),
            ),
            Positioned(
              left: 59,
              top: 414,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Time',
                      textAlign: TextAlign.left,
                      style: TextStyle(decoration: TextDecoration.none, fontSize: 20, color: const Color(0xff000000), fontFamily: 'SFProDisplay-Medium', fontWeight: FontWeight.normal),
                      maxLines: 9999,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 25,
              top: 414,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset('images/image7_55773.png',),
              ),
            ),
            Positioned(
              left: 58,
              width: 54,
              top: 273,
              height: 27,
              child: Container(
                width: 54,
                height: 27,
                decoration: BoxDecoration(
                  color: const Color(0xdbffffff),
                  border: Border.all(color: const Color(0xff000000), width: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 14, top: 6, right: 14, bottom: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '1 km',
                        textAlign: TextAlign.left,
                        style: TextStyle(decoration: TextDecoration.none, fontSize: 12, color: const Color(0xff000000), fontFamily: 'SFProDisplay-Regular', fontWeight: FontWeight.normal),
                        maxLines: 9999,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 132,
              width: 54,
              top: 273,
              height: 27,
              child: Container(
                width: 54,
                height: 27,
                decoration: BoxDecoration(
                  color: const Color(0xdbffffff),
                  border: Border.all(color: const Color(0xff000000), width: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 14, top: 6, right: 14, bottom: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '5 km',
                        textAlign: TextAlign.left,
                        style: TextStyle(decoration: TextDecoration.none, fontSize: 12, color: const Color(0xff000000), fontFamily: 'SFProDisplay-Regular', fontWeight: FontWeight.normal),
                        maxLines: 9999,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 206,
              width: 54,
              top: 273,
              height: 27,
              child: Container(
                width: 54,
                height: 27,
                decoration: BoxDecoration(
                  color: const Color(0xdbffffff),
                  border: Border.all(color: const Color(0xff000000), width: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 11, top: 6, right: 11, bottom: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '10 km',
                        textAlign: TextAlign.left,
                        style: TextStyle(decoration: TextDecoration.none, fontSize: 12, color: const Color(0xff000000), fontFamily: 'SFProDisplay-Regular', fontWeight: FontWeight.normal),
                        maxLines: 9999,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 280,
              width: 54,
              top: 273,
              height: 27,
              child: Container(
                width: 54,
                height: 27,
                decoration: BoxDecoration(
                  color: const Color(0xdbffffff),
                  border: Border.all(color: const Color(0xff000000), width: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 9, top: 6, right: 9, bottom: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '15 km',
                        textAlign: TextAlign.left,
                        style: TextStyle(decoration: TextDecoration.none, fontSize: 12, color: const Color(0xff000000), fontFamily: 'SFProDisplay-Regular', fontWeight: FontWeight.normal),
                        maxLines: 9999,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 22,
              width: 351,
              top: 489,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset('images/image8_55783.png', width: 351,),
              ),
            ),
            Positioned(
              left: 42,
              top: 510,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Minutes',
                      textAlign: TextAlign.left,
                      style: TextStyle(decoration: TextDecoration.none, fontSize: 18, color: const Color(0x66000000), fontFamily: 'SFProDisplay-Regular', fontWeight: FontWeight.normal),
                      maxLines: 9999,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 58,
              width: 54,
              top: 459,
              height: 27,
              child: Container(
                width: 54,
                height: 27,
                decoration: BoxDecoration(
                  color: const Color(0xdbffffff),
                  border: Border.all(color: const Color(0xff000000), width: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 9, top: 6, right: 9, bottom: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '15 min',
                        textAlign: TextAlign.left,
                        style: TextStyle(decoration: TextDecoration.none, fontSize: 12, color: const Color(0xff000000), fontFamily: 'SFProDisplay-Regular', fontWeight: FontWeight.normal),
                        maxLines: 9999,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 132,
              width: 54,
              top: 459,
              height: 27,
              child: Container(
                width: 54,
                height: 27,
                decoration: BoxDecoration(
                  color: const Color(0xdbffffff),
                  border: Border.all(color: const Color(0xff000000), width: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 9, top: 6, right: 9, bottom: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '30 min',
                        textAlign: TextAlign.left,
                        style: TextStyle(decoration: TextDecoration.none, fontSize: 12, color: const Color(0xff000000), fontFamily: 'SFProDisplay-Regular', fontWeight: FontWeight.normal),
                        maxLines: 9999,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 206,
              width: 54,
              top: 459,
              height: 27,
              child: Container(
                width: 54,
                height: 27,
                decoration: BoxDecoration(
                  color: const Color(0xdbffffff),
                  border: Border.all(color: const Color(0xff000000), width: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 9, top: 6, right: 9, bottom: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '60 min',
                        textAlign: TextAlign.left,
                        style: TextStyle(decoration: TextDecoration.none, fontSize: 12, color: const Color(0xff000000), fontFamily: 'SFProDisplay-Regular', fontWeight: FontWeight.normal),
                        maxLines: 9999,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 280,
              width: 54,
              top: 459,
              height: 27,
              child: Container(
                width: 54,
                height: 27,
                decoration: BoxDecoration(
                  color: const Color(0xdbffffff),
                  border: Border.all(color: const Color(0xff000000), width: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 9, top: 6, right: 9, bottom: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '90 min',
                        textAlign: TextAlign.left,
                        style: TextStyle(decoration: TextDecoration.none, fontSize: 12, color: const Color(0xff000000), fontFamily: 'SFProDisplay-Regular', fontWeight: FontWeight.normal),
                        maxLines: 9999,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: -10,
              width: 413.423,
              top: 744,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset('images/image9_55786.png', width: 413.423,),
              ),
            ),
            Positioned(
              left: 20.211,
              width: 353,
              top: 758.211,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset('images/image10_55785.png', width: 353,),
              ),
            ),
            Positioned(
              left: 170,
              top: 773,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Add',
                      textAlign: TextAlign.center,
                      style: TextStyle(decoration: TextDecoration.none, fontSize: 20, color: const Color(0xffffffff), fontFamily: 'SFProDisplay-Regular', fontWeight: FontWeight.normal),
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
