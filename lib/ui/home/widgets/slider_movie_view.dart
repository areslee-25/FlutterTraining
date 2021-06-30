import 'package:flutter/material.dart';
import 'package:untitled/base/base_page.dart';
import 'package:untitled/data/model/movie.dart';
import 'package:untitled/utils/extension/image_etx.dart';
import 'package:untitled/utils/extension/size_ext.dart';

class SliderMovieView extends BaseStateFul {
  SliderMovieView(this.dataList);

  final List<Movie> dataList;

  int size() => dataList.length - 1;

  @override
  _SliderMovieViewState createState() => _SliderMovieViewState();
}

class _SliderMovieViewState extends BaseState<SliderMovieView> {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void init() {}

  @override
  Widget builder(BuildContext context) {
    if (widget.dataList.isEmpty) {
      return const SizedBox();
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 170 / 320 * getScreenWidth(context),
          child: PageView.builder(
            onPageChanged: _onPageChanged,
            controller: _pageController,
            itemCount: widget.size(),
            itemBuilder: (context, index) {
              return _buildItemSlider(index);
            },
          ),
        ),
        SizedBox(
          height: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.size(),
              (index) => _buildDotNav(index),
            ),
          ),
        ),
      ],
    );
  }

  EdgeInsets _marginSlider(int index) {
    if (index == 0) {
      return EdgeInsets.only(left: 0, right: 10, bottom: 15);
    }
    if (index == widget.size()) {
      return EdgeInsets.only(left: 10, right: 0, bottom: 15);
    }
    return EdgeInsets.only(left: 10, right: 10, bottom: 15);
  }

  Widget _buildItemSlider(int index) {
    return Container(
      margin: _marginSlider(index),
      child: PhysicalModel(
        color: Colors.transparent,
        elevation: 10,
        shadowColor: Colors.black,
        borderRadius: BorderRadius.circular(24),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: buildImage(widget.dataList[index].backdropUrl),
        ),
      ),
    );
  }

  AnimatedContainer _buildDotNav(int index) {
    const color = Color(0XFF6A62B7);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      margin: const EdgeInsets.only(right: 5),
      height: 6,
      width: _currentPage == index ? 24 : 6,
      decoration: BoxDecoration(
        color: _currentPage == index ? color : color.withAlpha(70),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  void _onPageChanged(int position) {
    setState(() {
      _currentPage = position;
    });
  }
}
