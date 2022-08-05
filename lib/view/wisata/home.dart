// ignore_for_file: library_private_types_in_public_api, missing_required_param

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gis_tetebatu/view/berita/all_berita.dart';
import 'package:gis_tetebatu/view/wisata/all_wisata.dart';
import 'package:gis_tetebatu/view/wisata/populer_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../../api/api.dart';
import '../../constant.dart';
import '../../data/data.dart';
import '../../login/login_page.dart';
import '../../model/country_model.dart';
import '../../model/popular_tours_model.dart';
import '../berita/berita.dart';
import '../profil/profil.dart';
import 'list_wista.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<dynamic>> _fetchTampilWisata() async {
    var result = await http.get(Uri.parse(BaseURL.tampilwisata));
    var data = json.decode(result.body)['data'];
    //print(data);
    return data;
  }

  Future<List<dynamic>> _fetchNoRand() async {
    var result = await http.get(Uri.parse(BaseURL.tampilNoRand));
    var data = json.decode(result.body)['data'];
    // print(data);
    return data;
  }

  Future<List<dynamic>> _fetchTampilBerita() async {
    var result = await http.get(Uri.parse(BaseURL.berita));
    var data = json.decode(result.body)['data'];
    // print(data);
    return data;
  }

  List<PopularTourModel> popularTourModels = [];
  List<CountryModel> country = [];
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    country = getCountrys();
    popularTourModels = getPopularTours();
    getPref();
    super.initState();
  }

  String? username, idUser, email;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      username = preferences.getString("username");
      idUser = preferences.getString("id_user");
      email = preferences.getString("email");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60.sp,
        backgroundColor: kblue,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 10.sp,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello ",
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.bold),
                      ),
                      username != null
                          ? Text(
                              "$username, ",
                              style: TextStyle(fontSize: 12.sp),
                            )
                          : Text(
                              "Traveller",
                              style: TextStyle(fontSize: 12.sp),
                            ),
                    ],
                  ),
                  username != null
                      ? InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Profile(),
                                ));
                          },
                          child: Row(
                            children: [
                              Container(
                                  padding: const EdgeInsets.all(6.0),
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50)),
                                  ),
                                  child: Icon(Icons.person, color: kwhite)),
                            ],
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ));
                          },
                          child: Row(
                            children: [
                              Container(
                                  padding: const EdgeInsets.all(6.0),
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50)),
                                  ),
                                  child: Text("Masuk",
                                      style: TextStyle(fontSize: 12.sp))),
                            ],
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 19.sp, vertical: 10.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Popular Tours",
                style: TextStyle(
                    fontSize: 18.sp,
                    color: kblack,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Icon(Icons.location_on_rounded,
                      color: Colors.red, size: 16.sp),
                  Text(
                    "  Tetebatu, Indonesia",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: kblack,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                height: 240,
                child: FutureBuilder<List<dynamic>?>(
                    future: _fetchTampilWisata(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            itemCount: snapshot.data!.length,
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return CountryListTile(
                                idWisata: snapshot.data![index]['id_wisata'],
                                jenisWisata: snapshot.data![index]
                                    ['jenis_wisata'],
                                label: snapshot.data![index]['ket'],
                                countryName: snapshot.data![index]['nm_wisata'],
                                noOfTours: int.parse(
                                    snapshot.data![index]['harga_tiket']),
                                rating: double.parse(
                                    snapshot.data![index]['rating']),
                                jambuka: snapshot.data![index]['jam_buka'],
                                jamtutup: snapshot.data![index]['jam_tutup'],
                                alamat: snapshot.data![index]['alamat'],
                                video: snapshot.data![index]['link_video'],
                                imgUrl:
                                    "https://aksestryout.com/gis/img/${snapshot.data![index]['foto']}",
                                desc: snapshot.data![index]['deskripsi'],
                                lat: snapshot.data![index]['latitude_loc'],
                                lang: snapshot.data![index]['longitude_loc'],
                              );
                            });
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Tempat terbaik",
                    style: TextStyle(
                        fontSize: 14.sp,
                        color: kblack,
                        fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DetailWisata(),
                          ));
                    },
                    child: Text(
                      "Lihat semua",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: kblue,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              FutureBuilder<List<dynamic>?>(
                future: _fetchNoRand(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return PopularTours(
                          jenisWisata: snapshot.data![index]['jenis_wisata'],
                          idWisata: snapshot.data![index]['id_wisata'],
                          label: snapshot.data![index]['ket'],
                          countryName: snapshot.data![index]['nm_wisata'],
                          noOfTours:
                              int.parse(snapshot.data![index]['harga_tiket']),
                          rating: double.parse(snapshot.data![index]['rating']),
                          jambuka: snapshot.data![index]['jam_buka'],
                          jamtutup: snapshot.data![index]['jam_tutup'],
                          alamat: snapshot.data![index]['alamat'],
                          video: snapshot.data![index]['link_video'],
                          lat: snapshot.data![index]['latitude_loc'],
                          lang: snapshot.data![index]['longitude_loc'],
                          imgUrl:
                              "https://aksestryout.com/gis/img/${snapshot.data![index]['foto']}",
                          desc: snapshot.data![index]['deskripsi'],
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Berita Terkini",
                    style: TextStyle(
                        fontSize: 14.sp,
                        color: kblack,
                        fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AllBerita(),
                          ));
                    },
                    child: Text(
                      "Lihat semua",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: kblue,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              FutureBuilder<List<dynamic>?>(
                future: _fetchTampilBerita(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Berita(
                              id: snapshot.data![index]['id_berita'],
                              judul: snapshot.data![index]['judul'],
                              desc: snapshot.data![index]['isi_berita'],
                              view: snapshot.data![index]['view'],
                              imgUrl:
                                  "https://aksestryout.com/gis/berita_img/${snapshot.data![index]['gambar']}",
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                          ],
                        );
                      },
                    );
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
      ),
    );
  }
}
