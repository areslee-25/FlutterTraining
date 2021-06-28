import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/data/source/remote/AppClient.dart';
import 'package:untitled/ui/home/main_bloc.dart';
import 'package:untitled/ui/home/main_page.dart';
import 'package:untitled/ui/search/search_bloc.dart';
import 'package:untitled/ui/search/search_page.dart';
import 'package:untitled/ui/splash/splash_page.dart';
import 'package:untitled/ui/tutorial/tutorial_page.dart';

import 'data/model/movie.dart';
import 'data/source/remote/repository/movie_repository.dart';
import 'ui/home/detail/movie_detail_bloc.dart';
import 'ui/home/detail/movie_detail_page.dart';

void main() {
  final apiService = ApiService();
  final movieRepository = MovieRepositoryImpl(apiService);

  final repositoryProviders = [
    Provider<ApiService>.value(value: apiService),
    Provider<MovieRepository>.value(value: movieRepository),
  ];

  runApp(MultiProvider(
    providers: repositoryProviders,
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final routes = <String, WidgetBuilder>{
      SplashPage.routeName: (context) => SplashPage(),
      TutorialPage.routeName: (context) => TutorialPage(),
      MainPage.routeName: (context) {
        return Provider(
          create: (context) => MainBloc(),
          child: MainPage(),
        );
      },
      SearchPage.routeName: (context) {
        return Provider(
          create: (context) => SearchBloc(context.read<MovieRepository>()),
          child: SearchPage(),
        );
      },
      MovieDetailPage.routeName: (context) {
        Movie movie = ModalRoute.of(context)?.settings.arguments as Movie;
        return Provider(
          create: (context) => MovieDetailBloc(),
          child: MovieDetailPage(movie: movie),
        );
      }
    };

    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashPage(),
      routes: routes,
    );
  }
}
