import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:secpasscrypt/feature/data/create/create_screen.dart';
import 'package:secpasscrypt/feature/data/edit/edit_screen.dart';
import 'package:secpasscrypt/feature/data/list/list_bloc.dart';
import 'package:secpasscrypt/feature/login/setup/setup_screen.dart';
import 'package:secpasscrypt/feature/navigation/navigation.dart';
import 'package:secpasscrypt/time_lock/time_lock_screen.dart';

class ListScreen extends StatefulWidget {
  static const route = "/data/list";

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final _bloc = ListBloc();

  @override
  Widget build(BuildContext context) {
    return _buildScreen(context);
  }

  Widget _buildScreen(BuildContext context) {
    return TimeLockScreen(
      child: BlocListener(
        cubit: _bloc,
        listener: (context, state) {
          if (state is ConfirmSignOutState) {
            _showSignOutDialog(context);
          }
          if (state is SignOutState) {
            pushReplacementNamed(context, SetupScreen.route);
          }
        },
        child: BlocBuilder(
          cubit: _bloc..add(LoadEntries()),
          builder: (context, state) {
            return IgnorePointer(
              ignoring: state is LoadingList,
              child: Scaffold(
                appBar: _buildAppBar(context, state),
                body: _buildBody(context, state),
                floatingActionButton: _buildAddButton(context),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("SecPassCrypt"),
          content: Text("Are you sure you want to logout? All data will be lost."),
          actions: <Widget>[
            new FlatButton(
              child: Text("Cancel"),
              onPressed: () {
                _bloc.add(AbandonSignOutEvent());
                popScreen(context);
              },
            ),
            new FlatButton(
              child: Text("Okey"),
              onPressed: () {
                _bloc.add(ConfirmSignOutEvent());
                popScreen(context);
              },
            )
          ],
        );
      },
    );
  }

  Widget _buildAppBar(BuildContext context, ListState state) {
    return AppBar(
      title: Text("SecPassCrypt"),
      actions: <Widget>[
        IgnorePointer(
          ignoring: state is LoadingList,
          child: IconButton(
            icon: FaIcon(FontAwesomeIcons.signOutAlt),
            onPressed: () {
              _bloc.add(SignOutEvent());
            },
          ),
        )
      ],
    );
  }

  Widget _buildBody(BuildContext context, ListState state) {
    final entries = state.entries ?? <EntryWrapper>[];
    return LoadingOverlay(
      isLoading: state is LoadingList,
      child: ListView.builder(
        itemCount: entries.length,
        itemBuilder: (context, index) {
          return _buildItem(context, entries[index]);
        },
        padding: EdgeInsets.only(top: 4.0, bottom: 56.0),
      ),
    );
  }

  Widget _buildItem(BuildContext context, EntryWrapper entry) {
    final textToDisplay = (entry.isPlainText) ? entry.entry.plainText : entry.entry.encryptedText;
    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 4.0,
      child: InkWell(
        onTap: () {
          _bloc.add(ToggleEntryVisibility(entry: entry.entry));
        },
        child: Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(textToDisplay),
              ),
            ),
            Column(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit, color: Theme.of(context).accentColor,),
                  onPressed: () async {
                    await pushNamed(context, EditScreen.route, arguments: EditScreenArguments(entry.entry));
                    _bloc.add(LoadEntries());
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red,),
                  onPressed: () async {
                    _bloc.add(RemoveEntry(entry: entry.entry));
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return FloatingActionButton(
      heroTag: "Create",
      onPressed: () async {
        await pushNamed(context, CreateScreen.route);
        _bloc.add(LoadEntries());
      },
      child: Icon(Icons.add),
    );
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }
}
