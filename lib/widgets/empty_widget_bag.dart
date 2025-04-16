import 'package:flutter/material.dart';
import 'package:prosta_aplikcja/root_screen.dart';
import 'package:prosta_aplikcja/services/assets_manager.dart';
import 'package:prosta_aplikcja/widgets/subtitles_text.dart';
import 'package:prosta_aplikcja/widgets/titles_text.dart';

class EmptyBagWidget extends StatelessWidget {
  final String imagePath, title, subtitle, buttonText,appBarText;
  const EmptyBagWidget(
      {super.key,
      required this.imagePath,
      required this.title,
      required this.subtitle,
      required this.buttonText,
          required this.appBarText});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          title: TitlesTextWidget(
            fontSize: 20,
            label: appBarText,
          ),
         leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          children: [
            Image.asset(
              imagePath,
              height: size.height * 0.35,
              width: double.infinity,
            ),
            TitlesTextWidget(
              label: title,
              fontSize: 25,
              color: Colors.red,
            ),
            const SizedBox(
              height: 20,
            ),
            SubtitileTextWidget(fontWeight: FontWeight.w400, label: subtitle),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                style:
                    ElevatedButton.styleFrom(padding: const EdgeInsets.all(20)),
                onPressed: () async {
                  Navigator.of(context).pushNamed(RootScreen.routeName);
                },
                child: Text(buttonText, style: const TextStyle(fontSize: 22)))
          ],
        ),
      ),
    );
  }
}
