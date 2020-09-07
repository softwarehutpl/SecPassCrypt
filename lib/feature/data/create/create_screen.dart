import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:secpasscrypt/feature/data/create/create_bloc.dart' as scb;
import 'package:secpasscrypt/feature/navigation/navigation.dart';
import 'package:secpasscrypt/time_lock/time_lock_screen.dart';

class CreateScreen extends StatefulWidget {
  static const route = "/data/list/create";

  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final scb.CreateBloc _bloc = scb.CreateBloc();
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TimeLockScreen(
      child: BlocListener(
        cubit: _bloc,
        listener: (context, state) {
          if (state is scb.EntryStored) {
            popScreen(context);
          }
        },
        child: BlocBuilder(
          cubit: _bloc,
          builder: (context, state) {
            return LoadingOverlay(
              isLoading: state is scb.StoringEntry,
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
      ),
    );
  }

  Widget _buildPasswordInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
      child: TextFormField(
        minLines: 8,
        maxLines: 16,
        controller: _textController,
        decoration: InputDecoration(
          alignLabelWithHint: true,
          labelText: "Enter text you want to store securely",
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildSubmit(BuildContext context) {
    return Center(
      child: RaisedButton(
          onPressed: () {
            _bloc.add(scb.AddEntry(text: _textController.text));
          },
          child: Container(
            child: Text(
              "ADD",
              textAlign: TextAlign.center,
            ),
          )
      ),
    );
  }

  @override
  void dispose() {
    _bloc.close();
    _textController.dispose();
    super.dispose();
  }
}
