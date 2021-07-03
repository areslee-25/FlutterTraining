import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'package:untitled/base/base_page.dart';
import 'package:untitled/data/model/movie.dart';
import 'package:untitled/ui/home/tv/tv_bloc.dart';
import 'package:untitled/ui/home/widgets/movie_item_view.dart';
import 'package:untitled/ui/home/widgets/now_movie_adapter.dart';
import 'package:untitled/ui/search/search_page.dart';
import 'package:untitled/utils/navigate_utils.dart';
import 'package:untitled/utils/resource/color_app.dart';
import 'package:untitled/utils/resource/string_app.dart';

import '../nav_scaffold.dart';

class TvPage extends BaseStateFul {
  const TvPage({Key? key}) : super(key: key);

  static const String routeName = "/tv";

  @override
  _TvPageState createState() => _TvPageState();
}

class _TvPageState extends BaseBlocState<TvPage, TvBloc> {
  @override
  void init() {}

  @override
  Widget builder(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            HeaderApp(1, () {
              NavigateUtils.pushNamed(
                context,
                SearchPage.routeName,
                rootNavigator: true,
              );
            }),
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return StreamBuilder<Tuple2<List<Movie>, List<Movie>>>(
      stream: bloc.dataList,
      builder: (context, snapshot) {
        final data = snapshot.data;
        final nowMovieList = data?.item1 ?? [];
        final popularMovieList = data?.item2 ?? [];

        final nowItemCount = 1;
        final popularItemCount = popularMovieList.length + 1;
        final itemCount = nowItemCount + popularItemCount;

        if (itemCount == 0) {
          return SizedBox();
        }

        return ListView.builder(
          itemCount: itemCount,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return NowMovieAdapter(nowMovieList);
            }
            if (popularMovieList.isEmpty) {
              return const SizedBox();
            }
            if (index == 1) {
              return _buildPopularTitleHeader();
            }
            return MovieItemCell(MovieItemType.verticalFullWidth,
                popularMovieList[index - 2], (movie) {});
          },
        );
      },
    );
  }

  Widget _buildPopularTitleHeader() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      width: double.infinity,
      child: Text(
        StringApp.popular,
        textAlign: TextAlign.start,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.normal,
          color: ColorApp.color_text_102,
        ),
      ),
    );
  }
}
