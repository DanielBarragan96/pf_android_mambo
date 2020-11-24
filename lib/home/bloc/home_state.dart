part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();
}

class HomeInitial extends HomeState {
  @override
  List<Object> get props => [];
}

class Error extends HomeState {
  @override
  List<Object> get props => [];
}

class Results extends HomeState {
  final String result;
  final File chosenImage;

  Results({
    @required this.result,
    @required this.chosenImage,
  });
  @override
  List<Object> get props => [result, chosenImage];
}

class MenuStatsState extends HomeState {
  final List<Artist> topArtists;
  final List<Track> topTracks;

  MenuStatsState({@required this.topTracks,@required this.topArtists});

  @override
  List<Object> get props => [topTracks,topArtists];
}

class MenuMapState extends HomeState {
  @override
  List<Object> get props => [];
}

class MenuChatState extends HomeState {
  @override
  List<Object> get props => [];
}

class SingleChatState extends HomeState {
  final Map<String, dynamic> userName;

  SingleChatState({@required this.userName});
  @override
  List<Object> get props => [];
}
