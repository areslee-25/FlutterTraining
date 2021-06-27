import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/utils/disposeBag/dispose_bag.dart';

abstract class BaseBloc<T extends BaseState> extends BlocBase<T> {
  BaseBloc([this.disposeBag, T? state]) : super(state ?? EmptyState() as T);

  final DisposeBag? disposeBag;

  void onClear() async {
    close();
    disposeBag?.clear();
  }
}

abstract class BaseState {}

class EmptyState extends BaseState {}

class LoadingState extends BaseState {}
