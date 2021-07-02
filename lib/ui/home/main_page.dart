import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/base/base_page.dart';
import 'package:untitled/data/source/repository.dart';
import 'package:untitled/ui/home/main_bloc.dart';
import 'package:untitled/ui/home/movie/movie_bloc.dart';
import 'package:untitled/ui/home/nav_scaffold.dart';
import 'package:untitled/ui/home/tv/tv_bloc.dart';
import 'package:untitled/ui/home/tv/tv_page.dart';
import 'package:untitled/utils/resource/string_app.dart';

import 'movie/movie_page.dart';

class MainPage extends BaseStateFul {
  const MainPage({Key? key}) : super(key: key);

  static const String routeName = "/main";

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends BaseBlocState<MainPage, MainBloc> {
  static final movieRoutes = <String, NavigationWidgetBuilder>{
    Navigator.defaultRouteName: (context, setting) {
      return Provider(
        create: (context) => MovieBloc(context.read<MovieRepository>()),
        child: MoviePage(),
      );
    },
  };

  static final tvRoutes = <String, NavigationWidgetBuilder>{
    Navigator.defaultRouteName: (context, setting) {
      return Provider(
        create: (context) => TvBloc(context.read<MovieRepository>()),
        child: TvPage(),
      );
    },
  };

  @override
  void init() {}

  @override
  Widget builder(BuildContext context) {
    return NavigationScaffold(
      barItems: [
        BottomNavigationBarItem(
          icon: Icon(Icons.movie),
          label: StringApp.movies,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.tv),
          label: StringApp.tv,
        ),
      ],
      navBuilders: [
        (context, settings) => movieRoutes[settings.name]!(context, settings),
        (context, settings) => tvRoutes[settings.name]!(context, settings),
      ],
    );
  }
}
