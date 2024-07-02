import 'package:flutter/material.dart';
import 'package:musica_app/src/models/audio_player.dart';
import 'package:musica_app/src/pages/music_player_page.dart';
import 'package:provider/provider.dart';

import 'src/theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>AudioPlayerModel())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Music',
        theme: miTema,
        
        home:  MusicPlayer(),
      ),
    );
  }
}

