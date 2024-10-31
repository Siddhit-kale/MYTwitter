/*

  Follow list

*/

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mytwitter/components/my_user_tile.dart';
import 'package:mytwitter/models/user.dart';
import 'package:mytwitter/services/database/database_provider.dart';
import 'package:provider/provider.dart';

class FollowListPage extends StatefulWidget {
  final String uid;

  const FollowListPage({super.key, required this.uid});

  @override
  State<FollowListPage> createState() => _FollowListPageState();
}

class _FollowListPageState extends State<FollowListPage> {
  // providers
  late final listingProvider = Provider.of<DatabaseProvider>(context);
  late final databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);

  // on startup.
  @override
  void initState() {
    super.initState();

    // load follower list
    loadFollowerList();

    // load following list
    loadFollowingList();
  }

  // load followers
  Future<void> loadFollowerList() async {
    await databaseProvider.loaduserFollowerProfiles(widget.uid);
  }

  // load following
  Future<void> loadFollowingList() async {
    await databaseProvider.loaduserFollowingProfiles(widget.uid);
  }

  // build ui
  @override
  Widget build(BuildContext context) {
    // listen to followers & following
    final followers = listingProvider.getListOfFollowerProfile(widget.uid);
    final following = listingProvider.getListOfFollowingProfile(widget.uid);

    // Tab controller
    return DefaultTabController(
        length: 2,

        // scaffload
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          // appbar
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            // tab bar
            bottom: TabBar(
              dividerColor: const Color.fromARGB(0, 0, 0, 0),
              labelColor: Colors.black,
              unselectedLabelColor: Theme.of(context).colorScheme.primary,
              indicatorColor: Colors.black,

              // tabs
              tabs: [
                Tab(text: "Followers"),
                Tab(text: "Following"),
              ],
            ),
          ),

          // body
          body: TabBarView(
            children: [
              _buildUserList(followers, "No Followers.."),
              _buildUserList(following, "No Following.."),
            ],
          ),
        ));
  }

  // build user list, given s list of profiles
  Widget _buildUserList(List<UserProfile> userList, String emptyMessage) {
    return userList.isEmpty
        ?

        // empty message if there are no users
        Center(
            child: Text(emptyMessage),
          )
        :

        // User List
        ListView.builder(
            itemCount: userList.length,
            itemBuilder: (context, index) {
              // get each user
              final user = userList[index];

              // return as a user list tile
              return MyUserTile(user: user);
            },
          );
  }
}
