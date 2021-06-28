import 'package:untitled/utils/disposeBag/dispose_bag.dart';

abstract class BaseBloc {
  BaseBloc([this.disposeBag]);

  final DisposeBag? disposeBag;

  void onClear() {
    disposeBag?.clear();
  }
}

abstract class BaseState {}

class EmptyState extends BaseState {}

class LoadingState extends BaseState {}
