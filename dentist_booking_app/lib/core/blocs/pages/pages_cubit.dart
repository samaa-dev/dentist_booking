import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pages_cubit.freezed.dart';
part 'pages_state.dart';

class PagesCubit extends Cubit<PagesState> {
  PagesCubit() : super(const PagesState.initial());

  void updatePage({required int currentPageIndex, Map<String, dynamic>? data}) {
    emit(PagesState.changed(
      currentPageIndex: currentPageIndex,
      data: data,
    ));
  }
}
