// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gis_tetebatu/view/wisata/populer_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../api/api.dart';
import '../../constant.dart';

class Favorite extends StatefulWidget {
  const Favorite({Key? key}) : super(key: key);

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  String? username, idUser;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      username = preferences.getString("username");
      idUser = preferences.getString("idUser");
      // print(idUser);
    });
  }

  Future<List<dynamic>> _fetchFavorite() async {
    var result = await http.get(Uri.parse('${BaseURL.favorite}$idUser'));
    var data = json.decode(result.body)['data'];
    //print(data);
    return data;
  }

  @override
  void initState() {
    getPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 80.sp,
          backgroundColor: kblue,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 10.sp,
              ),
              Text(
                "Tempat Wisata,",
                style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
              ),
              Text(
                "Lokasi wisata favorit anda!",
                style: TextStyle(fontSize: 14.sp),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 20.sp,
            ),
            Padding(
              padding: EdgeInsets.only(left: 15.sp, right: 15.sp),
              child: FutureBuilder<List<dynamic>?>(
                future: _fetchFavorite(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Dismissible(
                            direction: DismissDirection.startToEnd,
                            key: Key(
                                snapshot.data![index]['id_wisata'].toString()),
                            onDismissed: (direction) async {
                              // Removes that item the list on swipwe
                              final res = await http
                                  .post(Uri.parse(BaseURL.hapusFav), body: {
                                "wisata_id": snapshot.data![index]['id_wisata']
                                    .toString(),
                                "id_user": "$idUser",
                              });
                              // print("Tes");
                              // print(snapshot.data![index]['id_wisata']);
                              // print("$idUser");
                              if (res.statusCode == 200) {
                                // Shows the information on Snackbar
                                showTopSnackBar(
                                  context,
                                  const CustomSnackBar.error(
                                    message:
                                        "Data berhasil dihapus dari riwayat",
                                  ),
                                );
                              }
                            },
                            background: Container(
                                height: 10.sp,
                                color: Colors.red,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 32.sp),
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete_forever,
                                          color: Colors.white, size: 32.sp),
                                    ],
                                  ),
                                )),
                            child: PopularTours(
                              jenisWisata: snapshot.data![index]
                                  ['jenis_wisata'],
                              idWisata: snapshot.data![index]['id_wisata'],
                              label: snapshot.data![index]['ket'],
                              countryName: snapshot.data![index]['nm_wisata'],
                              noOfTours: int.parse(
                                  snapshot.data![index]['harga_tiket']),
                              rating:
                                  double.parse(snapshot.data![index]['rating']),
                              jambuka: snapshot.data![index]['jam_buka'],
                              jamtutup: snapshot.data![index]['jam_tutup'],
                              alamat: snapshot.data![index]['alamat'],
                              video: snapshot.data![index]['link_video'],
                              lat: snapshot.data![index]['latitude_loc'],
                              lang: snapshot.data![index]['longitude_loc'],
                              imgUrl:
                                  "https://aksestryout.com/gis/img/${snapshot.data![index]['foto']}",
                              desc: snapshot.data![index]['deskripsi'],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image(
                              image: const AssetImage("assets/not_found.webp"),
                              height: 60.sp),
                          Text("Belum ada data favorit",
                              style: TextStyle(
                                fontSize: 12.sp,
                              )),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ));
  }
}
