import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:spotify/presentation/home/bloc/play_list_cubit.dart';

import '../../../common/widgets/favorite_button/favorite_button.dart';
import '../../../domain/entities/song/song.dart';
import '../../song_player/pages/song_player.dart';
import '../bloc/play_list_state.dart';

class PlayList extends StatelessWidget {
  const PlayList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PlayListCubit()..getPlayList(),
      child: BlocBuilder<PlayListCubit,PlayListState>(
        builder:(context,state) {
          if(state is PlayListLoading) {
            return Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            );
          }
          if(state is PlayListLoaded) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 40,
                horizontal: 16
              ),
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Playlist',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16
                        ),
                      ),
                      
                      Text(
                        'See More',
                         style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Color(0xff7521ef)
                        ),
                      ),
            
                    ],
                  ),
                  const SizedBox(height: 20,),
                  _songs(state.songs)
                ],
              ),
            );
          }

          return Container();
        } ,
      )
    );
  }

  Widget _songs(List<SongEntity> songs) {
    return ListView.separated(
      shrinkWrap: true,
      itemBuilder: (context,index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
               builder: (BuildContext context) 
              => SongPlayerPage(
                songEntity: songs[index],
              )
            )
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: 45,
                    width: 45,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.red,
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        songs[index].title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16
                        ),
                      ),
                      const SizedBox(height: 5,),
                       Text(
                        songs[index].artist,
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 11
                        ),
                      ),
                    ],
                  )
                ],
              ),

                  FavoriteButton(
                    songEntity: songs[index],
                  )

            ],
          ),
        );
      },
      separatorBuilder: (context,index) => const SizedBox(height: 20,),
      itemCount: songs.length
    );
  }
}