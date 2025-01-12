import 'package:flutter/material.dart';
import 'package:prosta_aplikcja/widgets/titles_text.dart';
import 'package:shimmer/shimmer.dart';

class AppNameTextWidger extends StatelessWidget {
  final double fontSize;
  final String title;
  const AppNameTextWidger({super.key, this.fontSize= 20,  this.title="Biblioteka UC"});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: const Color.fromARGB(255, 82, 116, 131),
        highlightColor: const Color.fromARGB(255, 102, 148, 224),
        child: TitlesTextWidget(label: title,fontSize: fontSize,));
  }
}