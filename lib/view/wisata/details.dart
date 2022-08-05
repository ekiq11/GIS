// ignore_for_file: library_private_types_in_public_api, prefer_interpolation_to_compose_strings, avoid_unnecessary_containers, must_be_immutable, use_build_context_synchronously, sort_child_properties_last, avoid_print, unused_local_variable

import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gis_tetebatu/view/gmap/current_loc.dart';
import 'package:gis_tetebatu/view/youtube/youtube.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../api/api.dart';
import '../../constant.dart';
import '../../data/data.dart';
import '../../login/login_page.dart';
import '../../model/country_model.dart';
import 'package:http/http.dart' as http;
import 'package:rating_dialog/rating_dialog.dart';

import '../bottom_nav/bottom_nav.dart';
import 'list_wista.dart';

class Details extends StatefulWidget {
  final String? idWisata;
  final String? imgUrl;
  final String? placeName, jenisWisata;
  final double? rating;
  final String? jambuka, jamtutup;
  final String? alamat;
  final String? video;
  final String? desc, lat, lang;
  const Details(
      {Key? key,
      @required this.jenisWisata,
      @required this.idWisata,
      @required this.rating,
      @required this.desc,
      @required this.alamat,
      @required this.imgUrl,
      @required this.video,
      @required this.placeName,
      @required this.jambuka,
      @required this.jamtutup,
      this.lang,
      this.lat})
      : super(key: key);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  List<CountryModel> country = [];
  bool isFav = false;
  @override
  void initState() {
    getPref();
    country = getCountrys();
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  String? username, idUser;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      username = preferences.getString("username");
      idUser = preferences.getString("idUser");
      // print(idUser);
    });
  }

  Future<List<dynamic>> _fetchTampilWisata() async {
    var result = await http.get(Uri.parse(BaseURL.tampilwisata));
    var data = json.decode(result.body)['data'];
    // print(data);
    return data;
  }

  Future<List<dynamic>> _fetchRating() async {
    var result = await http.get(Uri.parse(BaseURL.rating + widget.idWisata!));
    var data = json.decode(result.body)['data'];
    // print(data);
    return data;
  }

  Future<List<dynamic>> _fetchFasilitas() async {
    var result = await http.get(Uri.parse(BaseURL.fasiltas + widget.idWisata!));
    var data = json.decode(result.body)['data'];
    // print(data);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Image.network(
                    widget.imgUrl!,
                    height: 350,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    height: 350,
                    color: Colors.black12,
                    padding: const EdgeInsets.only(top: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                            left: 24,
                            right: 24,
                          ),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute<void>(
                                        builder: (BuildContext context) =>
                                            const BottomNav()),
                                  );
                                },
                                child: const SizedBox(
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              const SizedBox(
                                width: 24,
                              ),
                              InkWell(
                                  onTap: () async {
                                    if (username != null) {
                                      final res = await http.post(
                                          Uri.parse(BaseURL.addFavorite),
                                          body: {
                                            "wisata_id": widget.idWisata,
                                            "id_user": "$idUser",
                                          });
                                      if (res.statusCode == 200) {
                                        setState(() {
                                          showTopSnackBar(
                                              context,
                                              const CustomSnackBar.info(
                                                message:
                                                    "Telah di tambahkan ke favorite",
                                              ));
                                        });
                                      }
                                    } else {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginPage()));
                                    }
                                  },
                                  child: const Icon(
                                    Icons.favorite_border,
                                    color: Colors.white,
                                    size: 24,
                                  ))
                            ],
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.only(
                            left: 24,
                            right: 24,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  widget.placeName!,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp),
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: Colors.white70,
                                    size: 18.sp,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    widget.alamat!,
                                    style: TextStyle(
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12.sp),
                                  ),
                                ],
                              ),
                              InkWell(
                                onTap: () {
                                  username != null
                                      ? showDialog(
                                          context: context,
                                          builder: (_) => RatingDialog(
                                            starSize: 25.sp,
                                            enableComment: false,
                                            initialRating: 1.0,
                                            // your app's name?
                                            title: Text(
                                              'Kasih Bintang',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            // encourage your user to leave a high rating?
                                            message: Text(
                                              'Tap untuk memberikan bintang.',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 12.sp),
                                            ),
                                            // your app's logo?

                                            submitButtonText: 'Submit',

                                            onCancelled: () =>
                                                print('cancelled'),
                                            onSubmitted: (response) async {
                                              print(
                                                  'rating: ${response.rating}, comment: ${response.comment}');

                                              final res = await http.post(
                                                  Uri.parse(BaseURL.addRating),
                                                  body: {
                                                    "id_wisata":
                                                        widget.idWisata,
                                                    "id_user": "$idUser",
                                                    "vote": response.rating
                                                        .toString(),
                                                  });
                                              print("$idUser");
                                              print(widget.idWisata);
                                            },
                                          ),
                                        )
                                      :
                                      //navigator
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginPage()));

                                  // show the dialog
                                },
                                child: FutureBuilder<List<dynamic>?>(
                                  future: _fetchRating(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const ClampingScrollPhysics(),
                                          itemCount: 1,
                                          itemBuilder: (context, index) {
                                            return Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                snapshot.data![index]
                                                            ['jmlRating'] !=
                                                        null
                                                    ? Badge(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10.sp,
                                                                right: 10.sp,
                                                                top: 6.sp,
                                                                bottom: 6.sp),
                                                        toAnimate: true,
                                                        shape:
                                                            BadgeShape.square,
                                                        badgeColor:
                                                            Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        badgeContent: Row(
                                                          children: [
                                                            RatingBar(
                                                                widget.rating!),
                                                            const SizedBox(
                                                              width: 8,
                                                            ),
                                                            Text(
                                                              snapshot
                                                                  .data![index][
                                                                      'jmlRating']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black87,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize:
                                                                      12.sp),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    : Row(
                                                        children: [
                                                          Icon(Icons.star,
                                                              color:
                                                                  Colors.amber,
                                                              size: 18.sp),
                                                          Text(
                                                            " Belum ada rating",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white70,
                                                                fontSize:
                                                                    12.sp),
                                                          ),
                                                        ],
                                                      )
                                              ],
                                            );
                                          });
                                    } else {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Padding(
                            padding: EdgeInsets.only(top: 15.sp),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height: 30.sp,
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white,
                                        border:
                                            Border.all(color: kblue, width: 1),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text("Buka : " + widget.jambuka!,
                                              style: TextStyle(
                                                  color: kblack,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12.sp)),
                                        ],
                                      ),
                                    ),
                                    const Text(" - "),
                                    Container(
                                      height: 30.sp,
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white,
                                        border:
                                            Border.all(color: kblue, width: 1),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text("Tutup : " + widget.jamtutup!,
                                              style: TextStyle(
                                                  color: kblack,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12.sp)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30))),
                          height: 60.sp,
                        )
                      ],
                    ),
                  )
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  textAlign: TextAlign.left,
                  "Tentang ${widget.placeName}",
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
                  style: TextStyle(fontSize: 12.sp, height: 1.5, color: kblack),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding: EdgeInsets.only(left: 20.sp),
                child: Row(
                  children: [
                    SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Youtube(
                                  img: widget.imgUrl,
                                  alamat: widget.alamat,
                                  video: widget.video,
                                  nama: widget.placeName,
                                  lat: widget.lat,
                                  lang: widget.lang,
                                  desc: widget.desc),
                            ),
                          );
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 10),
                          decoration: BoxDecoration(
                              color: kblue,
                              borderRadius: BorderRadius.circular(15.0)),
                          child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Watch Video",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(
                                  width: 15.0,
                                ),
                                const Icon(
                                  Icons.play_circle_outline_outlined,
                                  color: Colors.white,
                                )
                              ]),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    SizedBox(
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
                                  name: widget.placeName!,
                                  img: widget.imgUrl!,
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
                              children: const [
                                Icon(
                                  Icons.directions_outlined,
                                  color: Colors.white,
                                )
                              ]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 22.0, bottom: 15),
                    child: Text("Fasilitas di ${widget.placeName}",
                        style: TextStyle(
                            fontSize: 14.sp,
                            height: 1.5,
                            fontWeight: FontWeight.bold,
                            color: kblack)),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 240,
                    child: FutureBuilder<List<dynamic>?>(
                      future: _fetchFasilitas(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HeroAnimation(
                                          id: snapshot.data![index]
                                              ['id_fasilitas'],
                                          img: snapshot.data![index]['gambar']),
                                    ),
                                  );
                                },
                                child: Hero(
                                  tag:
                                      "${snapshot.data![index]['id_fasilitas']}",
                                  child: ImageListTile(
                                    fasilitas: snapshot.data![index]
                                        ['nm_fasilitas'],
                                    imgUrl:
                                        'https://aksestryout.com/gis/img/${snapshot.data![index]['gambar']!}',
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return const ImageListTile(
                            imgUrl:
                                'https://aksestryout.com/gis/img/not_found.png',
                          );
                        }
                      },
                    ),
                  ),

                  // SizedBox(
                  //   height: 240,
                  //   child: ListView.builder(
                  //       padding: const EdgeInsets.symmetric(horizontal: 24),
                  //       itemCount: country.length,
                  //       shrinkWrap: true,
                  //       physics: const ClampingScrollPhysics(),
                  //       scrollDirection: Axis.horizontal,
                  //       itemBuilder: (context, index) {

                  //       }),
                  // ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 22.0, bottom: 15),
                        child: Text("Lokasi wisata lainnya",
                            style: TextStyle(
                                fontSize: 14.sp,
                                height: 1.5,
                                fontWeight: FontWeight.bold,
                                color: kblack)),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 240,
                    child: FutureBuilder<List<dynamic>?>(
                        future: _fetchTampilWisata(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                itemCount: snapshot.data!.length,
                                shrinkWrap: true,
                                physics: const ClampingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return CountryListTile(
                                    idWisata: snapshot.data![index]
                                        ['id_wisata'],
                                    jenisWisata: snapshot.data![index]
                                        ['jenis_wisata'],
                                    label: snapshot.data![index]['ket'],
                                    countryName: snapshot.data![index]
                                        ['nm_wisata'],
                                    noOfTours: int.parse(
                                        snapshot.data![index]['harga_tiket']),
                                    rating: double.parse(
                                        snapshot.data![index]['rating']),
                                    jambuka: snapshot.data![index]['jam_buka'],
                                    jamtutup: snapshot.data![index]
                                        ['jam_tutup'],
                                    alamat: snapshot.data![index]['alamat'],
                                    video: snapshot.data![index]['link_video'],
                                    imgUrl:
                                        "https://aksestryout.com/gis/img/${snapshot.data![index]['foto']}",
                                    desc: snapshot.data![index]['deskripsi'],
                                    lat: snapshot.data![index]['latitude_loc'],
                                    lang: snapshot.data![index]
                                        ['longitude_loc'],
                                  );
                                });
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        }),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HeroAnimation extends StatefulWidget {
  String? id, img;

  HeroAnimation({Key? key, this.id, this.img}) : super(key: key);
  @override
  State<HeroAnimation> createState() => _HeroAnimationState();
}

