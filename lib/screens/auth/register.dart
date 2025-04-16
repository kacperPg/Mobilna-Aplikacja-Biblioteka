import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prosta_aplikcja/consts/validator.dart';
import 'package:prosta_aplikcja/root_screen.dart';
import 'package:prosta_aplikcja/screens/auth/login.dart';
import 'package:prosta_aplikcja/screens/inner_screens/loading_manager.dart';
import 'package:prosta_aplikcja/services/my_app_methods.dart';
import 'package:prosta_aplikcja/widgets/app_name_text.dart';
import 'package:prosta_aplikcja/widgets/auth/image_picker_widget.dart';
import 'package:prosta_aplikcja/widgets/subtitles_text.dart';
import 'package:prosta_aplikcja/widgets/titles_text.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/RegisterScreen';
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool obscureText = true;
  late final TextEditingController _nameController,
      _emailController,
      _passwordController,
      _repeatPasswordController,
      _studentIdController,
      _yearOfBirthController;

  late final FocusNode _nameFocusNode,
      _emailFocusNode,
      _passwordFocusNode,
      _repeatPasswordFocusNode;

  final _formkey = GlobalKey<FormState>();
  XFile? _pickedImage;
  bool _isLoading = false;
  final auth = FirebaseAuth.instance;
  String? userImageUrl;

  @override
  void initState() {
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _repeatPasswordController = TextEditingController();
    _nameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _repeatPasswordFocusNode = FocusNode();
    _yearOfBirthController = TextEditingController();
    _studentIdController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    if (mounted) {
      _nameController.dispose();
      _emailController.dispose();
      _passwordController.dispose();
      _repeatPasswordController.dispose();
      // Focus Nodes
      _nameFocusNode.dispose();
      _emailFocusNode.dispose();
      _passwordFocusNode.dispose();
      _repeatPasswordFocusNode.dispose();
      _yearOfBirthController.dispose();
      _studentIdController.dispose();
    }
    super.dispose();
  }

  Future<void> _registerFCT() async {
    final isValid = _formkey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      try {
        setState(() {
          _isLoading = true;
        });

        await auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        final User? user = auth.currentUser;
        final String uid = user!.uid;

        if (_pickedImage != null) {
          final ref = FirebaseStorage.instance
              .ref()
              .child("usersImages")
              .child("${_emailController.text.trim()}.jpg");

          await ref.putFile(File(_pickedImage!.path));
          userImageUrl = await ref.getDownloadURL();
        } else {
          userImageUrl =
              "https://s3.amazonaws.com/37assets/svn/765-default-avatar.png";
        }

        await FirebaseFirestore.instance.collection("users").doc(uid).set({
          'userId': uid,
          'userName': _nameController.text,
          'userImage': userImageUrl,
          'userEmail': _emailController.text.toLowerCase(),
          'createdAt': Timestamp.now(),
          'userRole': "Standard",
          'userStatus': "Aktywny",
          'userWish': [],
          'userBooked': [],
          'yearOfBirth': _yearOfBirthController.text,
          'studentId': _studentIdController.text,
        });

        Fluttertoast.showToast(
          msg: "Konto zostało utworzone",
          textColor: Colors.white,
        );
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, RootScreen.routeName);
      } on FirebaseException catch (error) {
        await MyAppMethods.showErrorOrWarningDialog(
          context: context,
          subtitle: error.message.toString(),
          fct: () {},
        );
      } catch (error) {
        await MyAppMethods.showErrorOrWarningDialog(
          context: context,
          subtitle: error.toString(),
          fct: () {},
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> localImagePicker() async {
    final ImagePicker imagePicker = ImagePicker();
    await MyAppMethods.imagePickerDialog(
      context: context,
      cameraFCT: () async {
        _pickedImage = await imagePicker.pickImage(source: ImageSource.camera);
        if (_pickedImage != null) {
          setState(() {});
        }
      },
      galleryFCT: () async {
        _pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
        if (_pickedImage != null) {
          setState(() {});
        }
      },
      removeFCT: () {
        _pickedImage = null;
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: LoadingManager(
          isLoading: _isLoading,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // const BackButton(),
                  const SizedBox(
                    height: 60,
                  ),
                  const AppNameTextWidger(
                    fontSize: 30,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TitlesTextWidget(label: "Witaj!"),
                        ],
                      )),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: size.width * 0.3,
                    width: size.width * 0.3,
                    child: PickImageWidget(
                      pickedImage: _pickedImage,
                      function: () async {
                        await localImagePicker();
                      },
                    ),
                  ),

                  const SizedBox(
                    height: 30,
                  ),
                  Form(
                    key: _formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          controller: _nameController,
                          focusNode: _nameFocusNode,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.name,
                          decoration: const InputDecoration(
                            hintText: 'Imię i nazwisko',
                            prefixIcon: Icon(
                              Icons.person,
                            ),
                          ),
                          onFieldSubmitted: (value) {
                            FocusScope.of(context)
                                .requestFocus(_emailFocusNode);
                          },
                          validator: (value) {
                            return MyValidators.displayNamevalidator(value);
                          },
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        TextFormField(
                          controller: _emailController,
                          focusNode: _emailFocusNode,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: "Email",
                            prefixIcon: Icon(
                              IconlyLight.message,
                            ),
                          ),
                          onFieldSubmitted: (value) {
                            FocusScope.of(context)
                                .requestFocus(_passwordFocusNode);
                          },
                          validator: (value) {
                            return MyValidators.emailValidator(value);
                          },
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        TextFormField(
                          controller: _passwordController,
                          focusNode: _passwordFocusNode,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: obscureText,
                          decoration: InputDecoration(
                            hintText: "***********",
                            prefixIcon: const Icon(
                              IconlyLight.lock,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  obscureText = !obscureText;
                                });
                              },
                              icon: Icon(
                                obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                          ),
                          onFieldSubmitted: (value) async {
                            FocusScope.of(context)
                                .requestFocus(_repeatPasswordFocusNode);
                          },
                          validator: (value) {
                            return MyValidators.passwordValidator(value);
                          },
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        TextFormField(
                          controller: _repeatPasswordController,
                          focusNode: _repeatPasswordFocusNode,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: obscureText,
                          decoration: InputDecoration(
                            hintText: "Powtórz hasło",
                            prefixIcon: const Icon(
                              IconlyLight.lock,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  obscureText = !obscureText;
                                });
                              },
                              icon: Icon(
                                obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                          ),
                          onFieldSubmitted: (value) async {
                            await _registerFCT();
                          },
                          validator: (value) {
                            return MyValidators.repeatPasswordValidator(
                              value: value,
                              password: _passwordController.text,
                            );
                          },
                        ),
                        const SizedBox(
                          height: 36.0,
                        ),
                        TextFormField(
                          controller: _yearOfBirthController,
                          readOnly:
                              true,  
                          decoration: const InputDecoration(
                            hintText: "Rok urodzenia",
                            prefixIcon: Icon(Icons.calendar_today),
                          ),
                          onTap: () async {
                            FocusScope.of(context)
                                .requestFocus(FocusNode()); 
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                _yearOfBirthController.text =
                                    "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";  
                              });
                            }
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Proszę podać rok urodzenia';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        TextFormField(
                          controller: _studentIdController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: "Numer albumu",
                            prefixIcon: Icon(Icons.book),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Proszę podać numer albumu';
                            }
                            if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                              return 'Numer albumu może zawierać tylko liczby';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(12.0),
                              // backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  12.0,
                                ),
                              ),
                            ),
                            icon: const Icon(IconlyLight.addUser),
                            label: const Text("Zarejestruj się"),
                            onPressed: () async {
                              await _registerFCT();
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SubtitileTextWidget(label: "Masz konta?"),
                            TextButton(
                              child: const SubtitileTextWidget(
                                label: "Zaloguj się",
                                fontStyle: FontStyle.italic,
                                decoration: TextDecoration.underline,
                              ),
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed(LoginScreen.routeName);
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
