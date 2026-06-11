import 'package:flutter/material.dart';

/// Keeps vendor tab content alive when switching branches in [StatefulShellRoute].
class VendorTabScaffold extends StatefulWidget {
  const VendorTabScaffold({required this.child, super.key});

  final Widget child;

  @override
  State<VendorTabScaffold> createState() => _VendorTabScaffoldState();
}

class _VendorTabScaffoldState extends State<VendorTabScaffold>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
