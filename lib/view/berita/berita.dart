// ignore_for_file: use_build_context_synchronously, unused_local_variable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gis_tetebatu/view/berita/detail_berita.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

import '../../api/api.dart';

class Berita extends StatefulWidget {
  final String? id;
  final String? desc;
  final String? judul;
  final String? imgUrl;
  final String? view;

  const Berita(
      {Key? key,
      @required this.id,
      @required this.desc,
      @required this.judul,
      @required this.view,
      @required this.imgUrl})
      : super(key: key);

  @override
  State<Berita> createState() => _BeritaState();
}

class _BeritaState extends State<Berita> {
  String? username, idUser;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      username = preferences.getString("username");
      idUser = preferences.getString("idUser");
      // print(idUser);
    });
  }

  @override
  void initState() {
    getPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (username != null) {
          final res = await http.post(Uri.parse(BaseURL.addViewBerita), body: {
            "id_berita": widget.id!,
            "id_user": "$idUser",
          });

          // print(widget.id);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailsBerita(
                id: widget.id!,
                desc: widget.desc!,
                judul: widget.judul!,
                view: widget.view!,
                imgUrl: widget.imgUrl!,
              ),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailsBerita(
                id: widget.id!,
                desc: widget.desc!,
                judul: widget.judul!,
                view: widget.view!,
                imgUrl: widget.imgUrl!,
              ),
            ),
          );
        }
      },
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: CachedNetworkImage(
              imageUrl: widget.imgUrl!,
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width * 0.9,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                // Row(
                //   children: [
                //     Container(
                //       margin: const EdgeInsets.only(left: 8, top: 8),
                //       padding: const EdgeInsets.symmetric(
                //           vertical: 6, horizontal: 8),
                //       decoration: BoxDecoration(
                //           borderRadius: BorderRadius.circular(8),
                //           color: Colors.white38),
                //       child: Text(
                //         widget.view.toString(),
                //         style: TextStyle(
                //             color: Colors.white,
                //             fontWeight: FontWeight.w600,
                //             fontSize: 12.sp),
                //       ),
                //     ),
                //   ],
                // ),
                const Spacer(),
                Row(
                  children: [
                    Container(
                      margin:
                          const EdgeInsets.only(bottom: 10, left: 8, right: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: Text(
                                widget.judul!,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12.sp),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
