import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prosta_aplikcja/models/user_model.dart';
import 'package:prosta_aplikcja/screens/admin/userAdmin/user_list_screen.dart';
import 'package:prosta_aplikcja/widgets/auth/image_picker_widget.dart';
import 'package:prosta_aplikcja/widgets/titles_text.dart';
import 'package:provider/provider.dart';
import 'package:prosta_aplikcja/providers/user_provider.dart';

class EditUserProfileScreen extends StatefulWidget {
  static const routeName = '/editUsers';
  final UserModel user;

  const EditUserProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  _EditUserProfileScreenState createState() => _EditUserProfileScreenState();
}

class _EditUserProfileScreenState extends State<EditUserProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthYearController = TextEditingController();
  final TextEditingController _userEmail = TextEditingController();
  final TextEditingController _studentId = TextEditingController();
    final TextEditingController _userStatus = TextEditingController();
  XFile? _pickedImage;
  bool _isLoading = false;
  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _nameController.text = widget.user.userName;
      _userEmail.text = widget.user.userEmail;
      _studentId.text = widget.user.albumNumber!;
      _birthYearController.text = widget.user.birthYear!;
        _userStatus.text = widget.user.userStatus;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.user != null) {
      _nameController.text = widget.user.userName;
      _userEmail.text = widget.user.userEmail;
      _studentId.text = widget.user.albumNumber!;
      _birthYearController.text = widget.user.birthYear.toString();
    }
  }

  Future<void> _updateUser() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    setState(() {
      _isLoading = true;
    });

    String? userImageUrl;
    if (_pickedImage != null) {
      final ref = FirebaseStorage.instance
          .ref()
          .child("usersImages")
          .child("${widget.user.userId}.jpg");
      await ref.putFile(File(_pickedImage!.path));
      userImageUrl = await ref.getDownloadURL();
    }

    await userProvider.updateProvidedUser(
        userName: _nameController.text,
        userImage: userImageUrl,
                userStatus:_userStatus.text ,
        birthYear: _birthYearController.text,
    user: widget.user);

    setState(() {
      _isLoading = false;
    });

    Navigator.pushNamed(context, UserListScreen.routeName);
  }

  Future<void> _pickImage() async {
    final ImagePicker imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _pickedImage = pickedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    if (widget.user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const TitlesTextWidget(
            fontSize: 20,
            label: "Edytuj profil",
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                height: size.width * 0.3,
                width: size.width * 0.3,
                child: PickImageWidget(
                  pickedImage: _pickedImage,
                  function: _pickImage,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _userEmail,
                decoration: const InputDecoration(
                  labelText: "Email",
                  filled: true,
                  fillColor: Colors.grey,
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _studentId,
                decoration: const InputDecoration(
                  labelText: "Nr albumu",
                  filled: true,
                  fillColor: Colors.grey,
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration:
                    const InputDecoration(labelText: "Nazwa użytkownika"),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _birthYearController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Rok urodzenia",
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _birthYearController.text =
                          "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
             DropdownButtonFormField<String>(
              value: _userStatus.text,
              decoration: const InputDecoration(labelText: 'Status'),
              items: const [
                DropdownMenuItem(
                  value: "Aktywny",
                  child: Text("Aktywny"),
                ),
                DropdownMenuItem(
                  value: "NieAktywny",
                  child: Text("NieAktywny"),
                ),
              ],
              onChanged: (String? newValue) {
                setState(() {
                  _userStatus.text = newValue!;
                });
              },
            ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateUser,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Zapisz zmiany"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
