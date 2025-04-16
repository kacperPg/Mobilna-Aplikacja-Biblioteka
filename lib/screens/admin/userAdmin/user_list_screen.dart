import 'package:flutter/material.dart';
import 'package:prosta_aplikcja/screens/admin/userAdmin/user_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:prosta_aplikcja/providers/user_provider.dart';
import 'package:prosta_aplikcja/models/user_model.dart';

class UserListScreen extends StatelessWidget {
  static const routeName = '/UsersScreen';

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista Użytkowników'),
      ),
      body: FutureBuilder(
        future: userProvider.fetchAllUsers(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Błąd: ${snapshot.error}'));
          }

          return Consumer<UserProvider>(
            builder: (ctx, userProvider, _) {
              final users = userProvider.getAllUsers;

              if (users.isEmpty) {
                return const Center(child: Text('Brak użytkowników'));
              }

              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (ctx, index) {
                  final user = users[index];
                  return ListTile(
                    title: Text(user.userName),
                    subtitle: Text(user.userEmail),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(user.userImage!)
                      as ImageProvider,
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        UserDetailScreen.routeName,
                        arguments: user,
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
