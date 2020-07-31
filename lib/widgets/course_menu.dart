import 'package:app_test/models/constant.dart';
import 'package:app_test/models/courseInfo.dart';
import 'package:flutter/material.dart';

class CourseMainMenu extends StatefulWidget {
  const CourseMainMenu({
    Key key,
  }) : super(key: key);

  @override
  _CourseMainMenuState createState() => _CourseMainMenuState();
}

class _CourseMainMenuState extends State<CourseMainMenu> {
  // @override
  // void initState() {
  //   // adjust the provider based on the image type
  //   // for (int i = 0; i < 1; i++) {
  //   precacheImage(AssetImage('assets/courseimage/econ_course_BG.jpg'), context);
  //   // }
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return
        // ReorderableListView(
        //   scrollDirection: Axis.vertical,
        //   children: course.map<Widget>((courses) {
        //     return Container(
        //       key: ValueKey(courses.courseID),
        //       margin:
        //           const EdgeInsets.only(bottom: 16, top: 16, left: 25, right: 25),
        //       height: 130,
        //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        //       decoration: BoxDecoration(
        //           // image: DecorationImage(
        //           //   image: courseImageAssets(courses.courseCategory),
        //           //   fit: BoxFit.cover,
        //           // ),
        //           gradient: LinearGradient(
        //             colors: [Colors.purple, Colors.red],
        //             begin: Alignment.centerLeft,
        //             end: Alignment.centerRight,
        //           ),
        //           boxShadow: [
        //             BoxShadow(
        //                 color: builtyPinkColor.withOpacity(1),
        //                 blurRadius: 8,
        //                 spreadRadius: 2,
        //                 offset: Offset(4, 4))
        //           ],
        //           borderRadius: BorderRadius.all(Radius.circular(24))),
        //       child: Column(
        //         children: <Widget>[
        //           SizedBox(
        //             height: 4,
        //           ),
        //           Row(
        //             children: <Widget>[
        //               SizedBox(
        //                 width: 9,
        //               ),
        //               Text(courses.myCourseName,
        //                   style: TextStyle(color: Colors.white, fontSize: 20)),
        //               SizedBox(
        //                 width: 9,
        //               ),
        //               Text('+' + courses.userNumbers.toString() + ' classmates',
        //                   style: TextStyle(color: orengeColor, fontSize: 18)),
        //             ],
        //           ),
        //         ],
        //       ),
        //     );
        //   }).followedBy([
        //     Container(
        //       // color: Colors.red,
        //       key: ValueKey('addCourse1111111'),
        //       margin:
        //           const EdgeInsets.only(bottom: 16, top: 16, left: 25, right: 25),
        //       height: 130,
        //       padding: const EdgeInsets.symmetric(horizontal: 118, vertical: 8),
        //       decoration: BoxDecoration(
        //           gradient: LinearGradient(
        //             colors: [darkBlueColor, lightBlueColor],
        //             begin: Alignment.centerLeft,
        //             end: Alignment.centerRight,
        //           ),
        //           boxShadow: [
        //             BoxShadow(
        //                 color: lightBlueColor.withOpacity(0.4),
        //                 blurRadius: 8,
        //                 spreadRadius: 2,
        //                 offset: Offset(4, 4))
        //           ],
        //           borderRadius: BorderRadius.all(Radius.circular(24))),
        //       child: Column(
        //         children: <Widget>[
        //           Padding(padding: const EdgeInsets.only(top: 5, bottom: 10)),
        //           Image.asset(
        //             'assets/images/add_course.png',
        //             scale: 1.2,
        //           ),
        //           SizedBox(
        //             height: 8,
        //           ),
        //           Text('Add Course',
        //               style: TextStyle(color: Colors.white, fontSize: 24))
        //         ],
        //       ),
        //     ),
        //   ]).toList(),
        //   onReorder: _onReorder,
        // );
        CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          centerTitle: true,
          title: Text("Course"),
          backgroundColor: orengeColor,
          elevation: 5,
          floating: true,
          leading: IconButton(
            iconSize: 35,
            color: darkBlueColor,
            padding: EdgeInsets.only(left: kDefaultPadding),
            icon: Icon(Icons.menu),
            onPressed: () {
              //todo
              // setMenuOpenState(true);
            },
          ),
          actions: <Widget>[
            IconButton(
                iconSize: 38,
                color: darkBlueColor,
                padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                icon: Icon(Icons.search),
                onPressed: () {
                  //TODO
                })
          ],
        ),
        SliverList(
            delegate: SliverChildListDelegate(course.map<Widget>((courses) {
          return Container(
              margin: const EdgeInsets.only(
                  bottom: 16, top: 16, left: 25, right: 25),
              height: 130,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                  // image: DecorationImage(
                  //   image: courseImageAssets(courses.courseCategory),
                  //   fit: BoxFit.cover,
                  // ),
                  gradient: LinearGradient(
                    colors: [Colors.white, builtyPinkColor],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        spreadRadius: 2,
                        offset: Offset(4, 4))
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(24))),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 9,
                      ),
                      Text(courses.myCourseName,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 26,
                              fontWeight: FontWeight.w500)),
                      SizedBox(
                        width: 9,
                      ),
                      Text('+' + courses.userNumbers.toString() + ' classmates',
                          style: TextStyle(color: orengeColor, fontSize: 18)),
                    ],
                  ),
                ],
              ));
        }).followedBy([
          Container(
            // color: Colors.red,
            margin:
                const EdgeInsets.only(bottom: 16, top: 16, left: 25, right: 25),
            height: 120,
            // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [lightYellowColor, builtyPinkColor],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      spreadRadius: 2,
                      offset: Offset(4, 4))
                ],
                borderRadius: BorderRadius.all(Radius.circular(24))),
            child: Column(
              children: <Widget>[
                Padding(padding: const EdgeInsets.only(top: 10, bottom: 10)),
                Image.asset(
                  'assets/images/add_course.png',
                  scale: 1.1,
                ),
                SizedBox(
                  height: 8,
                ),
                Text('Add Course',
                    style: TextStyle(color: lightBlueColor, fontSize: 28))
              ],
            ),
          ),
        ]).toList()))
      ],
    );
    //       ListView(
    //     children:
    // course.map((courses) {
    //       return Container(
    //         margin:
    //             const EdgeInsets.only(bottom: 16, top: 16, left: 25, right: 25),
    //         height: 130,
    //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    //         decoration: BoxDecoration(
    //             image: DecorationImage(
    //               image: courseImageAssets(courses.courseCategory),
    //               fit: BoxFit.cover,
    //             ),
    //             // gradient: LinearGradient(
    //             //   colors: [Colors.white, colorSelection(courses.courseCategory)],
    //             //   begin: Alignment.centerLeft,
    //             //   end: Alignment.centerRight,
    //             // ),
    //             boxShadow: [
    //               BoxShadow(
    //                   color: Colors.black.withOpacity(0.2),
    //                   blurRadius: 8,
    //                   spreadRadius: 2,
    //                   offset: Offset(4, 4))
    //             ],
    //             borderRadius: BorderRadius.all(Radius.circular(24))),
    //         child: Column(
    //           children: <Widget>[
    //             SizedBox(
    //               height: 4,
    //             ),
    //             Row(
    //               children: <Widget>[
    //                 SizedBox(
    //                   width: 9,
    //                 ),
    //                 Text(courses.myCourseName,
    //                     style: TextStyle(
    //                         color: Colors.black,
    //                         fontSize: 26,
    //                         fontWeight: FontWeight.w500)),
    //                 SizedBox(
    //                   width: 9,
    //                 ),
    //                 Text('+' + courses.userNumbers.toString() + ' classmates',
    //                     style: TextStyle(color: orengeColor, fontSize: 18)),
    //               ],
    //             ),
    //           ],
    //         ),
    //       );
    //     }).followedBy([
    //       Container(
    //         // color: Colors.red,
    //         margin:
    //             const EdgeInsets.only(bottom: 16, top: 16, left: 25, right: 25),
    //         height: 120,
    //         // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    //         decoration: BoxDecoration(
    //             gradient: LinearGradient(
    //               colors: [darkBlueColor, lightBlueColor],
    //               begin: Alignment.centerLeft,
    //               end: Alignment.centerRight,
    //             ),
    //             boxShadow: [
    //               BoxShadow(
    //                   color: Colors.black.withOpacity(0.2),
    //                   blurRadius: 8,
    //                   spreadRadius: 2,
    //                   offset: Offset(4, 4))
    //             ],
    //             borderRadius: BorderRadius.all(Radius.circular(24))),
    //         child: Column(
    //           children: <Widget>[
    //             Padding(padding: const EdgeInsets.only(top: 10, bottom: 10)),
    //             Image.asset(
    //               'assets/images/add_course.png',
    //               scale: 1.1,
    //             ),
    //             SizedBox(
    //               height: 8,
    //             ),
    //             Text('Add Course',
    //                 style: TextStyle(color: Colors.white, fontSize: 28))
    //           ],
    //         ),
    //       ),
    //     ]).toList(),
    //   );
    // }

    void _onReorder(int oldIndex, int newIndex) {
      setState(
        () {
          if (newIndex > oldIndex) {
            newIndex -= 1;
          }
          final CourseInfo item = course.removeAt(oldIndex);
          course.insert(newIndex, item);
        },
      );
    }

    Color colorSelection(String type) {
      switch (type) {
        case 'CS':
          {
            return Colors.lightGreen;
          }
          break;
        case 'WR':
          {
            return Colors.yellow;
          }
          break;
        case 'PH':
          {
            return Colors.black12;
          }
          break;
        case 'ECON':
          {
            return Colors.blue;
          }
          break;
        default:
          {
            return Colors.black12;
          }
          break;
      }
    }
  }

  AssetImage courseImageAssets(String type) {
    switch (type) {
      case 'CS':
        {
          return AssetImage('assets/courseimage/cs_course_BG.jpg');
        }
        break;
      case 'WR':
        {
          return AssetImage('assets/courseimage/wr_course_BG.jpg');
        }
        break;
      case 'PH':
        {
          return AssetImage('assets/courseimage/ph_course_BG.jpg');
        }
        break;
      case 'ECON':
        {
          return AssetImage('assets/courseimage/econ_course_BG.jpg');
        }
        break;
      default:
        {
          return AssetImage('assets/courseimage/econ_course_BG.jpg');
        }
        break;
    }
  }
}