class _HeroAnimationState extends State<HeroAnimation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Hero(
            tag: "${widget.id}",
            child: PhotoView(
              backgroundDecoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              imageProvider:
                  NetworkImage('https://aksestryout.com/gis/img/${widget.img}'),
            ),
          ),
        ),
      ),
    );
  }
}

class FeaturesTile extends StatelessWidget {
  final Icon? icon;
  final String? label;
  const FeaturesTile({Key? key, this.label, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.7,
      child: SizedBox(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  border: Border.all(color: kblack.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(40)),
              child: icon,
            ),
            const SizedBox(
              height: 9,
            ),
            SizedBox(
                width: 70,
                child: Text(
                  label!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: kblack),
                ))
          ],
        ),
      ),
    );
  }
}

class RatingBar extends StatelessWidget {
  final double? rating;

  const RatingBar(this.rating, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.star,
            color: rating! >= 5 ? Colors.orange[100] : Colors.orange,
            size: 16.sp),
      ],
    ));
  }
}

class ImageListTile extends StatelessWidget {
  final String? imgUrl, fasilitas;

  const ImageListTile({Key? key, this.imgUrl, this.fasilitas})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: CachedNetworkImage(
              imageUrl: imgUrl.toString(),
              height: 220,
              width: 150,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: 200,
            width: 150,
            child: Column(
              children: [
                const Spacer(),
                Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white38),
                    child: Text(
                      fasilitas.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 10.sp),
                    )),

                // Container(
                //     margin: const EdgeInsets.only(left: 8, right: 8),
                //     child: Row(
                //       children: [
                //         Text(widget.rating!.toString(),
                //             style: TextStyle(
                //                 color: Colors.white,
                //                 fontWeight: FontWeight.w600,
                //                 fontSize: 10.sp)),
                //         const SizedBox(
                //           height: 2,
                //         ),
                //         const Icon(
                //           Icons.star,
                //           color: Colors.orange,
                //           size: 20,
                //         )
                //       ],
                //     ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
