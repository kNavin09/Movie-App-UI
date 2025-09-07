import 'package:equatable/equatable.dart';

abstract class BottomNavEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class BottomNavItemSelected extends BottomNavEvent {
  final int index;
  BottomNavItemSelected(this.index);

  @override
  List<Object?> get props => [index];
}
