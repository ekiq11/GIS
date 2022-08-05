import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../constant.dart';

import 'details.dart';

class PopularTours extends StatefulWidget {
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
  const PopularTours(
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
      @required this.lang,
      @required this.jamtutup,
      @required this.lat})
      : super(key: key);

  @override
  State<PopularTours> createState() => _PopularToursState();
}

class _PopularToursState extends State<PopularTours> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
                lat: widget.lat,
                lang: widget.lang,
                jenisWisata: widget.jenisWisata,
                video: widget.video),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
            color: const Color(0xffE9F4F9),
            borderRadius: BorderRadius.circular(20)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20)),
              child: CachedNetworkImage(
                imageUrl: widget.imgUrl!,
                width: MediaQuery.of(context).size.width * 0.20,
                height: 90,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.countryName!,
                    style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff4E6059)),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    widget.alamat!,
                    style: TextStyle(
                        fontSize: 12.sp, color: const Color(0xff4E6059)),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_sharp,
                        color: Colors.amber,
                        size: 14.sp,
                      ),
                      Text(
                        " ${widget.jambuka}",
                        style: TextStyle(
                            color: kblack,
                            fontWeight: FontWeight.w600,
                            fontSize: 10.sp),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
