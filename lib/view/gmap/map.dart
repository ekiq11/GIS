// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:gis_tetebatu/view/gmap/current_loc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';
import '../../constant.dart';
import 'service/service_map.dart';
import 'model/model_map.dart';

class MapsNew extends StatefulWidget {
  const MapsNew({Key? key}) : super(key: key);

  @override
  _MapsNewState createState() => _MapsNewState();
}

class _MapsNewState extends State<MapsNew> {
  GoogleMapController? _controller;

  List<MapsModel> _listmenu = [];

  @override
  void initState() {
    super.initState();

    MapsServices.getMaps().then((listmenu) {
      setState(() {
        _listmenu = listmenu;
      });
      for (var element in _listmenu) {
        allMarkers.add(Marker(
          markerId: MarkerId(element.nmWisata!),
          draggable: false,
          infoWindow:
              InfoWindow(title: element.nmWisata, snippet: element.alamat),
          position: LatLng(double.parse(element.latitudeLoc!),
              double.parse(element.longitudeLoc!)),
        ));
      }
      _pageController = PageController(initialPage: 1, viewportFraction: 0.8)
        ..addListener(_onScroll);
    });
  }

  List<Marker> allMarkers = [];

  PageController? _pageController;

  int? prevPage;

  void _onScroll() {
    if (_pageController!.page!.toInt() != prevPage) {
      prevPage = _pageController!.page!.toInt();
      moveCamera();
    }
  }

  _coffeeShopList(index) {
    return AnimatedBuilder(
      animation: _pageController!,
      builder: (BuildContext context, Widget? widget) {
        double? value = 1;
        if (_pageController!.position.haveDimensions) {
          value = _pageController!.page! - index;
          value = (1 - (value.abs() * 0.3) + 0.06).clamp(0.0, 1.0);
        }
        return Center(
          child: SizedBox(
            height: Curves.easeInOut.transform(value) * 125.0,
            width: Curves.easeInOut.transform(value) * 350.0,
            child: widget,
          ),
        );
      },
      child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CurrentLoc(
                    lat: _listmenu[index].latitudeLoc,
                    lang: _listmenu[index].longitudeLoc,
                    name: _listmenu[index].nmWisata,
                    foto: _listmenu[index].foto,
                    alamat: _listmenu[index].alamat),
              ),
            );
          },
          child: Stack(children: [
            Center(
                child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 20.0,
                    ),
                    height: 150.0,
                    width: 300.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black54,
                            offset: Offset(0.0, 4.0),
                            blurRadius: 10.0,
                          ),
                        ]),
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white),
                        child: Row(children: [
                          Container(
                              height: 80.0,
                              width: 80.0,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(10.0),
                                      topLeft: Radius.circular(10.0)),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          'https://aksestryout.com/gis/img/${_listmenu[index].foto!}'),
                                      fit: BoxFit.cover))),
                          const SizedBox(width: 5.0),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _listmenu[index].nmWisata!,
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  _listmenu[index].alamat!,
                                  style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  width: 170.0,
                                  child: Text(
                                    "Jam Buka : ${_listmenu[index].jamBuka!} - Tutup : ${_listmenu[index].jamTutup!}",
                                    style: TextStyle(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                              ])
                        ]))))
          ])),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                "Lokasi,",
                style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
              ),
              Text(
                "Lokasi terbaik untuk anda!",
                style: TextStyle(fontSize: 14.sp),
              ),
            ],
          ),
        ),
        body: Stack(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height - 50.0,
              width: MediaQuery.of(context).size.width,
              child: GoogleMap(
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
                layoutDirection: TextDirection.ltr,
                initialCameraPosition: const CameraPosition(
                    target: LatLng(-8.5406882, 116.4008687), zoom: 12.0),
                markers: Set.from(allMarkers),
                onMapCreated: mapCreated,
              ),
            ),
            Positioned(
              bottom: 20.0,
              child: SizedBox(
                height: 200.0,
                width: MediaQuery.of(context).size.width,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _listmenu.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _coffeeShopList(index);
                  },
                ),
              ),
            )
          ],
        ));
  }

  void mapCreated(controller) {
    setState(() {
      _controller = controller;
    });
  }

  moveCamera() {
    _controller!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(
            double.parse(
                _listmenu[_pageController!.page!.toInt()].latitudeLoc!),
            double.parse(
                _listmenu[_pageController!.page!.toInt()].longitudeLoc!)),
        zoom: 14.0,
        bearing: 45.0,
        tilt: 45.0)));
  }
}
