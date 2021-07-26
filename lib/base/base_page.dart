import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/base/base_bloc.dart';
import 'package:untitled/data/source/remote/api/error/app_error.dart';
import 'package:untitled/utils/disposeBag/dispose_bag.dart';
import 'package:untitled/utils/navigate_utils.dart';
import 'package:untitled/utils/utils.dart';

abstract class BaseStateLess extends StatelessWidget {
  const BaseStateLess({Key? key}) : super(key: key);
}

abstract class BaseStateFul extends StatefulWidget {
  const BaseStateFul({Key? key}) : super(key: key);
}

abstract class BaseState<T extends BaseStateFul> extends State<T> {
  void init();

  Widget builder(BuildContext context);

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return builder(context);
  }
}

abstract class BaseBlocState<T extends BaseStateFul, B extends BaseBloc>
    extends State<T> {
  void init();

  late B? _bloc;

  B get bloc => _bloc!;

  DisposeBag get disposeBag => bloc.disposeBag;

  Widget builder(BuildContext context);

  @override
  void initState() {
    super.initState();
    print('-------------------------------->');
    print('InitState $T, $B');

    final B? providerB = context.read<B>();
    if (providerB != null) {
      _bloc = providerB;
      _bloc!
        ..errorStream.listen(handleError).disposeBy(disposeBag)
        ..loadingStream.listen(handleLoading).disposeBy(disposeBag);
    }

    init();
  }

  @override
  void dispose() {
    print('<--------------------------------');
    print('Destroy: Dispose $T');
    _bloc?.dispose();
    _bloc = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return builder(context);
  }

  void handleError(Object error) {
    if (error is AppError) {
      showDialog(error.message, () => popWidget());
    } else {
      showSnackBar(error.toString());
    }
  }

  void handleLoading(bool isLoading) {
    if (isLoading) {
      showLoading();
    } else {
      hideLoading();
    }
  }

  void showLoading() => context.showLoading();

  void hideLoading() => popWidget();

  void showSnackBar(String message) => context.showSnackBar(message);

  void showDialog(String message, VoidCallback action) =>
      context.showAlertDialog(message, action);

  void popWidget() => NavigateUtils.pop(context, rootNavigator: true);
}
