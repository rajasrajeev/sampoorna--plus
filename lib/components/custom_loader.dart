import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ShowDialogLoader extends StatelessWidget {
  const ShowDialogLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return  
    Dialog(
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            //The loading indicator
            CircularProgressIndicator(),
            SizedBox(
              height: 15,
            ),
            Text("Loading")
          ],
        ),
        
        ),
        
    );
    
  }
}