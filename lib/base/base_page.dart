import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/base/base_bloc.dart';

abstract class BaseStateLess extends StatelessWidget {
  const BaseStateLess({Key? key}) : super(key: key);
}

abstract class BaseStateFul extends StatefulWidget {
  const BaseStateFul({Key? key}) : super(key: key);
}

abstract class BaseState<T extends BaseStateFul> extends State<T> {
  void init();

  Widget buildUI(BuildContext context);

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return buildUI(context);
  }
}

abstract class BaseBlocState<T extends BaseStateFul, B extends BaseBloc>
    extends State<T> {
  void init();

  late B bloc;

  Widget buildUI(BuildContext context);

  @override
  void initState() {
    super.initState();
    print('--------------------------------');
    print('initState $T, $B');
    bloc = BlocProvider.of<B>(context);
    init();
  }

  @override
  void dispose() async {
    print('--------------------------------');
    print('Dispose $T');
    bloc.onClear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildUI(context);
  }
}
