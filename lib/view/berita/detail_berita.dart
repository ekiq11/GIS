// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gis_tetebatu/view/berita/berita.dart';

import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../../api/api.dart';
import '../../constant.dart';
import '../../data/data.dart';
import '../../model/country_model.dart';

class DetailsBerita extends StatefulWidget {
  final String? id;
  final String? desc;
  final String? judul;
  final String? imgUrl;
  final String? view;
  const DetailsBerita(
      {Key? key,
      @required this.id,
      @required this.desc,
      @required this.judul,
      @required this.view,
      @required this.imgUrl})
      : super(key: key);

  @override
  _DetailsBeritaState createState() => _DetailsBeritaState();
}

class _DetailsBeritaState extends State<DetailsBerita> {
  List<CountryModel> country = [];

  Future<List<dynamic>> _fetchTampilBerita() async {
    var result = await http.get(Uri.parse(BaseURL.berita));
    var data = json.decode(result.body)['data'];
    //print(data);
    return data;
  }

  Future<List<dynamic>?> _fetchTotalViewBerita() async {
    var result = await http.get(Uri.parse(BaseURL.viewBerita + widget.id!));
    var data = json.decode(result.body)['data'];
    // print(data);
    return data;
  }

  @override
  void initState() {
    country = getCountrys();
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          child: Column(
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
                                  Navigator.pop(context);
                                },
                                child: const SizedBox(
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: EdgeInsets.only(
                            left: 16.sp,
                            right: 16.sp,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  widget.judul!,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp),
                                ),
                              ),
                              FutureBuilder<List<dynamic>?>(
                                future: _fetchTotalViewBerita(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return ListView.builder(
                                        shrinkWrap: true,
                                        physics: const ClampingScrollPhysics(),
                                        itemCount: 1,
                                        itemBuilder: (context, index) {
                                          return Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              snapshot.data![index]
                                                          ['totalView'] !=
                                                      null
                                                  ? Badge(
                                                      padding: EdgeInsets.only(
                                                          left: 10.sp,
                                                          right: 10.sp,
                                                          top: 6.sp,
                                                          bottom: 6.sp),
                                                      toAnimate: true,
                                                      shape: BadgeShape.square,
                                                      badgeColor: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      badgeContent: Row(
                                                        children: [
                                                          const Icon(Icons
                                                              .visibility_sharp),
                                                          const SizedBox(
                                                            width: 8,
                                                          ),
                                                          Text(
                                                            snapshot
                                                                .data![index][
                                                                    'totalView']
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
                                                  : Text(
                                                      "",
                                                      style: TextStyle(
                                                          color: Colors.white70,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 12.sp),
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
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 18,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 15.sp, bottom: 12.sp),
                    child: Text("Berita Lainnya",
                        style: TextStyle(
                            fontSize: 12.sp,
                            height: 1.5,
                            fontWeight: FontWeight.bold,
                            color: kblack)),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: EdgeInsets.only(left: 15.sp),
                      child: FutureBuilder<List<dynamic>?>(
                          future: _fetchTampilBerita(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
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
                                          builder: (context) => DetailsBerita(
                                            id: widget.id!,
                                            desc: snapshot.data![index]
                                                ['isi_berita'],
                                            judul: snapshot.data![index]
                                                ['judul'],
                                            view: snapshot.data![index]['view'],
                                            imgUrl:
                                                "https://aksestryout.com/gis/berita_img/${snapshot.data![index]['gambar']}",
                                          ),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Berita(
                                          id: snapshot.data![index]
                                              ['id_berita'],
                                          judul: snapshot.data![index]['judul'],
                                          desc: snapshot.data![index]
                                              ['isi_berita'],
                                          view: snapshot.data![index]['view'],
                                          imgUrl:
                                              "https://aksestryout.com/gis/berita_img/${snapshot.data![index]['gambar']}",
                                        ),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          }),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageListTile extends StatelessWidget {
  final String? imgUrl;

  const ImageListTile({Key? key, @required this.imgUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: CachedNetworkImage(
          imageUrl: imgUrl!,
          height: 220,
          width: 150,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
