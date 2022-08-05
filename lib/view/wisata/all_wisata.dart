import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gis_tetebatu/view/wisata/populer_view.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../../api/api.dart';
import '../../constant.dart';

class DetailWisata extends StatefulWidget {
  const DetailWisata({Key? key}) : super(key: key);

  @override
  State<DetailWisata> createState() => _DetailWisataState();
}

class _DetailWisataState extends State<DetailWisata> {
  Future<List<dynamic>> _fetchfullWisata() async {
    var result = await http.get(Uri.parse(BaseURL.allwisata));
    var data = json.decode(result.body)['data'];
    // print(data);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 80.sp,
          backgroundColor: kblue,
          elevation: 0,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 10.sp,
              ),
              Text(
                "Tempat Wisata,",
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              Text(
                "Menampilkan seluruh tempat wisata!",
                style: TextStyle(fontSize: 12.sp),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: EdgeInsets.only(left: 15.sp, right: 15.sp),
              child: FutureBuilder<List<dynamic>?>(
                future: _fetchfullWisata(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return PopularTours(
                          idWisata: snapshot.data![index]['id_wisata'],
                          jenisWisata: snapshot.data![index]['jenis_wisata'],
                          lat: snapshot.data![index]['lat'],
                          lang: snapshot.data![index]['lang'],
                          label: snapshot.data![index]['ket'],
                          countryName: snapshot.data![index]['nm_wisata'],
                          noOfTours:
                              int.parse(snapshot.data![index]['harga_tiket']),
                          rating: double.parse(snapshot.data![index]['rating']),
                          jambuka: snapshot.data![index]['jam_buka'],
                          jamtutup: snapshot.data![index]['jam_tutup'],
                          alamat: snapshot.data![index]['alamat'],
                          video: snapshot.data![index]['link_video'],
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
            ),
            const SizedBox(
              height: 8,
            ),
          ],
        ));
  }
}
