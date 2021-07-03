import 'package:flutter/material.dart';

Size getScreenSize(BuildContext context) => MediaQuery.of(context).size;

double getScreenWidth(BuildContext context) => getScreenSize(context).width;

double getScreenHeight(BuildContext context) => getScreenSize(context).height;

EdgeInsets getPadding(BuildContext context) => MediaQuery.of(context).padding;

double getPaddingTop(BuildContext context) => getPadding(context).top;

double getPaddingBottom(BuildContext context) => getPadding(context).bottom;

double getRatio(BuildContext context) => 375.0 / getScreenWidth(context);

