import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:untitled/base/base_page.dart';
import 'package:untitled/ui/home/main_page.dart';
import 'package:untitled/ui/login/login_bloc.dart';
import 'package:untitled/utils/disposeBag/dispose_bag.dart';
import 'package:untitled/utils/extension/size_ext.dart';
import 'package:untitled/utils/navigate_utils.dart';
import 'package:untitled/utils/resource/color_app.dart';
import 'package:untitled/utils/resource/image_app.dart';
import 'package:untitled/utils/resource/string_app.dart';

class LoginPage extends BaseStateFul {
  static const String routeName = "/login";

  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends BaseBlocState<LoginPage, LoginBloc> {
  @override
  void init() {
    bloc.loginStream.listen((isSuccess) {
      if (isSuccess) {
        hideLoading();
        NavigateUtils.pushNamedToRoot(context, MainPage.routeName);
      }
    }).disposeBy(bloc.disposeBag);
  }

  @override
  Widget builder(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          _buildTopImage(context),
          _buildBottomImage(context),
          _buildContent(context),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Image.asset(ImageApp.bg_login, fit: BoxFit.cover);
  }

  Widget _buildTopImage(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: getPaddingTop(context), right: 40),
      child: AspectRatio(
        aspectRatio: 335 / 272,
        child: Image.asset(ImageApp.top_login, fit: BoxFit.fill),
      ),
    );
  }

  Widget _buildCenterImage(BuildContext context) {
    return SizedBox(
      height: 220 * 375 / getScreenWidth(context),
      child: Center(
        child: Image.asset(ImageApp.center_login, fit: BoxFit.fill),
      ),
    );
  }

  Widget _buildBottomImage(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: getPaddingBottom(context) + 16,
      child: SizedBox(
        height: 74 * 375 / getScreenWidth(context),
        child: Center(
          child: Image.asset(ImageApp.bottom_login, fit: BoxFit.fill),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final height = getScreenHeight(context) -
        getPaddingBottom(context) -
        getPaddingTop(context);
    return SizedBox(
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildCenterImage(context),
          const SizedBox(height: 40),
          _buildUserName(),
          const SizedBox(height: 16),
          _buildPassword(),
          const SizedBox(height: 32),
          _buildLoginBtn(context),
          const SizedBox(height: 16),
          _buildRegisterBtn(context),
        ],
      ),
    );
  }

  Widget _buildUserName() {
    return BuildTextFormField(
      StringApp.name,
      StringApp.enter_name,
      false,
      bloc.userNameChanged,
    );
  }

  Widget _buildPassword() {
    return BuildTextFormField(
      StringApp.password,
      StringApp.enter_password,
      true,
      bloc.passwordChanged,
    );
  }

  Widget _buildLoginBtn(BuildContext context) {
    return _buildButton(
      context,
      StringApp.login,
      [ColorApp.color_93_57_186, ColorApp.color_150_107_222],
      () {
        showLoading();
        bloc.login.add(null);
      },
    );
  }

  Widget _buildRegisterBtn(BuildContext context) {
    return _buildButton(
      context,
      StringApp.sing_up,
      [ColorApp.color_171_95_208, ColorApp.color_213_152_234],
      () {
        bloc.register.add(null);
      },
    );
  }

  Widget _buildButton(BuildContext context, String text, List<Color> colors,
      VoidCallback onPressed) {
    final height = 42 * 375 / getScreenWidth(context);
    final borderRadius = BorderRadius.circular(height / 2);

    return SizedBox(
      height: height,
      child: Center(
        child: AspectRatio(
          aspectRatio: 175 / 42,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: colors,
              ),
            ),
            child: TextButton(
              onPressed: onPressed,
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(borderRadius: borderRadius),
                ),
              ),
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BuildTextFormField extends BaseStateLess {
  final String _labelText;
  final String _hinText;
  final bool _obscureText;
  final ValueChanged<String> _onChanged;

  const BuildTextFormField(
      this._labelText, this._hinText, this._obscureText, this._onChanged);

  final inputBorder = const UnderlineInputBorder(
    borderSide: const BorderSide(color: ColorApp.color_93_57_186),
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32),
      child: TextFormField(
        obscureText: _obscureText,
        cursorColor: ColorApp.color_93_57_186,
        style: const TextStyle(color: ColorApp.color_93_57_186, fontSize: 18),
        decoration: InputDecoration(
          labelText: _labelText,
          labelStyle: const TextStyle(color: ColorApp.main),
          hintText: _hinText,
          hintStyle: const TextStyle(
            color: Colors.black45,
            fontSize: 18,
            fontStyle: FontStyle.italic,
          ),
          enabledBorder: inputBorder,
          focusedBorder: inputBorder,
        ),
        onChanged: _onChanged,
      ),
    );
  }
}
