part of 'pages_cubit.dart';

@freezed
class PagesState with _$PagesState {
  const factory PagesState.initial() = _Initial;
  const factory PagesState.changed({
    required int currentPageIndex,
    Map<String, dynamic>? data,
  }) = _Changed;
}
