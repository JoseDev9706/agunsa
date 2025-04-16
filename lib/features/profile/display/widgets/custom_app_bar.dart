import 'package:agunsa/utils/ui_utils.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
    required this.uiUtils, this.title,
  });

  final UiUtils uiUtils;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
        height: uiUtils.screenHeight * 0.15,
        color: uiUtils.primaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
               GestureDetector(
                 onTap: () {
                   Navigator.pop(context);
                 },
                 child:  Container(
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: uiUtils.whiteColor,),
                   padding: EdgeInsets.all(2),
                   child: Icon(
                      Icons.arrow_back,
                      color: uiUtils.primaryColor,
                      size: 20,
                    )
                 ),
                 
               )
            ]),
            const Spacer(),
            Text(
              title ?? "PERFIL",
              style: TextStyle(
                color: uiUtils.whiteColor,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
    );
  }
}