
import 'package:animate_do/animate_do.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:musica_app/src/helpers/helpers.dart';
import 'package:musica_app/src/models/audio_player.dart';
import 'package:musica_app/src/widgets/widgets.dart';
import 'package:provider/provider.dart';

class MusicPlayer extends StatelessWidget {
  const MusicPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold
    (
      body: Stack(
        children: [
          Background(),
          Column
          (
            children: 
            [
              CustomAppBar(),
              ImagenDiscoDuracion(),
              TituloPlay(),
              Expanded(child: Lyrics())
            ],
          ),
        ],
      ),
    );
  }
}

class Background extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Container
    (
      width: double.infinity,
      height: size.height*0.8,
      decoration: BoxDecoration
      (
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(60)),
        gradient: LinearGradient(
          begin: Alignment.center,
          end: Alignment.center,
          colors: 
        [
          
          Color(0xff333333E),
          Color(0xff201E28)
        ])
      ),
    );
  }
}

class Lyrics extends StatelessWidget {
 

  @override
  Widget build(BuildContext context) {
    final lyrics = getLyrics();
    return Container(
      child: ListWheelScrollView
      (itemExtent: 42, 
      diameterRatio: 1.5,
      physics: BouncingScrollPhysics(),
      children: lyrics.map(
        (e) => Text(e, style: TextStyle(fontSize: 20,color: Colors.white.withOpacity(0.6)),)).toList()
    ));
  }
}

class TituloPlay extends StatefulWidget {


  @override
  State<TituloPlay> createState() => _TituloPlayState();
}

class _TituloPlayState extends State<TituloPlay>  with SingleTickerProviderStateMixin {
  bool isPlaying =false;
  bool firstTime= true;
  late AnimationController playAnimation;
  final assetAudioPlayer = AssetsAudioPlayer();

  @override
  void initState() {
    playAnimation=AnimationController(vsync:this, duration: Duration(milliseconds:500 ) );
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    playAnimation.dispose();
    // TODO: implement dispose
    super.dispose();
  }
 void open() {

    final audioPlayerModel = Provider.of<AudioPlayerModel>(context, listen: false);

    //! assetAudioPlayer.open('assets/Breaking-Benjamin-Far-Away.mp3');
    assetAudioPlayer.open(
      Audio('assets/Breaking-Benjamin-Far-Away.mp3'),
      autoStart: true,
      showNotification: true
    );

    assetAudioPlayer.currentPosition.listen( (duration) {
      audioPlayerModel.current = duration;
    });
  
    assetAudioPlayer.current.listen( (playingAudio){
      //! audioPlayerModel.songDuration = playingAudio.duration;
      audioPlayerModel.songDuration = playingAudio?.audio.duration ?? Duration(seconds: 0);
    });


  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      margin: const EdgeInsets.only(top: 40),
      child: Row
      (
        children: 
        [
          Column
          (
            children: 
            [
              Text('Far Away',
              style: TextStyle(fontSize: 30, color: Colors.white.withOpacity(0.8)),
               ),
              Text('-Breaking Benjamin-',
              style: TextStyle(fontSize: 15, color: Colors.white.withOpacity(0.5)),
               )
            ],
          ),
          Spacer(),
          FloatingActionButton(
            elevation: 0,
            highlightElevation: 0,
            onPressed: (){
              final audioPlayerModel= Provider.of<AudioPlayerModel>(context,listen: false);
              if(isPlaying)
              {
                playAnimation.reverse();
                isPlaying=false;
                audioPlayerModel.controller.stop();

              }else
              {
                playAnimation.forward();
                isPlaying=true;
                audioPlayerModel.controller.repeat();
              }
              if(firstTime){
                open();
                firstTime=false;
              }
              else
              {
                assetAudioPlayer.playOrPause();
              }
            },
            shape: CircleBorder(),
          backgroundColor: Color(0xffF8CB51),
          
          child: AnimatedIcon(
          icon: AnimatedIcons.play_pause,
           progress: playAnimation),
          )
        ],
      ),
    );
  }
}

class ImagenDiscoDuracion extends StatelessWidget {
  const ImagenDiscoDuracion({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal:30 ),
      margin: EdgeInsets.only(top: 70),
      child: Row
      (
        
        children: 
        [
          ImagenDisco(),
          SizedBox(width: 5,),
          BarraProgrees(),
          SizedBox(width: 5,),
        ],
      ),
    );
  }
}

class BarraProgrees extends StatelessWidget {
final estilo= TextStyle(color: Colors.white.withOpacity(0.4));
  @override
  Widget build(BuildContext context) {
    final audioPlayerModel= Provider.of<AudioPlayerModel>(context);
  final porcentaje= audioPlayerModel.porcentaje;
    return Container(
      
      child: Column
      (
        children: 
        [
          Text(audioPlayerModel.songTotalDuration,style:estilo,),
          SizedBox(height: 10,),
          Stack
          (
            children: 
            [
              Container
              (
                width: 3,
                height: 230,
                color: Colors.white.withOpacity(0.1),
              ),
              Positioned(
                bottom: 0,
                child: Container
                (
                  width: 3,
                  height: 230*porcentaje,
                  color: Colors.white.withOpacity(0.8),
                ),
              )
            ],
          ),
          SizedBox(height: 10,),
          Text(audioPlayerModel.currentSecond,style:estilo,)
        ],
      ),
    );
  }
}

class ImagenDisco extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final audioPlayerModel= Provider.of<AudioPlayerModel>(context);
    return Container(
      padding: const EdgeInsets.all(20),
      width: 250,
      height: 250,
      decoration: BoxDecoration
      (
        borderRadius: BorderRadius.circular(200),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          colors: 
        [
          Color(0xff484750),
          Color(0xff1E1C24)
        ]
        )
      ),
      child: ClipRRect
      (
        borderRadius: BorderRadius.circular(200),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SpinPerfect
            (
              duration: Duration(seconds: 10),
              infinite: true,
              manualTrigger: true,
              controller: (p0) =>audioPlayerModel.controller=p0 ,
              child: Image.asset('assets/aurora.jpg')),
        Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration
          (
            color: Colors.black38,
            borderRadius: BorderRadius.circular(100)
          ),

        ),
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration
          (
            color: Color(0xff1c1c25),
            borderRadius: BorderRadius.circular(100)
          ),

        )
        
        ]),
      ),
    );
  }
}