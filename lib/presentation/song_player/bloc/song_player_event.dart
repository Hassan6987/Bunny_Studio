part of 'song_player_bloc.dart';

abstract class SongPlayerEvent extends Equatable {
  const SongPlayerEvent();

  @override
  List<Object> get props => [];
}

class LoadSong extends SongPlayerEvent {
  final String url;

  const LoadSong(this.url);

  @override
  List<Object> get props => [url];
}

class PlayOrPauseSong extends SongPlayerEvent {}

class UpdateSongPlayer extends SongPlayerEvent {}

class RewindSong extends SongPlayerEvent{}

class FastForwardSong extends  SongPlayerEvent{}

class DisposeSongPlayer extends SongPlayerEvent{}

class AudioEnded extends SongPlayerEvent {}