import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:secpasscrypt/feature/navigation/navigation.dart';
import 'package:secpasscrypt/feature/data/edit/edit_bloc.dart';
import 'package:secpasscrypt/repository/PasswordRepository.dart';

class EditScreenArguments {
  final Password entry;

  EditScreenArguments(this.entry);
}

class EditScreen extends StatefulWidget {
  static const route = "/data/list/edit";
  final Password entry;

  EditScreen(this.entry);

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _bloc = EditBloc();
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textController.text = widget.entry?.plainText ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: _bloc,
      listener: (context, state) {
        if (state is EntryUpdated) {
          popScreen(context);
        }
      },
      child: BlocBuilder(
        cubit: _bloc,
        builder: (context, state) {
         return LoadingOverlay(
           isLoading: state is UpdatingEntry,
           child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildPasswordInput(context),
                _buildSubmit(context),
              ],
            ),
         );
        },
      ),
    );
  }

  Widget _buildPasswordInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
      child: TextFormField(
        controller: _textController,
        minLines: 8,
        maxLines: 16,
        decoration: InputDecoration(
          alignLabelWithHint: true,
          labelText: "Adjust stored text",
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildSubmit(BuildContext context) {
    return Center(
      child: RaisedButton(
          onPressed: () {
            _bloc.add(UpdateEntry(entry: widget.entry.copy(plainText: _textController.text)));
          },
          child: Container(
            child: Text(
              "UPDATE",
              textAlign: TextAlign.center,
            ),
          )
      ),
    );
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }
}
