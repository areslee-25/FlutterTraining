import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:untitled/base/base_bloc.dart';
import 'package:untitled/data/source/remote/repository/movie_repository.dart';
import 'package:untitled/utils/disposeBag/dispose_bag.dart';

import 'search_sate.dart';

class SearchBloc extends BaseBloc<SearchState> {
  final Sink<String> onTextChanged;
  final Stream<SearchState> searchStream;

  SearchBloc._({
    required DisposeBag disposeBag,
    required this.onTextChanged,
    required this.searchStream,
  }) : super(disposeBag, SearchEmpty());

  factory SearchBloc(MovieRepository movieRepository) {
    // ignore: close_sinks
    final onTextChanged = PublishSubject<String>();

    final searchStream = onTextChanged
        .distinct()
        .debounceTime(const Duration(milliseconds: 350))
        .switchMap<SearchState>((String term) => _search(term, movieRepository))
        .startWith(SearchNoTerm());

    final controller = [onTextChanged];
    final streams = [searchStream.share()];

    return SearchBloc._(
      disposeBag: DisposeBag([...controller, ...streams]),
      onTextChanged: onTextChanged,
      searchStream: searchStream,
    );
  }

  static Stream<SearchState> _search(
          String term, MovieRepository movieRepository) =>
      term.isEmpty
          ? Stream.value(SearchNoTerm())
          : Rx.fromCallable(() => movieRepository.searchMovie(term, 1))
              .map((result) =>
                  result.isEmpty ? SearchEmpty() : SearchResult(result))
              .startWith(SearchLoading())
              .onErrorReturn(SearchError());
}
