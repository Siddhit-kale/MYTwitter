import 'package:flutter/material.dart';
import 'package:mytwitter/components/my_user_tile.dart';
import 'package:mytwitter/services/database/database_provider.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // text controller
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // provider
    final databaseProvider =
        Provider.of<DatabaseProvider>(context, listen: false);
    final listeningProvider = Provider.of<DatabaseProvider>(context);

    // scaffold
    return Scaffold(
      // appbar
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: "Search Users..",
            hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
            border: InputBorder.none,
          ),

          // search will begin after each new character has been type
          onChanged: (Value) {
            // search user
            if (Value.isNotEmpty) {
              databaseProvider.searchUsers(Value);
            }

            // clear result
            else {
              databaseProvider.searchUsers("");
            }
          },
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,

      // body
      body: listeningProvider.searchResult.isEmpty
          ?

          // no user found..
          Center(
              child: Text("No Users found..."),
            )
          :

          // userFound
          ListView.builder(
            itemCount: listeningProvider.searchResult.length,
            itemBuilder: (context, index) {
              // get each user search result
              final user = listeningProvider.searchResult[index];

              // return as a user tile
              return MyUserTile(user: user);
            }),
    );
  }
}
