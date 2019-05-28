import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../resources/repository.dart';
import 'dart:async';
import 'package:rxdart/rxdart.dart';

class CommentsBloc {
  final _commentsFetcher = PublishSubject<int>();
  final _commentsOutput = BehaviorSubject<Map<int, Future<ItemModel>>>();
  final _repository = Repository();

  //Streams
  Observable<Map<int, Future<ItemModel>>> get itemWithComments => _commentsOutput.stream;

  //Sinks
  Function(int) get fetchItemWIthComments => _commentsFetcher.sink.add;
  
  CommentsBloc(){
    _commentsFetcher.stream.transform(_commentsTransformer()).pipe(_commentsOutput); 
  }

  _commentsTransformer() {
    return ScanStreamTransformer<int, Map<int, Future<ItemModel>>>(
      (cache, int id, index) {
        print(index);
        cache[id] = _repository.fetchItem(id);
        cache[id].then((ItemModel item) {
          item.kids.forEach((kidId) => fetchItemWIthComments(kidId));
        });
        return cache;
      },
      <int, Future<ItemModel>>{}
    );
  }

  dispose() {
    _commentsFetcher.close();
    _commentsOutput.close();
  }
}