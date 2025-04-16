import 'package:flutter/material.dart';
import 'package:prosta_aplikcja/models/user_model.dart';
import 'package:prosta_aplikcja/screens/admin/userAdmin/edit_users_screen.dart';

class UserDetailScreen extends StatelessWidget {
  static const routeName = '/userDetail';

  @override
  Widget build(BuildContext context) {
    final UserModel user =
    ModalRoute.of(context)!.settings.arguments as UserModel;

    return Scaffold(
      appBar: AppBar(
        title: Text(user.userName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: user.userImage != null
                  ? NetworkImage(user.userImage!)
                  : AssetImage('assets/images/default_avatar.png')
              as ImageProvider,
            ),
            const SizedBox(height: 20),
            Text(
              'Email: ${user.userEmail}',
              style: TextStyle(fontSize: 18),
            ),
            const Divider(
              thickness: 1,
              color: Colors.grey,
              height: 20,
            ),
            Text(
              'Numer albumu: ${user.albumNumber}',
              style: TextStyle(fontSize: 18),
            ),
            const Divider(
              thickness: 1,
              color: Colors.grey,
              height: 20,
            ),
            Text(
              'Status użytkownika: ${user.userStatus}',
              style: TextStyle(fontSize: 18),
            ),
            const Divider(
              thickness: 1,
              color: Colors.grey,
              height: 20,
            ),
            Text(
              'Rok urodzenia: ${user.birthYear}',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EditUserProfileScreen(
                        user: user,
                  ),
                ));
              },
              child: const Text("Edytuj profil"),
            ),
          ],
        ),
      ),
    );
  }
}
