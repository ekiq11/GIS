import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'details.dart';

class CountryListTile extends StatefulWidget {
  final String? idWisata;
  final String? label, jenisWisata;
  final String? desc;
  final String? countryName;
  final int? noOfTours;
  final double? rating;
  final String? alamat;
  final String? video;
  final String? imgUrl;
  final String? jambuka;
  final String? jamtutup;
  final String? lat, lang;
  const CountryListTile(
      {Key? key,
      @required this.jenisWisata,
      @required this.idWisata,
      @required this.countryName,
      @required this.label,
      @required this.desc,
      @required this.alamat,
      @required this.jambuka,
      @required this.video,
      @required this.noOfTours,
      @required this.rating,
      @required this.imgUrl,
      @required this.jamtutup,
      this.lat,
      this.lang})
      : super(key: key);

  @override
  State<CountryListTile> createState() => _CountryListTileState();
}

class _CountryListTileState extends State<CountryListTile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Details(
                jambuka: widget.jambuka,
                jamtutup: widget.jamtutup,
                idWisata: widget.idWisata,
                imgUrl: widget.imgUrl,
                placeName: widget.countryName,
                rating: widget.rating,
                alamat: widget.alamat,
                desc: widget.desc,
                jenisWisata: widget.jenisWisata,
                lat: widget.lat,
                lang: widget.lang,
                video: widget.video),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CachedNetworkImage(
                imageUrl: widget.imgUrl!,
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
                  Row(
                    children: [
                      Container(
                          margin: const EdgeInsets.only(left: 8, top: 8),
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white38),
                          child: Text(
                            widget.jenisWisata!,
                            style: const TextStyle(color: Colors.white),
                          ))
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                            bottom: 10, left: 8, right: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              child: Text(
                                widget.countryName!,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10.sp),
                              ),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Text(
                              widget.jambuka!,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10.sp),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),

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
      ),
    );
  }
}
