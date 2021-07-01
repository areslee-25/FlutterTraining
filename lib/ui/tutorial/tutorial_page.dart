import 'package:flutter/material.dart';
import 'package:untitled/base/base_page.dart';
import 'package:untitled/ui/login/login_page.dart';
import 'package:untitled/utils/extension/size_ext.dart';
import 'package:untitled/utils/navigate_utils.dart';

class TutorialPage extends BaseStateFul {
  const TutorialPage({Key? key}) : super(key: key);

  static const String routeName = "/tutorial";

  @override
  _TutorialPageState createState() => _TutorialPageState();
}

class _TutorialPageState extends BaseState<TutorialPage> {
  String getTitle() => _titleList[_currentPage];
  static const List<String> _titleList = [
    "Get the first\nMovie &TV\ninformation",
    "Know the movie\nis not worth\nWatching",
    "Real-time\nupdates movie\nTrailer"
  ];

  String getTitleBtn() => _titleBtnList[_currentPage];
  static const List<String> _titleBtnList = ["Next", "Next", "Get Stared"];

  late final PageController _pageController;
  var _currentPage = 0;
  var _isLastPage = false;

  @override
  void init() {
    _pageController = PageController(initialPage: 0);
    _pageController.addListener(() {
      final int? page = _pageController.page?.round().toInt();
      if (page != null && page != _currentPage) {
        print(page);
        setState(() {
          _currentPage = page;
          _isLastPage = page == _titleBtnList.length - 1;
        });
      }
    });
  }

  @override
  Widget builder(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: Stack(children: [
          _buildPageController(),
          _buildContent(),
        ]),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildPageController() {
    return PageView(
        scrollDirection: Axis.horizontal,
        controller: _pageController,
        children: [
          Stack(
            children: [
              Container(color: Colors.black),
              Align(
                alignment: Alignment.topCenter,
                child: Image.asset('assets/images/tutorial1.png',
                    fit: BoxFit.cover),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: FractionalOffset(0.0, 0.5),
                      end: FractionalOffset(0.5, 1.0),
                      colors: [
                        Color.fromRGBO(245, 144, 14, 0.17),
                        Color.fromRGBO(219, 49, 103, 1)
                      ]),
                ),
              )
            ],
          ),
          Stack(
            children: [
              Container(color: Colors.white),
              Align(
                alignment: Alignment.topCenter,
                child: Image.asset('assets/images/tutorial2.png',
                    fit: BoxFit.cover),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: FractionalOffset(0.5, 0.5),
                      end: FractionalOffset(1.0, 1.0),
                      colors: [
                        Color.fromRGBO(245, 213, 71, 0.0),
                        Color.fromRGBO(245, 213, 71, 1)
                      ]),
                ),
              )
            ],
          ),
          Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Image.asset('assets/images/tutorial3.png',
                    fit: BoxFit.cover),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: FractionalOffset(0.0, 0.0),
                      end: FractionalOffset(0.5, 0.7),
                      colors: [
                        Color.fromRGBO(52, 92, 197, 0.0),
                        Color.fromRGBO(20, 34, 70, 1)
                      ]),
                ),
              )
            ],
          )
        ]);
  }

  Widget _buildContent() {
    return Container(
      alignment: Alignment.bottomCenter,
      margin: EdgeInsets.only(bottom: getScreenHeight(context) * 0.12),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(
          getTitle(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 34,
            height: 1.3,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 16),
        _buildDots(),
        SizedBox(height: 56),
        _buildButton()
      ]),
    );
  }

  Widget _buildDots() {
    return Container(
      width: 88,
      height: 16,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        for (var i = 0; i < _titleList.length; i++)
          Opacity(
            opacity: i == _currentPage ? 1 : 0.4,
            child: Image.asset('assets/images/logo.png', fit: BoxFit.fitHeight),
          )
      ]),
    );
  }

  Widget _buildButton() {
    final double width = 192;
    final double height = 54;
    final Color borderColor = _isLastPage ? Colors.transparent : Colors.white;
    final BorderRadius _borderRadius = BorderRadius.circular(height / 2);

    return ClipRRect(
      borderRadius: _borderRadius,
      child: Stack(children: [
        Visibility(
          visible: _isLastPage,
          child: Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: FractionalOffset(0.0, 0.5),
                  end: FractionalOffset(1.0, 1.0),
                  colors: [
                    Color.fromRGBO(249, 159, 0, 1),
                    Color.fromRGBO(219, 48, 105, 1)
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: width,
          height: height,
          child: TextButton(
            onPressed: () {
              _nextPage(context);
            },
            style: ButtonStyle(
                shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                  borderRadius: _borderRadius,
                  side: BorderSide(color: borderColor)),
            )),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  getTitleBtn(),
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      color: Colors.white),
                ),
                Visibility(visible: !_isLastPage, child: SizedBox(width: 12)),
                Visibility(
                  visible: !_isLastPage,
                  child: SizedBox(
                    child: Icon(Icons.arrow_forward_sharp, color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        )
      ]),
    );
  }

  void _nextPage(BuildContext context) {
    if (_isLastPage) {
      NavigateUtils.pushNamedToRoot(context, LoginPage.routeName);
      return;
    }
    _pageController.animateToPage(_currentPage + 1,
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }
}
