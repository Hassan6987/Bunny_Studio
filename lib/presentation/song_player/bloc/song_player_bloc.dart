import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'song_player_event.dart';
part 'song_player_state.dart';




class SongPlayerBloc extends Bloc<SongPlayerEvent, SongPlayerState> {
  final AudioPlayer audioPlayer = AudioPlayer();
  Duration songDuration = Duration.zero;
  Duration songPosition = Duration.zero;
  bool isPlaying = false;

  SongPlayerBloc() : super(SongPlayerLoading()) {
    // Load song event
    on<LoadSong>((event, emit) async {
      emit(SongPlayerLoading());
      try {
        await audioPlayer.setUrl(event.url);
        songDuration = audioPlayer.duration ?? Duration.zero;
        audioPlayer.play();
        isPlaying = audioPlayer.playing;
        emit(SongPlayerLoaded(
          position: songPosition,
          duration: songDuration,
          isPlaying: isPlaying,
        ));
      } catch (e) {
        emit(SongPlayerFailure());
      }
    });

    // Play or pause song event
    on<PlayOrPauseSong>((event, emit) {
      if (audioPlayer.playing) {
        audioPlayer.pause();
        isPlaying = false;
      } else {
        audioPlayer.play();
        isPlaying = true;
      }
      emit(SongPlayerLoaded(
        position: songPosition,
        duration: songDuration,
        isPlaying: isPlaying,
      ));
    });

    // Update song position event
    on<UpdateSongPlayer>((event, emit) {
      if (!isClosed) {
        emit(SongPlayerLoaded(
          position: songPosition,
          duration: songDuration,
          isPlaying: isPlaying,
        ));
      }
    });

    on<DisposeSongPlayer>((event, emit) async {
      await audioPlayer.stop();
      await audioPlayer.dispose();
    });

    on<RewindSong>((event, emit) {
      if (audioPlayer.audioSource != null) {
        final newPosition = audioPlayer.position - const Duration(seconds: 10);
        audioPlayer.seek(newPosition > Duration.zero ? newPosition : Duration.zero);
        if (!isClosed) {
          emit(SongPlayerLoaded(
            position: songPosition,
            duration: songDuration,
            isPlaying: isPlaying,
          ));
        }
      }
    });

    on<FastForwardSong>((event, emit) {
      if (audioPlayer.audioSource != null) {
        final maxDuration = audioPlayer.duration;
        final newPosition = audioPlayer.position + const Duration(seconds: 10);
        audioPlayer.seek(newPosition < maxDuration! ? newPosition : maxDuration);
        if (!isClosed) {
          emit(SongPlayerLoaded(
            position: songPosition,
            duration: songDuration,
            isPlaying: isPlaying,
          ));
        }
      }
    });

    // Listen to position changes and emit events
    audioPlayer.positionStream.listen((position) {
      songPosition = position;
      if (!isClosed) add(UpdateSongPlayer());
    });

    // Listen to duration changes and emit events
    audioPlayer.durationStream.listen((duration) {
      songDuration = duration ?? Duration.zero;
      if (!isClosed) add(UpdateSongPlayer());
    });

    audioPlayer.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        if (!isClosed) add(AudioEnded());
      }
    });

    on<AudioEnded>((event, emit) {
      audioPlayer.seek(Duration.zero);
      audioPlayer.pause();
      isPlaying = false;
      if (!isClosed) {
        emit(SongPlayerLoaded(
          position: songPosition,
          duration: songDuration,
          isPlaying: isPlaying,
        ));
      }
    });
  }

  @override
  Future<void> close() {
    audioPlayer.dispose();
    return super.close();
  }
}
