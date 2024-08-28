part of 'favorite_songs_bloc.dart';


abstract class FavoriteSongsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FavoriteSongsLoading extends FavoriteSongsState {}

class FavoriteSongsLoaded extends FavoriteSongsState {
  final List<SongEntity> favoriteSongs;

  FavoriteSongsLoaded({required this.favoriteSongs});

  @override
  List<Object?> get props => [favoriteSongs];
}

class FavoriteSongsFailure extends FavoriteSongsState {}
