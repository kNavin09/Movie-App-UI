import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/bloc/bottom_bar/bottom_event.dart';
import 'package:movie_app/bloc/bottom_bar/bottom_state.dart';


class BottomNavBloc extends Bloc<BottomNavEvent, BottomNavState> {
  BottomNavBloc() : super(const BottomNavState(0)) {
    on<BottomNavItemSelected>((event, emit) {
      emit(BottomNavState(event.index));
    });
  }
}
