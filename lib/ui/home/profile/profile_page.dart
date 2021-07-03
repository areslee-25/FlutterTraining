import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:untitled/base/base_page.dart';
import 'package:untitled/data/model/user.dart';
import 'package:untitled/ui/home/profile/profile_bloc.dart';
import 'package:untitled/utils/extension/size_ext.dart';
import 'package:untitled/utils/resource/image_app.dart';

class ProfilePage extends BaseStateFul {
  const ProfilePage({Key? key}) : super(key: key);

  static const String routeName = "/profile";

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends BaseBlocState<ProfilePage, ProfileBloc> {
  @override
  void init() {}

  @override
  Widget builder(BuildContext context) {
    final double ratio = getRatio(context);
    return Scaffold(
      body: StreamBuilder(
        stream: bloc.user$,
        builder: (context, snapshot) {
          User? user;
          if (snapshot.hasData) {
            user = snapshot.data as User;
          }
          final String avatarUrl = user?.avatar ?? "";

          return Stack(
            children: [
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 368 * ratio,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: FractionalOffset(0.5, 0.5),
                        end: FractionalOffset(1.0, 1.0),
                        colors: [
                          Color.fromRGBO(249, 159, 0, 1),
                          Color.fromRGBO(219, 48, 105, 1),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                height: 315 * ratio,
                margin: EdgeInsets.fromLTRB(0, 143 * ratio, 0, 0),
                child: Stack(
                  children: [
                    Center(
                      child: Image.asset(
                        ImageApp.ic_logo,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        width: 110 * ratio,
                        height: 110 * ratio,
                        child: Image.asset(
                          ImageApp.bg_profile,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
