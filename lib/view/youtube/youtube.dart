// // ignore_for_file: must_be_immutable

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// class Youtube extends StatefulWidget {
//   String? video;
//   Youtube({Key? key, this.video}) : super(key: key);

//   @override
//   State<Youtube> createState() => _YoutubeState();
// }

// class _YoutubeState extends State<Youtube> {
//   late YoutubePlayerController _controller;
//   bool _isPlayerReady = false;

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(

//       child: YoutubePlayer(
//         onReady: () {
//           _isPlayerReady = true;
//         },
//         controller: YoutubePlayerController(
//             initialVideoId: widget.video!,
//             flags: const YoutubePlayerFlags(
//               autoPlay: false,
//             )),
//         showVideoProgressIndicator: true,
//         progressIndicatorColor: Colors.blue,
//         progressColors: const ProgressBarColors(
//             playedColor: Colors.blue, handleColor: Colors.blueAccent),
//       ),
//     );
//   }
// }

// Copyright 2020 Sarbagya Dhaubanjar. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: must_be_immutable, library_private_types_in_public_api

import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../constant.dart';
import '../gmap/current_loc.dart';

class Youtube extends StatefulWidget {
  final String? video, nama, img, alamat;
  final String? desc, lat, lang;

  const Youtube(
      {Key? key,
      this.video,
      this.nama,
      this.desc,
      this.lat,
      this.lang,
      this.img,
      this.alamat})
      : super(key: key);
  @override
  _YoutubeState createState() => _YoutubeState();
}

class _YoutubeState extends State<Youtube> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: 'tcodrIK2P_I',
      params: YoutubePlayerParams(
        playlist: [
          '${widget.video}',
        ],
        startAt: const Duration(minutes: 1, seconds: 36),
        showControls: true,
        showFullscreenButton: true,
        desktopMode: false,
        privacyEnhanced: true,
        useHybridComposition: true,
      ),
    );
    _controller.onEnterFullscreen = () {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      log('Entered Fullscreen');
    };
    _controller.onExitFullscreen = () {
      log('Exited Fullscreen');
    };
  }

  @override
  Widget build(BuildContext context) {
    const player = YoutubePlayerIFrame();
    return WillPopScope(
      onWillPop: () {
        if (MediaQuery.of(context).orientation == Orientation.landscape) {
          SystemChrome.setPreferredOrientations(
              [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
        }
        return Future.value(true);
      },
      child: YoutubePlayerControllerProvider(
        // Passing controller to widgets below.
        controller: _controller,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 80.sp,
            backgroundColor: kblue,
            elevation: 0,
            automaticallyImplyLeading: true,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 10.sp,
                ),
                Text(
                  "Video,",
                  style:
                      TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Tayangan tempat wisata!",
                  style: TextStyle(fontSize: 14.sp),
                ),
              ],
            ),
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              if (kIsWeb && constraints.maxWidth > 800) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Expanded(child: player),
                    SizedBox(
                      width: 500,
                      child: SingleChildScrollView(),
                    ),
                  ],
                );
              }
              return ListView(
                children: [
                  Stack(
                    children: [
                      player,
                      Positioned.fill(
                        child: YoutubeValueBuilder(
                          controller: _controller,
                          builder: (context, value) {
                            return AnimatedCrossFade(
                              firstChild: const SizedBox.shrink(),
                              secondChild: Material(
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        YoutubePlayerController.getThumbnail(
                                          videoId:
                                              _controller.params.playlist.first,
                                          quality: ThumbnailQuality.medium,
                                        ),
                                      ),
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                              ),
                              crossFadeState: value.isReady
                                  ? CrossFadeState.showFirst
                                  : CrossFadeState.showSecond,
                              duration: const Duration(milliseconds: 300),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      textAlign: TextAlign.left,
                      "Tentang ${widget.nama}",
                      style: TextStyle(
                          color: kblack,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      widget.desc!,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 12.sp, height: 1.5, color: kblack),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CurrentLoc(
                                lat: widget.lat,
                                lang: widget.lang,
                                name: widget.nama,
                                img: widget.img,
                                alamat: widget.alamat),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: kgreen,
                            borderRadius: BorderRadius.circular(15.0)),
                        child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Lihat Lokasi",
                                  style: TextStyle(
                                      color: kwhite,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.sp)),
                              Padding(
                                padding: EdgeInsets.only(left: 20.sp),
                                child: const Icon(
                                  Icons.directions_outlined,
                                  color: Colors.white,
                                ),
                              )
                            ]),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}
