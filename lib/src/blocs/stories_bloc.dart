import 'package:rxdart/rxdart.dart';
import '../models/item_model.dart';
import '../resources/repository.dart';
import 'dart:async';

class StoriesBloc {
  final _repository = Repository();
  final _topIds = PublishSubject<List<int>>();
  final _itemsOutput = BehaviorSubject<Map<int, Future<ItemModel>>>();
  final _itemsFetcher = PublishSubject<int>();

//  Observable<Map<int, Future<ItemModel>>> items;
  // Getters to Streams

  Observable<List <int>> get topIds => _topIds.stream;
  Observable<Map<int, Future<ItemModel>>> get items => _itemsOutput.stream;

  // Getters to SInks

  Function(int) get fetchItem => _itemsFetcher.sink.add;


  StoriesBloc() {
//    items = _items.stream.transform((_itemsTransformer())); // in the constructor so only one instance of _itemsTransformer is created
  _itemsFetcher.stream.transform(_itemsTransformer()).pipe(_itemsOutput); // pipe takes a source and forwards it out to the destination
  }

  fetchTopIds() async {
    final ids = await _repository.fetchTopIds();
    _topIds.sink.add(ids);
  }

  clearCache() {
    return _repository.clearCache();
  }

  _itemsTransformer() {
    return ScanStreamTransformer(
        (Map<int, Future<ItemModel>> cache, int id, index) {
          print(index);
          // invoked every time a new element comes in the stream
          cache[id] = _repository.fetchItem(id);
          return cache; //important return cache
        },
      <int, Future<ItemModel>>{},
    );
  }

   dispose() {
    _topIds.close();
    _itemsFetcher.close();
    _itemsOutput.close();
  }
}