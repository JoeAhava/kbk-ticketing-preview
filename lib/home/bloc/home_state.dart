part of 'home_bloc.dart';

class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeLoading extends HomeState {}

class HomeLoadSuccess extends HomeState {
  final HomeData data;

  const HomeLoadSuccess([this.data = const HomeData()]);

  @override
  List<Object> get props => [data];

  @override
  String toString() => 'HomeLoaded { data: $data }';
}

class HomeLoadFailed extends HomeState {
  final String message;

  const HomeLoadFailed(this.message);
}
