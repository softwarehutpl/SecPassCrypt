import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:secpasscrypt/feature/data/create/create_screen.dart';
import 'package:secpasscrypt/feature/data/edit/edit_screen.dart';
import 'package:secpasscrypt/feature/data/list/list_bloc.dart';
import 'package:secpasscrypt/feature/navigation/navigation.dart';

class ListScreen extends StatefulWidget {
  static const route = "/data/list";

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final _bloc = ListBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
      floatingActionButton: _buildAddButton(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder(
      cubit: _bloc..add(LoadEntries()),
      builder: (context, state) {
        final entries = (state is ListLoaded) ? state.entries : <EntryWrapper>[];
        return LoadingOverlay(
          isLoading: state is LoadingList,
          child: ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              return _buildItem(context, entries[index]);
            },
            padding: EdgeInsets.only(top: 32.0, bottom: 56.0),
          ),
        );
      },
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
