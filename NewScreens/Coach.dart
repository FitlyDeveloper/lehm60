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
              left: 49,
              width: 20,
              top: 776,
              height: 19,
              child: Text(
                'Aa',
                textAlign: TextAlign.left,
                style: TextStyle(decoration: TextDecoration.none, fontSize: 16, color: const Color(0x7f000000), fontFamily: 'SFProDisplay-Regular', fontWeight: FontWeight.normal),
                maxLines: 9999,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              height: 852,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    top: -2,
                    height: 854,
                    child: Image.asset('images/image1_136289.png', height: 854, fit: BoxFit.cover,),
                  ),
                  Positioned(
                    left: 125,
                    width: 72,
                    top: 67,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 94,
                          child: Text(
                            'Coach',
                            textAlign: TextAlign.left,
                            style: TextStyle(decoration: TextDecoration.none, fontSize: 26, color: const Color(0xff000000), fontFamily: 'SFProDisplay-Bold', fontWeight: FontWeight.normal),
                            maxLines: 9999,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(
                          width: 115,
                          child: Text(
                            'Active now',
                            textAlign: TextAlign.left,
                            style: TextStyle(decoration: TextDecoration.none, fontSize: 16, color: const Color(0x7f000000), fontFamily: 'SFProDisplay-Regular', fontWeight: FontWeight.normal),
                            maxLines: 9999,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 35.5,
                    top: 62,
                    child: Image.asset('images/image2_138464.png',),
                  ),
                  Positioned(
                    left: 28,
                    width: 338,
                    top: 115,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Image.asset('images/image3_138463.png', width: 338,),
                    ),
                  ),
                  Positioned(
                    left: 28,
                    width: 338,
                    top: 743,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Image.asset('images/image4_138459.png', width: 338,),
                    ),
                  ),
                  Positioned(
                    left: 49,
                    top: 716,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Example: How many calories are in a banana?',
                            textAlign: TextAlign.left,
                            style: TextStyle(decoration: TextDecoration.none, fontSize: 14, color: const Color(0x7f000000), fontFamily: 'SFProDisplay-Regular', fontWeight: FontWeight.normal),
                            maxLines: 9999,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 35,
                    top: 765,
                    child: Image.asset('images/image5_138457.png',),
                  ),
                  Positioned(
                    left: 22,
                    width: 223,
                    top: 159,
                    height: 47,
                    child: Container(
                      width: 223,
                      height: 47,
                      decoration: BoxDecoration(
                        color: const Color(0xffffffff),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [BoxShadow(color: const Color(0x14000000), offset: Offset(0, 3), blurRadius: 8),],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, top: 13, right: 10, bottom: 13),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Hey! How can I help you?',
                              textAlign: TextAlign.left,
                              style: TextStyle(decoration: TextDecoration.none, fontSize: 18, color: const Color(0xff000000), fontFamily: 'SFProDisplay-Regular', fontWeight: FontWeight.normal),
                              maxLines: 9999,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 169,
                    width: 96,
                    top: 952,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Fitly',
                            textAlign: TextAlign.left,
                            style: TextStyle(decoration: TextDecoration.none, fontSize: 39, color: const Color(0xff000000), fontFamily: 'SFProDisplay-Bold', fontWeight: FontWeight.normal),
                            maxLines: 9999,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 158,
                    width: 223,
                    top: 244,
                    height: 47,
                    child: Container(
                      width: 223,
                      height: 47,
                      decoration: BoxDecoration(
                        color: const Color(0xff000000),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [BoxShadow(color: const Color(0x14000000), offset: Offset(0, 3), blurRadius: 8),],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8, top: 13, right: 8, bottom: 13),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Hey! How can I help you?',
                              textAlign: TextAlign.left,
                              style: TextStyle(decoration: TextDecoration.none, fontSize: 18, color: const Color(0xffffffff), fontFamily: 'SFProDisplay-Regular', fontWeight: FontWeight.normal),
                              maxLines: 9999,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
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
    );
  }
}
