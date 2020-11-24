part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class ScanPicture extends HomeEvent {
  final bool barcodeScan;

  ScanPicture({@required this.barcodeScan});
  @override
  List<Object> get props => [barcodeScan];
}

class MenuStatsEvent extends HomeEvent {
  @override
  List<Object> get props => [];
}

class MenuMapEvent extends HomeEvent {
  @override
  List<Object> get props => [];
}

class MenuChatEvent extends HomeEvent {
  @override
  List<Object> get props => [];
}

class SingleChatEvent extends HomeEvent {
  final Map<String, dynamic> userName;

  SingleChatEvent({@required this.userName});

  @override
  List<Object> get props => [];
}

class LoadSpotifyStatsEvent extends HomeEvent {
  @override
  List<Object> get props => [];
}
