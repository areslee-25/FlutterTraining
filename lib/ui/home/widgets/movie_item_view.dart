import 'package:flutter/material.dart';
import 'package:untitled/base/base_adapter.dart';
import 'package:untitled/data/model/movie.dart';
import 'package:untitled/utils/extension/image_etx.dart';
import 'package:untitled/utils/extension/size_ext.dart';
import 'package:untitled/utils/resource/color_app.dart';

enum MovieItemType { horizontal, horizontalNoName, verticalFullWidth }

class MovieItemCell extends BaseItemCell<Movie> {
  final MovieItemType itemType;

  static const double _padding = 10;

  MovieItemCell(this.itemType, Movie data, Function(Movie) onTap)
      : super(data, onTap);

  @override
  Widget buildItem(BuildContext context, Movie data) {
    switch (itemType) {
      case MovieItemType.horizontal:
        return _buildHorizontal(context, data);
      case MovieItemType.horizontalNoName:
        return _buildHorizontalNoName(data);
      case MovieItemType.verticalFullWidth:
        return _buildVerticalFullWidth(context, data);
    }
  }

  Widget _buildHorizontal(BuildContext context, Movie movie) {
    const double imageRatio = 210 / 140;
    final double screenWidth = getScreenWidth(context);
    final double itemW = screenWidth * 140 / 375;
    final double itemH = itemW * imageRatio;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: _padding),
      width: itemW,
      height: itemH,
      child: Column(children: [
        AspectRatio(
          aspectRatio: 140 / 210,
          child: PhysicalModel(
            color: Colors.transparent,
            elevation: 10,
            shadowColor: Colors.black,
            borderRadius: BorderRadius.circular(24),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Hero(
                tag: movie.id,
                child: buildImage(movie.posterUrl),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            child: Text(
              movie.title.toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                height: 1.3,
                fontSize: 15,
                color: ColorApp.color_text_33,
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _buildHorizontalNoName(Movie movie) {
    return PhysicalModel(
      color: Colors.transparent,
      elevation: 10,
      shadowColor: Colors.black,
      borderRadius: BorderRadius.circular(24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Stack(
          children: [
            buildImage(movie.posterUrl),
            Align(
              alignment: Alignment.topRight,
              child: buildAverage(movie),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalFullWidth(BuildContext context, Movie movie) {
    final double imgHeight = 160 / 335 * getScreenWidth(context);
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: _padding * 2, vertical: _padding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            height: imgHeight,
            child: PhysicalModel(
              shape: BoxShape.rectangle,
              clipBehavior: Clip.antiAlias,
              color: Colors.black,
              elevation: 20,
              shadowColor: Colors.black,
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: buildImage(movie.backdropUrl, BoxFit.cover),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: buildAverage(movie),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            data.title.toUpperCase(),
            textAlign: TextAlign.left,
            style: TextStyle(
              height: 1.3,
              fontSize: 15,
              color: ColorApp.color_text_33,
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildAverage(Movie movie) {
    return Container(
      margin: const EdgeInsets.only(top: 10, right: 10),
      width: 32,
      height: 32,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: const BoxDecoration(
            gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(249, 159, 0, 1),
                  Color.fromRGBO(219, 48, 105, 1),
                ]),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                movie.firstAverage(),
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
              Text(
                '.',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
              Text(
                movie.lastAverage(),
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
