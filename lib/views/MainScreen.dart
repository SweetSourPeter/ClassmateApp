import 'package:app_test/modals/constant.dart';
import 'package:app_test/modals/courseInfo.dart';
import 'package:app_test/modals/message_model.dart';
import 'package:app_test/views/FriendsScreen.dart';
import 'package:app_test/views/searchUser.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final tabs = [CourseMainMenu(), FriendsScreen()];
  final tabTitle = ['Course', 'Friends'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: buildAppBar(),
        body: Scaffold(
          backgroundColor: Colors.white,
          body: tabs[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            backgroundColor: lightOrangeColor,
            type: BottomNavigationBarType.shifting,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.class_),
                  title: Text('course'),
                  backgroundColor: orengeColor),
              BottomNavigationBarItem(
                  icon: Icon(Icons.contacts),
                  title: Text('friends'),
                  backgroundColor: orengeColor),
            ],
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ));
  }

  AppBar buildAppBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: lightOrangeColor,
      elevation: 0,
      leading: IconButton(
        iconSize: 35,
        color: darkBlueColor,
        padding: EdgeInsets.only(left: kDefaultPadding),
        icon: Icon(Icons.menu),
        onPressed: () {
          //TODO
        },
      ),
      title: Container(
          child: Text(
        tabTitle[_currentIndex],
      )),
      actions: <Widget>[
        IconButton(
          iconSize: 38,
          color: darkBlueColor,
          padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
          icon: Icon(Icons.search),
          onPressed: () {
            //TODO
            switch (_currentIndex) {
              case 0:
                {
                  //TODO for search course ot sth
                }
                break;
              case 1:
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchUsers()),
                  );
                }
                break;
              default:
                {
                  //TODO search for sth;
                }
                break;
            }
          },
        )
      ],
    );
  }
}

class CourseMainMenu extends StatelessWidget {
  const CourseMainMenu({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: course.map((courses) {
        return Container(
          margin:
              const EdgeInsets.only(bottom: 16, top: 16, left: 10, right: 10),
          height: 140,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple, Colors.red],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              boxShadow: [
                BoxShadow(
                    color: Colors.red.withOpacity(0.4),
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
                      style: TextStyle(color: Colors.white, fontSize: 26)),
                  SizedBox(
                    width: 9,
                  ),
                  Text('+' + courses.userNumbers.toString() + ' classmates',
                      style: TextStyle(color: orengeColor, fontSize: 18)),
                ],
              ),
            ],
          ),
        );
      }).followedBy([
        Container(
          // color: Colors.red,
          margin:
              const EdgeInsets.only(bottom: 16, top: 16, left: 10, right: 10),
          height: 140,
          // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [darkBlueColor, lightBlueColor],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              boxShadow: [
                BoxShadow(
                    color: Colors.red.withOpacity(0.4),
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
                  style: TextStyle(color: Colors.white, fontSize: 28))
            ],
          ),
        ),
      ]).toList(),
    );
  }
}
