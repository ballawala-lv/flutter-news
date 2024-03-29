import 'package:flutter/material.dart';
import 'package:flutter_news/src/blocs/stories_provider.dart';
import '../blocs/stories_bloc.dart';

class Refresh extends StatelessWidget {
  final Widget child;

  Refresh({this.child});

  @override
  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of(context);
    // TODO: implement build
    return RefreshIndicator(
      child: child,
      onRefresh: () async {
        await bloc.clearCache();
        await bloc.fetchTopIds();
      },
    );
  }
}
