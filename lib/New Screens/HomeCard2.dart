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
              left: 0,
              right: 0,
              top: -2,
              height: 854,
              child: Image.asset('images/image1_446376.png', height: 854, fit: BoxFit.cover,),
            ),
            Positioned(
              left: 33.07,
              width: 164.873,
              top: 179.901,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset('images/image2_446426.png', width: 164.873,),
              ),
            ),
            Positioned(
              left: 33.282,
              width: 164.451,
              top: 175.218,
              child: Padding(
                padding: const EdgeInsets.only(left: 32.302818298339844, top: 9.788732528686523, right: 32.302818298339844, bottom: 9.788732528686523),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(9.788732528686523),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Steps',
                            textAlign: TextAlign.center,
                            style: TextStyle(decoration: TextDecoration.none, fontSize: 15.662, color: const Color(0xff000000), fontFamily: 'SFProDisplay-Bold', fontWeight: FontWeight.normal),
                            maxLines: 9999,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 91.03521728515625),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 38.176,
                            child: Padding(
                              padding: const EdgeInsets.all(9.788732528686523),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '5010/10,000',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(decoration: TextDecoration.none, fontSize: 15.662, color: const Color(0xff000000), fontFamily: 'SFProDisplay-Regular', fontWeight: FontWeight.normal),
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
                  ],
                ),
              ),
            ),
            Positioned(
              left: 56.775,
              top: 215.352,
              child: Padding(
                padding: const EdgeInsets.all(9.788732528686523),
                child: Image.asset('images/image3_446391.png',),
              ),
            ),
            Positioned(
              left: 56.775,
              top: 215.352,
              child: Padding(
                padding: const EdgeInsets.all(9.788732528686523),
                child: Image.asset('images/image4_446393.png',),
              ),
            ),
            Positioned(
              left: 192.838,
              width: 163.472,
              top: 174.24,
              height: 188.923,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 5.873,
                    child: Padding(
                      padding: const EdgeInsets.all(9.788732528686523),
                      child: Image.asset('images/image1_446398.png',),
                    ),
                  ),
                  Positioned(
                    left: 45.028,
                    top: 12.725,
                    child: Padding(
                      padding: const EdgeInsets.all(9.788732528686523),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Activity',
                            textAlign: TextAlign.center,
                            style: TextStyle(decoration: TextDecoration.none, fontSize: 15.662, color: const Color(0xff000000), fontFamily: 'SFProDisplay-Bold', fontWeight: FontWeight.normal),
                            maxLines: 9999,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 35.24,
                    width: 29.366,
                    top: 44.049,
                    child: Padding(
                      padding: const EdgeInsets.all(9.788732528686523),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  child: Text(
                                    '0',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(decoration: TextDecoration.none, fontSize: 14.683, color: const Color(0xff000000), fontFamily: 'SFProDisplay-Regular', fontWeight: FontWeight.normal),
                                    maxLines: 9999,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 35.24,
                    top: 61.669,
                    child: Padding(
                      padding: const EdgeInsets.all(9.788732528686523),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Calories burned',
                            textAlign: TextAlign.center,
                            style: TextStyle(decoration: TextDecoration.none, fontSize: 10.768, color: const Color(0xff000000), fontFamily: 'SFProDisplay-Regular', fontWeight: FontWeight.normal),
                            maxLines: 9999,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 35.24,
                    width: 29.366,
                    top: 84.183,
                    child: Padding(
                      padding: const EdgeInsets.all(9.788732528686523),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  child: Text(
                                    '0',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(decoration: TextDecoration.none, fontSize: 14.683, color: const Color(0xff000000), fontFamily: 'SFProDisplay-Regular', fontWeight: FontWeight.normal),
                                    maxLines: 9999,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 35.24,
                    top: 101.803,
                    child: Padding(
                      padding: const EdgeInsets.all(9.788732528686523),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'From steps',
                            textAlign: TextAlign.center,
                            style: TextStyle(decoration: TextDecoration.none, fontSize: 10.768, color: const Color(0xff000000), fontFamily: 'SFProDisplay-Regular', fontWeight: FontWeight.normal),
                            maxLines: 9999,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 35.24,
                    width: 29.366,
                    top: 124.317,
                    child: Padding(
                      padding: const EdgeInsets.all(9.788732528686523),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  child: Text(
                                    '0',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(decoration: TextDecoration.none, fontSize: 14.683, color: const Color(0xff000000), fontFamily: 'SFProDisplay-Regular', fontWeight: FontWeight.normal),
                                    maxLines: 9999,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 35.24,
                    top: 141.936,
                    child: Padding(
                      padding: const EdgeInsets.all(9.788732528686523),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'From workout',
                            textAlign: TextAlign.center,
                            style: TextStyle(decoration: TextDecoration.none, fontSize: 10.768, color: const Color(0xff000000), fontFamily: 'SFProDisplay-Regular', fontWeight: FontWeight.normal),
                            maxLines: 9999,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 4.894,
                    top: 46.007,
                    child: Padding(
                      padding: const EdgeInsets.all(9.788732528686523),
                      child: Image.asset('images/image2_446414.png',),
                    ),
                  ),
                  Positioned(
                    left: 0.979,
                    top: 85.162,
                    child: Padding(
                      padding: const EdgeInsets.all(9.788732528686523),
                      child: Image.asset('images/image3_446416.png',),
                    ),
                  ),
                  Positioned(
                    left: 5.873,
                    top: 126.275,
                    child: Padding(
                      padding: const EdgeInsets.all(9.788732528686523),
                      child: Image.asset('images/image4_446418.png',),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 81.246,
              top: 237.866,
              child: Padding(
                padding: const EdgeInsets.all(9.788732528686523),
                child: Image.asset('images/image5_446423.png',),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
