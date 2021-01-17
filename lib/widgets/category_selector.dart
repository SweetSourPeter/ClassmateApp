import 'package:flutter/material.dart';

class CategorySelector extends StatefulWidget {
  @override
  _CategorySelectorState createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  int selectedIndex = 0;
  final List<String> categories = [
    'College',
    'GPA',
    'Languages',
    'Study habits',
  ];

  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 1.0,
          ),
        ],
      ),
      height: mediaQuery.height * 0.1,
      // color: Colors.white,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 18.0,
                vertical: 20.0,
              ),
              child: Text(
                categories[index],
                style: TextStyle(
                  decoration:
                      index == selectedIndex ? TextDecoration.underline : null,
                  decorationColor: Colors.deepOrange[200],
                  decorationThickness: 3,
                  decorationStyle: TextDecorationStyle.solid,
                  color: index == selectedIndex ? Colors.black : Colors.black87,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
