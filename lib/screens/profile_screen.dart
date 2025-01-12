import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prosta_aplikcja/models/user_model.dart';
import 'package:prosta_aplikcja/providers/theme_provider.dart';
import 'package:prosta_aplikcja/providers/user_provider.dart';
import 'package:prosta_aplikcja/screens/auth/login.dart';
import 'package:prosta_aplikcja/screens/inner_screens/loading_manager.dart';
import 'package:prosta_aplikcja/screens/inner_screens/viewed_recently.dart';
import 'package:prosta_aplikcja/screens/inner_screens/wishlist_screen.dart';
import 'package:prosta_aplikcja/services/assets_manager.dart';
import 'package:prosta_aplikcja/services/my_app_methods.dart';
import 'package:prosta_aplikcja/widgets/subtitles_text.dart';
import 'package:prosta_aplikcja/widgets/titles_text.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => false;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel? userModel;
  bool _isLoading = true;

  Future<void> fetchUserInfo() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      setState(() {
        _isLoading = true;
      });
      userModel = await userProvider.fetchUserInfo();
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      await MyAppMethods.showErrorOrWarningDialog(
        context: context,
        subtitle: error.toString(),
        fct: () {},
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    fetchUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: const TitlesTextWidget(
            label: "Profil",
            fontSize: 20,
          ),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(AssetsManager.libraryIcon),
          ),
        ),
        body: LoadingManager(
            isLoading: _isLoading,
            child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: user == null ? true : false,
                      child: const Padding(
                        padding: EdgeInsets.all(18.0),
                        child: TitlesTextWidget(
                          label: "Zaloguj się",
                        ),
                      ),
                    ),
                    userModel == null
                        ? const SizedBox.shrink()
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Row(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Theme.of(context).cardColor,
                                    border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background,
                                        width: 3),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        userModel!.userImage ??
                                            'https://freesvg.org/img/abstract-user-flat-4.png',
                                      ),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TitlesTextWidget(
                                        label: userModel!.userName),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    SubtitileTextWidget(
                                        label: userModel!.userEmail)
                                  ],
                                )
                              ],
                            ),
                          ),
                    const SizedBox(
                      height: 15,
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    //   child: Row(
                    //     children: [
                    //       Container(
                    //         height: 60,
                    //         width: 60,
                    //         decoration: BoxDecoration(
                    //             shape: BoxShape.circle,
                    //             color: Theme.of(context).cardColor,
                    //             border: Border.all(
                    //                 color:
                    //                     Theme.of(context).colorScheme.surface,
                    //                 width: 3),
                    //             image: const DecorationImage(
                    //                 image: NetworkImage(
                    //                     "https://freesvg.org/img/abstract-user-flat-4.png"),
                    //                 fit: BoxFit.fitWidth)),
                    //       ),
                    //       const SizedBox(
                    //         width: 10,
                    //       ),
                    //       const Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           TitlesTextWidget(label: "Kacper Pogorzelski"),
                    //           SubtitileTextWidget(
                    //               label: "Number Albumu: 0000000")
                    //         ],
                    //       )
                    //     ],
                    //   ),
                    // ),
                    
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14.0, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const TitlesTextWidget(label: "Ogólne"),
                          Visibility(
                            visible: userModel == null ? false : true,
                            child: CustomListTile(
                              text: "Wypożyczone",
                              imagePath: AssetsManager.orderSvg,
                              function: () {
                                // Navigator.pushNamed(
                                //   context,
                                //   BookedScreen.routeName,
                                // );
                              },
                            ),
                          ),
                          Visibility(
                            visible: userModel == null ? false : true,
                            child: CustomListTile(
                              text: "Lista życzeń",
                              imagePath: AssetsManager.wishlistSvg,
                              function: () {
                                Navigator.pushNamed(
                                    context, WishListScreen.routeName);
                              },
                            ),
                          ),
                             Visibility(
                            visible: userModel == null ? false : true,
                            child:CustomListTile(
                            text: "Ostatnio wyświetlone",
                            imagePath: AssetsManager.recent,
                            function: () {
                              Navigator.pushNamed(
                                  context, ViewedRecentlyScreen.routeName);
                            },
                          ),),
                             Visibility(
                            visible: userModel == null ? false : true,
                            child:CustomListTile(
                              imagePath: AssetsManager.fees,
                              text: "Opłaty",
                              function: () {})),
                             Visibility(
                            visible: userModel == null ? false : true,
                            child:CustomListTile(
                              imagePath: AssetsManager.privacy,
                              text: "Dane użytkownika",
                              function: () {})),
                          const Divider(
                            thickness: 1,
                          ),
                          const SizedBox(height: 10),
                          const TitlesTextWidget(label: "Ustawnienia"),
                          SwitchListTile(
                            title: Text(themeProvider.getIsDarkTheme
                                ? "Ciemny motyw"
                                : "Jasny motyw"),
                            value: themeProvider.getIsDarkTheme,
                            onChanged: (value) {
                              themeProvider.setDarkTheme(themevalue: value);
                            },
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              30.0,
                            ),
                          ),
                        ),
                        icon: Icon(user == null ? Icons.login : Icons.logout),
                        label: Text(user == null ? "Login" : "Wyloguj"),
                        onPressed: () async {
                          if (user == null) {
                            Navigator.pushNamed(context, LoginScreen.routeName);
                          } else {
                            await MyAppMethods.showErrorOrWarningDialog(
                              context: context,
                              subtitle:
                                  "Jesteś pewien żę checesz sie wylogować?",
                              fct: () async {
                                await FirebaseAuth.instance.signOut();
                                if (!mounted) return;
                                Navigator.pushReplacementNamed(
                                    context, LoginScreen.routeName);
                              },
                              isError: false,
                            );
                          }
                        },
                      ),
                    )
                  ],
                ))));
  }
}

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    super.key,
    required this.imagePath,
    required this.text,
    required this.function,
  });
  final String imagePath, text;
  final Function function;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        function();
      },
      title: SubtitileTextWidget(label: text),
      leading: Image.asset(
        imagePath,
        height: 34,
      ),
      trailing: const Icon(Icons.arrow_back),
    );
  }
}
