import 'package:flutter/material.dart';

Future<T> pushScreen<T extends Object>(BuildContext context, Widget screen) {
  return Navigator.of(context).push<T>(MaterialPageRoute(builder: (context) => screen));
}

void popScreen<T extends Object>(BuildContext context) {
  Navigator.of(context).pop<T>();
}

void popUntil(BuildContext context, String screenName) {
  Navigator.of(context).popUntil(ModalRoute.withName(screenName));
}

void popToRoot(BuildContext context) {
  popUntil(context, "/");
}

void pushNamed(
    BuildContext context,
    String screenName, {
      Object arguments,
    }) {
  Navigator.of(context).pushNamed(screenName, arguments: arguments);
}

void pushReplacementNamed(
    BuildContext context,
    String screenName, {
      Object arguments,
    }) {
  Navigator.of(context).pushReplacementNamed(screenName, arguments: arguments);
}

void popWithResult<T>(BuildContext context, T value) {
  Navigator.of(context).pop<T>(value);
}

Future<T> pushForResult<T>(BuildContext context, MaterialPageRoute<T> route) async {
  return Navigator.of(context).push(route);
}