import 'package:flutter/material.dart';
import 'package:mytwitter/components/my_bio_box.dart';
import 'package:mytwitter/components/my_follow_button.dart';
import 'package:mytwitter/components/my_input_alert_box.dart';
import 'package:mytwitter/components/my_post_title.dart';
import 'package:mytwitter/components/my_profile_state.dart';
import 'package:mytwitter/models/user.dart';
import 'package:mytwitter/pages/follow_list_page.dart';
import 'package:mytwitter/services/auth/auth_service.dart';
import 'package:mytwitter/services/database/database_provider.dart';
import 'package:provider/provider.dart';

import '../helper/navigate_pages.dart';

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
  late final listenableProvider = Provider.of<DatabaseProvider>(context);
  late final databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);

  // user info
  UserProfile? user;
  String currentUserId = AuthService().getCurrentUid();

  // text controller for bio
  final bioTextController = TextEditingController();

  // loading
  bool _isloading = true;

  // is following state
  bool _isfollwing = false;

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

    // load followers & following for this user
    await databaseProvider.loadUserFollowers(widget.uid);
    await databaseProvider.loadUserFolloing(widget.uid);

    // update Following state
    _isfollwing = databaseProvider.isFollowing(widget.uid);

    // finished loading
    setState(() {
      _isloading = false;
    });
  }

  // show edit bio box
  void _showEditBioBox() {
    showDialog(
        context: context,
        builder: (context) => MyInputAlertBox(
            textEditingController: bioTextController,
            hinttext: "Edit bio...",
            onPressed: saveBio,
            onPressedText: "Save"));
  }

  // save updated bio
  Future<void> saveBio() async {
    // start loading..
    setState(() {
      _isloading = true;
    });

    // update bio
    await databaseProvider.updateBio(bioTextController.text);

    // reload user
    await loadUser();

    // done loading..
    setState(() {
      _isloading = false;
    });
  }

  // toggle follow -> follow / unfollow
  Future<void> toggleFollow() async {
    if (_isfollwing) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Unfollow"),
          content: Text("Are you sure you want to unfollow"),
          actions: [
            // cancel
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),

            TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await databaseProvider.unfollowUser(widget.uid);
                },
                child: const Text("Yes")),
          ],
        ),
      );
    }

    // follow
    else {
      await databaseProvider.followUser(widget.uid);
    }

    // update isfollowing state
    setState(() {
      _isfollwing = !_isfollwing;
    });
  }

  // build ui
  @override
  Widget build(BuildContext context) {
    // get user posts
    final allUserPosts = listenableProvider.filterUserPosts(widget.uid);

    // listen to following & follower count
    final followerCount = listenableProvider.getFollowerCount(widget.uid);
    final followingCount = listenableProvider.getFollowingCount(widget.uid);

    // listen to is following
    _isfollwing = listenableProvider.isFollowing(widget.uid);

    // scaffload
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,

        //app bar
        appBar: AppBar(
          title: Text(_isloading ? '' : user!.name),
          foregroundColor: Theme.of(context).colorScheme.primary,
        ),

        //body
        body: ListView(
          children: [
            // username handler
            Center(
              child: Text(
                _isloading ? '' : '@${user!.username}',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
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
            MyProfileState(
              postCount: allUserPosts.length, 
              followerCount: followerCount, 
              followingCount: followingCount,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FollowListPage(uid: widget.uid,),
                ),
              ),
            ),

          const SizedBox(height: 25),

            // follow / unfollow button

            // only show if the user is viewing someone else's profile
            if (user != null && user!.uid != currentUserId)
              MyFollowButton(
                onPressed: toggleFollow,
                isFollowing: _isfollwing,
              ),

            // edit bio
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Bio",
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),

                  // button
                  // only show edit button if it's current user page
                  if (user != null && user!.uid == currentUserId)
                    GestureDetector(
                      onTap: _showEditBioBox,
                      child: Icon(
                        Icons.settings,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // bio box
            MyBioBox(text: _isloading ? '...' : user!.bio),

            Padding(
              padding: const EdgeInsets.only(left: 25.0, top: 25),
              child: Text(
                "Posts",
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ),

            // list of posts from users
            allUserPosts.isEmpty
                ?

                // user posts is empty
                const Center(
                    child: Text("No posts yet.."),
                  )
                :

                // user posts is not empty
                ListView.builder(
                    itemCount: allUserPosts.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, Index) {
                      // get individual post
                      final post = allUserPosts[Index];

                      // post title ui
                      return MyPostTitle(
                        post: post,
                        onUserTap: () {},
                        onPostTap: () => goPostpage(context, post),
                      );
                    },
                  ),
          ],
        ));
  }
}
