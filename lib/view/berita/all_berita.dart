import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gis_tetebatu/view/berita/detail_berita.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';
import '../../api/api.dart';
import '../../constant.dart';
import 'berita.dart';

class AllBerita extends StatefulWidget {
  const AllBerita({Key? key}) : super(key: key);

  @override
  State<AllBerita> createState() => _AllBeritaState();
}

class _AllBeritaState extends State<AllBerita> {
  Future<List<dynamic>> _fetchFullBerita() async {
    var result = await http.get(Uri.parse(BaseURL.allberita));
    var data = json.decode(result.body)['data'];
    //  print(data);
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
                "Berita,",
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              Text(
                "Menampilkan seluruh berita pariwisata!",
                style: TextStyle(fontSize: 12.sp),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(15.sp),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              FutureBuilder<List<dynamic>?>(
                future: _fetchFullBerita(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailsBerita(
                                          id: snapshot.data![index]
                                              ['id_berita'],
                                          judul: snapshot.data![index]['judul'],
                                          desc: snapshot.data![index]
                                              ['isi_berita'],
                                          view: snapshot.data![index]['view'],
                                          imgUrl:
                                              "https://aksestryout.com/gis/berita_img/${snapshot.data![index]['gambar']}",
                                        )));
                          },
                          child: Column(
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
                          ),
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
        ));
  }
}
