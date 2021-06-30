import 'package:untitled/base/base_bloc.dart';
import 'package:untitled/data/model/movie.dart';

class SearchState extends BaseStatus {}

class SearchLoading extends SearchState {}

class SearchError extends SearchState {}

class SearchNoTerm extends SearchState {}

class SearchResult extends SearchState {
  final List<Movie> items;

  SearchResult(this.items);
}

class SearchEmpty extends SearchState {}
