import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/base/base_bloc.dart';

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

  late B _bloc;

  B get bloc => _bloc;

  Widget builder(BuildContext context);

  @override
  void initState() {
    super.initState();
    print('--------------------------------');
    print('initState $T, $B');
    _bloc = context.read<B>();
    init();
  }

  @override
  void dispose() {
    print('--------------------------------');
    print('Dispose $T');
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return builder(context);
  }
}
