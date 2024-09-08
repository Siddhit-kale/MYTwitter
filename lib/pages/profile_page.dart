import 'package:flutter/material.dart';
import 'package:mytwitter/components/my_bio_box.dart';
import 'package:mytwitter/models/user.dart';
import 'package:mytwitter/services/auth/auth_service.dart';
import 'package:mytwitter/services/database/database_provider.dart';
import 'package:provider/provider.dart';

/*
 Profile page

 */

class ProfilePage extends StatefulWidget {
  final String uid;

  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // providers
  late final databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);

  // user info
  UserProfile? user;
  String currentUserId = AuthService().getCurrentUid();

  // loading
  bool _isloading = true;

  // on startup,
  @override
  void initState() {
    super.initState();

    // let's load user info
    loadUser();
  }

  Future<void> loadUser() async {
    // get the user profile info
    user = await databaseProvider.userProfile(widget.uid);

    // finished loading
    setState(() {
      _isloading = false;
    });
  }

  // show edit bio box
  void _showEditBioBox() {
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        content: TextField(),
    )
    );
  }

  // build ui
  @override
  Widget build(BuildContext context) {
    // scaffload
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,

        //app bar
        appBar: AppBar(
          title: Text(_isloading ? '' : user!.name),
          foregroundColor: Theme.of(context).colorScheme.primary,
        ),

        //body
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: ListView(
            children: [
              // username handler
              Center(
                child: Text(
                  _isloading ? '' : '@${user!.username}',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
              ),

              const SizedBox(height: 25),

              // profile picture
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: EdgeInsets.all(25),
                  child: Icon(
                    Icons.person,
                    size: 72,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // profile stats -> number of posts / followers / following

              // follow / unfollow button

              // edit bio
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Bio",
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                  GestureDetector(
                    onTap: _showEditBioBox,
                    child: Icon(
                      Icons.settings,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // bio box
              MyBioBox(text: _isloading ? '...' : user!.bio),

              // list of posts from users
            ],
          ),
        ));
  }
}
