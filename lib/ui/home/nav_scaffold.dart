import 'package:flutter/material.dart';
import 'package:untitled/base/base_page.dart';
import 'package:untitled/ui/search/search_page.dart';
import 'package:untitled/utils/navigate_utils.dart';
import 'package:untitled/utils/resource/color_app.dart';
import 'package:untitled/utils/resource/image_app.dart';
import 'package:untitled/utils/resource/string_app.dart';

typedef NavigationWidgetBuilder = Widget Function(BuildContext, RouteSettings);

class NavigationScaffold extends BaseStateFul {
  final List<BottomNavigationBarItem> barItems;
  final List<NavigationWidgetBuilder> navBuilders;

  const NavigationScaffold({
    Key? key,
    required this.barItems,
    required this.navBuilders,
  }) : super(key: key);

  @override
  _NavigationScaffoldState createState() => _NavigationScaffoldState();

  static NavigatorState? of(BuildContext context, {int? newTabIndex}) {
    final appState =
        context.findAncestorStateOfType<_NavigationScaffoldState>();

    if (appState == null) {
      return null;
    }

    final currentIndex = appState.currentIndex;
    final navigatorKeys = appState.navigatorKeys;

    if (newTabIndex != null &&
        newTabIndex != currentIndex &&
        appState.mounted) {
      appState.onItemTapped(newTabIndex);
      return navigatorKeys[newTabIndex].currentState ?? null;
    }

    return navigatorKeys[currentIndex].currentState ?? null;
  }
}

class _NavigationScaffoldState extends BaseState<NavigationScaffold> {
  var currentIndex = 0;
  var navigatorKeys = <GlobalKey<NavigatorState>>[];

  @override
  void init() {
    navigatorKeys = List.generate(
      widget.navBuilders.length,
      (none) => GlobalKey<NavigatorState>(),
    );
  }

  @override
  Widget builder(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: SafeArea(
          top: true,
          bottom: true,
          child: Column(
            children: [
              _buildHeader(),
              Expanded(child: _buildBody()),
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomNav(),
      ),
    );
  }

  Widget _buildBody() {
    return IndexedStack(
      index: currentIndex,
      children: [
        for (int i = 0; i < widget.navBuilders.length; i++)
          Navigator(
            key: navigatorKeys[i],
            onGenerateRoute: (settings) => MaterialPageRoute(
              settings: settings,
              builder: (context) => widget.navBuilders[i](context, settings),
            ),
          ),
      ],
    );
  }

  Widget _buildHeader() => HeaderApp(currentIndex);

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      items: widget.barItems,
      currentIndex: currentIndex,
      selectedItemColor: ColorApp.color_tabBar_selected_text,
      unselectedItemColor: ColorApp.color_tabBar_un_selected_text,
      onTap: onItemTapped,
    );
  }

  Future<bool> _onWillPop() {
    final navigatorState = navigatorKeys[currentIndex].currentState;
    final canPop = navigatorState?.canPop() ?? false;

    if (canPop) {
      navigatorState?.maybePop();
    }

    if (!canPop && currentIndex > 0) {
      onItemTapped(0);
      return Future.value(false);
    }

    return Future.value(canPop);
  }

  void onItemTapped(int index) {
    if (currentIndex == index) {
      navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
      return;
    }
    setState(() => currentIndex = index);
  }
}

class HeaderApp extends BaseStateLess {
  const HeaderApp(this.currentIndex) : super();

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    const double height = 56;
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Row(
        children: [
          SizedBox(width: 20),
          Expanded(
            child: Text(
              _getTitleHeader(),
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  color: ColorApp.color_text_33),
            ),
          ),
          SizedBox(
            height: height,
            width: height,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () {
                NavigateUtils.pushNamed(context, SearchPage.routeName);
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.asset(ImageApp.ic_search, fit: BoxFit.cover),
              ),
            ),
          ),
          SizedBox(width: 8),
        ],
      ),
    );
  }

  String _getTitleHeader() {
    if (currentIndex == 0) {
      return StringApp.movies;
    }
    return StringApp.tv;
  }
}
