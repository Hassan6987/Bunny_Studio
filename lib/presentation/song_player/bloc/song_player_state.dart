part of 'song_player_bloc.dart';


abstract class SongPlayerState extends Equatable {
  const SongPlayerState();

  @override
  List<Object?> get props => [];
}

class SongPlayerLoading extends SongPlayerState {}

class SongPlayerLoaded extends SongPlayerState {
  final Duration position;
  final Duration duration;
  final bool isPlaying;


  const SongPlayerLoaded( {
    required this.position,
    required this.duration,
    required this.isPlaying,
  });

  @override
  List<Object?> get props => [position, duration, isPlaying];
}

class SongPlayerFailure extends SongPlayerState {}
