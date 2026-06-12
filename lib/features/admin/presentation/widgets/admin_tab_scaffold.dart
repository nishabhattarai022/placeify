import 'package:flutter/material.dart';

/// Keeps admin tab content alive when switching branches in [StatefulShellRoute].
class AdminTabScaffold extends StatefulWidget {
  const AdminTabScaffold({required this.child, super.key});

  final Widget child;

  @override
  State<AdminTabScaffold> createState() => _AdminTabScaffoldState();
}

class _AdminTabScaffoldState extends State<AdminTabScaffold>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
