import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/common/widgets/appbar/app_bar.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/presentation/song_player/bloc/song_player_bloc.dart';

import '../../../common/widgets/favorite_button/favorite_button.dart';
import '../../../core/configs/constants/app_urls.dart';
import '../../../core/configs/theme/app_colors.dart';

class SongPlayerPage extends StatelessWidget {
  final SongEntity songEntity;
  const SongPlayerPage({
    required this.songEntity,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (popDisposition) async {
        context.read<SongPlayerBloc>().add(DisposeSongPlayer());
        return Future.value();
      },
      child: Scaffold(
        appBar: BasicAppbar(
          backgroundColor: AppColors.red,
          title: const Text(
            'Now playing',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          action: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert_rounded),
          ),
        ),
        body: BlocProvider(
          create: (_) => SongPlayerBloc()..add(LoadSong(
            '${AppURLs.songFirestorage}${songEntity.artist} - ${songEntity.title}.mp3?${AppURLs.mediaAlt}',
          )),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Builder(builder: (context) {
              return Column(
                children: [
                  _songCover(context),
                  const SizedBox(height: 20),
                  _songDetail(),
                  const SizedBox(height: 30),
                  _songPlayer(context),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }


  Widget _songCover(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(
            '${AppURLs.coverFirestorage}${songEntity.artist} - ${songEntity.title}.jpg?${AppURLs.mediaAlt}',
          ),
        ),
      ),
    );
  }

  Widget _songDetail() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              songEntity.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              songEntity.artist,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ),
          ],
        ),
        FavoriteButton(songEntity: songEntity),
      ],
    );
  }

  Widget _songPlayer(BuildContext context) {
    return BlocBuilder<SongPlayerBloc, SongPlayerState>(
      builder: (context, state) {
        if (state is SongPlayerLoading) {
          return const CircularProgressIndicator();
        }
        if (state is SongPlayerLoaded) {
          return Column(
            children: [
              Slider(
                value: state.position.inSeconds.toDouble(),
                min: 0.0,
                max: state.duration.inSeconds.toDouble(),
                activeColor: AppColors.red,
                inactiveColor: AppColors.grey,
                onChanged: (value) async{
                  Duration seekPosition = Duration(seconds: value.toInt());
                  await context
                      .read<SongPlayerBloc>()
                      .audioPlayer
                      .seek(seekPosition);
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(formatDuration(state.position),),
                  Text(formatDuration(state.duration)),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BlocBuilder<SongPlayerBloc, SongPlayerState>(
                    builder: (context, state) {
                      return IconButton(
                          onPressed: () async {
                            context
                                .read<SongPlayerBloc>()
                                .add(RewindSong());
                          },
                          icon: const Icon(Icons.fast_rewind_rounded));
                    },
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      context.read<SongPlayerBloc>().add(PlayOrPauseSong());
                    },
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.red,
                      ),
                      child: Icon(
                        state.isPlaying ? Icons.pause : Icons.play_arrow,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  BlocBuilder<SongPlayerBloc, SongPlayerState>(
                    builder: (context, state) {
                      return IconButton(
                          onPressed: () async {
                            context
                                .read<SongPlayerBloc>()
                                .add(FastForwardSong());
                          },
                          icon: const Icon(Icons.fast_forward_rounded));
                    },
                  ),
                ],
              ),
            ],
          );
        }
        return Container();
      },
    );
  }

  String formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
