import 'package:flutter_bloc/flutter_bloc.dart';

class PagesCubit extends Cubit<int> {
  PagesCubit() : super(0);

  void setPage(int index) => emit(index);
}
