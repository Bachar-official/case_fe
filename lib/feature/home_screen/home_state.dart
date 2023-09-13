import 'package:case_fe/const/theme.dart';
import 'package:flutter/material.dart';

@immutable
class HomeState {
  final int pageNumber;

  const HomeState({required this.pageNumber});

  const HomeState.initial() : pageNumber = 0;

  HomeState copyWith({int? pageNumber, ColorTheme? theme}) =>
      HomeState(pageNumber: pageNumber ?? this.pageNumber);
}
