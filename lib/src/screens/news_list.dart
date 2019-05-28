import 'package:flutter/material.dart';
import 'dart:async';
import '../blocs/stories_provider.dart';
import '../widgets/news_list_tile.dart';
import '../widgets/refresh.dart';

class NewsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of((context));
    bloc.fetchTopIds(); // this is bad, temporary
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Top News'),
      ),
      body: buildList(bloc),
    );
  }

//  Widget buildList() {
//    return ListView.builder(itemBuilder: (context, int index) { //item builder automatically figures out how much will fit on a screen based on the height
//      return FutureBuilder(
//        future: getFuture(),
//        builder: (context, snapshot) {
//          return Container(
//            height: 80.0,
//              child: snapshot.hasData
//                  ? Text('Im visible $index')
//                  : Text('I havent fetched data yet'),
//          );
//        },
//      )
//    }, itemCount: 1000);
//  }

  Widget buildList(StoriesBloc bloc) {
    return StreamBuilder(
      stream: bloc.topIds,
      builder: (context, AsyncSnapshot<List<int>> snapshot) {
        if(!snapshot.hasData) {
          return Center(
            child:CircularProgressIndicator(),
          );
        }
        return Refresh(
          child: ListView.builder(itemBuilder: (context, int index){
//          return Text('${snapshot.data[index]}');
            bloc.fetchItem(snapshot.data[index]);
            return NewsListTile(
              itemId: snapshot.data[index],
            );
          }, itemCount: snapshot.data.length,)
        );
      },
    );
  }
  getFuture() {
    return Future.delayed(Duration(seconds: 2), () => 'hi',);
  }
}