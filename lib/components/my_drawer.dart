import 'package:flutter/material.dart';
import 'package:mytwitter/components/my_drawer_title.dart';
import 'package:mytwitter/pages/profile_page.dart';
import 'package:mytwitter/pages/settings_page.dart';
import 'package:mytwitter/services/auth/auth_service.dart';

/*
this is to access to the left side app bar
*/

class MyDrawer extends StatelessWidget {
  MyDrawer({super.key});

  // accesss auth service
  final _auth = AuthService();

  // logout
  void logout() {
    _auth.logout();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: [
              //app logo
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50.0),
                child: Icon(
                  Icons.person,
                  size: 72,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),

              Divider(
                color: Theme.of(context).colorScheme.secondary,
              ),

              const SizedBox(height: 10),

              //home list title
              MyDrawerTitle(
                title: "H O M E",
                icon: Icons.home,
                onTap: () {
                  //pop menu drawer since we are already at home
                  Navigator.pop(context);
                },
              ),

              //Profile list title
              MyDrawerTitle(
                title: "P R O F I L E",
                icon: Icons.person,
                onTap: () {
                  //pop menu drawer
                  Navigator.pop(context);

                  // go to the profile page
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ProfilePage(uid: _auth.getCurrentUid()),
                              ),
                       );
                },
              ),

              //search list title

              //settings list title
              MyDrawerTitle(
                title: "S E T T I N G S",
                icon: Icons.settings,
                onTap: () {
                  //pop menu drawer
                  Navigator.pop(context);

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsPage(),
                      ));
                },
              ),

              const Spacer(),

              // Logout list title
              MyDrawerTitle(
                  title: "L O G O U T", icon: Icons.logout, onTap: logout),
            ],
          ),
        ),
      ),
    );
  }
}
