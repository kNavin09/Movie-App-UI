import 'package:flutter/material.dart';

class CommanTab extends StatefulWidget {
  final Widget child;
  const CommanTab({required this.child, Key? key}) : super(key: key);

  @override
  _CommanTabState createState() => _CommanTabState();
}

class _CommanTabState extends State<CommanTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
