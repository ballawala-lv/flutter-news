import 'package:flutter/material.dart';
import 'screens/news_list.dart';
import 'blocs/stories_provider.dart';
import 'blocs/comments_provider.dart';
import 'screens/news_details.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CommentsProvider(
      child:StoriesProvider(
        child: MaterialApp(
          title: 'News!',
//        home: NewsList(),
          onGenerateRoute: routes,
        ),
      ),
    );
  }

  Route routes(RouteSettings settings) {
    if(settings.name == '/') {
      return MaterialPageRoute(
          builder: (context) {
            final storiesBloc = StoriesProvider.of(context);
            storiesBloc.fetchTopIds();
            return NewsList();
          }
      );
    }
    else {
      return MaterialPageRoute(
        builder: (context){
          final commentsBloc = CommentsProvider.of(context);
          final itemId = int.parse(settings.name.replaceFirst('/', '')); // we pass in route like /53 so we need to parse out the /
          commentsBloc.fetchItemWIthComments(itemId);
          return NewsDetail(
            itemId: itemId,
          );
        }
      );
    }

  }
}