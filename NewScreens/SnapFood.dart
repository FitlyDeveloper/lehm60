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
        width: 394,
        height: 854,
        child: Stack(
          children: [
            Positioned(
              left: 34,
              width: 36,
              top: 69,
              height: 36,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Image.asset('images/image1_451442.png', width: 36, height: 36,),
              ),
            ),
            Positioned(
              left: 34,
              width: 326,
              top: 160,
              child: Image.asset('images/image2_451441.png', width: 326,),
            ),
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
                  padding: const EdgeInsets.only(left: 0, top: 7, right: 0, bottom: 7),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('images/image_40850.png', width: 33, height: 33, fit: BoxFit.cover,),
                      const SizedBox(height: 5),
                      SizedBox(
                        width: 98,
                        child: Text(
                          'Scan Food',
                          textAlign: TextAlign.center,
                          style: TextStyle(decoration: TextDecoration.none, fontSize: 13, color: const Color(0xff000000), fontFamily: 'SFProDisplay-Regular', fontWeight: FontWeight.normal),
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
                  padding: const EdgeInsets.only(left: 0, top: 7, right: 0, bottom: 7),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('images/image_40448.png', width: 33, height: 33, fit: BoxFit.cover,),
                      const SizedBox(height: 5),
                      SizedBox(
                        width: 98,
                        child: Text(
                          'Scan Code',
                          textAlign: TextAlign.center,
                          style: TextStyle(decoration: TextDecoration.none, fontSize: 13, color: const Color(0xff000000), fontFamily: 'SFProDisplay-Regular', fontWeight: FontWeight.normal),
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
                  padding: const EdgeInsets.only(left: 0, top: 6, right: 0, bottom: 6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('images/image_40851.png', width: 32, height: 32, fit: BoxFit.cover,),
                      const SizedBox(height: 7),
                      SizedBox(
                        width: 98,
                        child: Text(
                          'Add Photo',
                          textAlign: TextAlign.center,
                          style: TextStyle(decoration: TextDecoration.none, fontSize: 13, color: const Color(0xff000000), fontFamily: 'SFProDisplay-Regular', fontWeight: FontWeight.normal),
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
              left: 147,
              top: 721,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset('images/image3_451435.png',),
              ),
            ),
            Positioned(
              left: 53,
              top: 741,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset('images/image4_451434.png',),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
