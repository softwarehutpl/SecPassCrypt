import 'package:flutter/material.dart';
import 'package:secpasscrypt/feature/data/create/create_screen.dart';
import 'package:secpasscrypt/feature/data/edit/edit_screen.dart';
import 'package:secpasscrypt/feature/navigation/navigation.dart';

class ListScreen extends StatelessWidget {
  static const route = "/data/list";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
      floatingActionButton: _buildAddButton(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return _buildItem(context);
      },
      padding: EdgeInsets.only(top: 32.0, bottom: 56.0),
    );
  }

  Widget _buildItem(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 4.0,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore"
                      " magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea "
                      "commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat"
                      " nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit "
                      "anim id est laborum.",
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit, color: Theme.of(context).accentColor,),
            onPressed: () {
              pushNamed(context, EditScreen.route);
            },
          )
        ],
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return FloatingActionButton(
      heroTag: "Create",
      onPressed: () {
        pushNamed(context, CreateScreen.route);
      },
      child: Icon(Icons.add),
    );
  }
}
