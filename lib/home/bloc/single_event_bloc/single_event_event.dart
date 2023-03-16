part of 'single_event_bloc.dart';

class SingleEventEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CheckStatus extends SingleEventEvent {}

class ToggleFav extends SingleEventEvent {
  final bool fav;
  ToggleFav(this.fav);
}

class FetchEvent extends SingleEventEvent {}
