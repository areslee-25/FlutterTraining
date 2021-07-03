import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'package:untitled/base/base_page.dart';
import 'package:untitled/data/model/movie.dart';
import 'package:untitled/ui/home/movie/movie_bloc.dart';
import 'package:untitled/ui/home/nav_scaffold.dart';
import 'package:untitled/ui/home/widgets/now_movie_adapter.dart';
import 'package:untitled/ui/home/widgets/popular_movie_adapter.dart';
import 'package:untitled/ui/home/widgets/slider_movie_view.dart';
import 'package:untitled/ui/search/search_page.dart';
import 'package:untitled/utils/navigate_utils.dart';

class MoviePage extends BaseStateFul {
  const MoviePage({Key? key}) : super(key: key);

  static const String routeName = "/movie";

  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends BaseBlocState<MoviePage, MovieBloc> {
  @override
  void init() {}

  @override
  Widget builder(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<Tuple3<List<Movie>, List<Movie>, List<Movie>>>(
        stream: bloc.dataList,
        builder: (context, snapshot) {
          final data = snapshot.data;
          return SingleChildScrollView(
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  HeaderApp(0, () {
                    NavigateUtils.pushNamed(
                      context,
                      SearchPage.routeName,
                      rootNavigator: true,
                    );
                  }),
                  SliderMovieView(data?.item1 ?? []),
                  NowMovieAdapter(data?.item2 ?? []),
                  PopularMovieAdapter(data?.item3 ?? []),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
