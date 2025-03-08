import 'package:flutter/material.dart';
import 'package:prosta_aplikcja/models/dashboard_btn_model.dart';
import 'package:prosta_aplikcja/providers/theme_provider.dart';
import 'package:prosta_aplikcja/services/assets_manager.dart';
import 'package:prosta_aplikcja/widgets/adminPage/dashboard_btn.dart';
import 'package:prosta_aplikcja/widgets/titles_text.dart';
import 'package:provider/provider.dart';
class DashboardScreen extends StatefulWidget {
  static const routeName = '/DashboardScreen';
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const TitlesTextWidget(label: "Panel zarządzania"),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child:  IconButton(
            onPressed: () {
              Navigator.canPop(context) ? Navigator.pop(context) : null;
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 18,
            )),
        ),
        actions: [
          IconButton(
            onPressed: () {
              themeProvider.setDarkTheme(
                  themevalue: !themeProvider.getIsDarkTheme);
            },
            icon: Icon(themeProvider.getIsDarkTheme
                ? Icons.light_mode
                : Icons.dark_mode),
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1,
        children: List.generate(
          4,
          (index) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: DashboardButtonsWidget(
              title:
                  DashboardButtonsModel.dashboardBtnList(context)[index].text,
                  
              imagePath: DashboardButtonsModel.dashboardBtnList(context)[index]
                  .imagePath,
              onPressed: () {
                DashboardButtonsModel.dashboardBtnList(context)[index]
                    .onPressed();
              },
            ),
          ),
        ),
      ),
    );
  }
}