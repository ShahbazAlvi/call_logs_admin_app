import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String title;
  final Function() press;
  final double width;
  const AppButton({super.key,
    required this.title,
    required this.press,
    required this.width});

  @override
  Widget build(BuildContext context) {
    final screenHeight=MediaQuery.of(context).size.height;
    final screenWidget=MediaQuery.of(context).size.width;

    return InkWell(
      onTap:press,
      child: Container(
        height:screenHeight*0.08,
        width: width ?? double.infinity,
        decoration:  BoxDecoration(
          color: Colors.indigo,
          borderRadius: BorderRadius.circular(10),

        ),
        child: Center(child: Text(title,style: TextStyle(color: Colors.white),)),
      ),
    );
  }
}
