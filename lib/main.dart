import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/data/source/local/local.dart';
import 'package:untitled/data/source/remote/repository/token_repository.dart';
import 'package:untitled/ui/home/main_bloc.dart';
import 'package:untitled/ui/home/main_page.dart';
import 'package:untitled/ui/home/video/video_page.dart';
import 'package:untitled/ui/login/login_bloc.dart';
import 'package:untitled/ui/login/login_page.dart';
import 'package:untitled/ui/search/search_bloc.dart';
import 'package:untitled/ui/search/search_page.dart';
import 'package:untitled/ui/splash/splash_page.dart';
import 'package:untitled/ui/tutorial/tutorial_page.dart';

import 'data/model/base_model.dart';
import 'data/source/remote/remote.dart';
import 'ui/home/detail/movie_detail_bloc.dart';
import 'ui/home/detail/movie_detail_page.dart';

void main() {
  final apiService = ApiService();
  final sharePrefsApi = SharedPrefsImpl();
  final userLocalSource = UserLocalSourceImpl(sharePrefsApi);

  final movieRepository = MovieRepositoryImpl(apiService);
  final userRepository = UserRepositoryImpl(apiService);
  final tokenRepository = TokenRepositoryImpl(userLocalSource);

  final repositoryProviders = [
    Provider<ApiService>.value(value: apiService),
    Provider<MovieRepository>.value(value: movieRepository),
    Provider<UserRepository>.value(value: userRepository),
    Provider<TokenRepository>.value(value: tokenRepository),
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
      LoginPage.routeName: (context) {
        return Provider(
          create: (context) => LoginBloc(
            context.read<UserRepository>(),
            context.read<TokenRepository>(),
          ),
          child: LoginPage(),
        );
      },
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
          create: (context) =>
              MovieDetailBloc(context.read<MovieRepository>(), movie),
          child: MovieDetailPage(movie: movie),
        );
      },
      VideoPage.routeName: (context) {
        Video video = ModalRoute.of(context)?.settings.arguments as Video;
        return VideoPage(video: video);
      },
    };

    return Provider<Map<String, WidgetBuilder>>.value(
      value: routes,
      child: MaterialApp(
        theme: ThemeData(primarySwatch: Colors.blue),
        home: SplashPage(),
        routes: routes,
      ),
    );
  }
}
