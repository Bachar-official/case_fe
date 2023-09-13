import 'package:case_fe/const/theme.dart';
import 'package:flutter/material.dart';

@immutable
class HomeScreenState {
  final int pageNumber;

  const HomeScreenState({required this.pageNumber});

  const HomeScreenState.initial() : pageNumber = 0;

  HomeScreenState copyWith({int? pageNumber, ColorTheme? theme}) =>
      HomeScreenState(pageNumber: pageNumber ?? this.pageNumber);
}
