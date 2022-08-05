// ignore_for_file: must_be_immutable, sort_child_properties_last, avoid_print, prefer_interpolation_to_compose_strings

import 'dart:async';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../constant.dart';

class CurrentLoc extends StatefulWidget {
  String? lat, lang, name, img, alamat, foto;
  CurrentLoc(
      {Key? key,
      this.lang,
      this.lat,
      this.name,
      this.img,
      this.alamat,
      this.foto})
      : super(key: key);
  @override
  State<CurrentLoc> createState() => _CurrentLocState();
}

class _CurrentLocState extends State<CurrentLoc> {
  final Completer<GoogleMapController> _controller = Completer();
  // ignore: unnecessary_nullable_for_final_variable_declarations
  final CustomInfoWindowController? _customInfoWindowController =
      CustomInfoWindowController();
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-8.5406882, 116.4008687),
    zoom: 14,
  );
  String googleAPiKey = "AIzaSyC3ewUluvF8EIkxqQlvJNe66-_gKhYx-L8";
  final List<Marker> _markers = <Marker>[];

  loadData() {
    getCurrentLocation().then((value) async {
      print("Lokasi Wisata");
      print(value.latitude.toString() + "" + value.longitude.toString());

      _markers.add(
        Marker(
            markerId: const MarkerId('2'),
            position:
                LatLng(double.parse(widget.lat!), double.parse(widget.lang!)),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            infoWindow: InfoWindow(
              title: widget.name,
              snippet: widget.alamat,
            ),
            onTap: () {
              _customInfoWindowController!.addInfoWindow!(
                Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 300,
                          height: 100,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: widget.img != null
                                      ? NetworkImage("${widget.img}")
                                      : NetworkImage(
                                          'https://aksestryout.com/gis/img/${widget.foto!}'),
                                  fit: BoxFit.fitWidth),
                              borderRadius: BorderRadius.circular(10.0)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, left: 8.0, right: 8.0),
                          child: Text(widget.name!,
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Text(widget.alamat!,
                              style: TextStyle(fontSize: 10.sp)),
                        ),
                      ],
                    ),
                    height: 300,
                    width: 200,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10.0))),
                LatLng(double.parse(widget.lat!), double.parse(widget.lang!)),
              );
            }),
      );
      CameraPosition cameraPosition = CameraPosition(
          zoom: 15.0,
          target:
              LatLng(double.parse(widget.lat!), double.parse(widget.lang!)));
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      setState(() {});
    });
  }

  Future<Position> getCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      ("Error$error");
    });
    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    super.initState();
    loadData();
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
              "Map Lokasi,",
              style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
            ),
            Text(
              "Cari rute terbaik anda!",
              style: TextStyle(fontSize: 14.sp),
            ),
          ],
        ),
      ),
      body: Stack(children: [
        GoogleMap(
          zoomControlsEnabled: false,
          tiltGesturesEnabled: true,
          compassEnabled: true,
          scrollGesturesEnabled: true,
          initialCameraPosition: _kGooglePlex,
          markers: Set<Marker>.of(_markers),
          mapType: MapType.normal,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            _customInfoWindowController!.googleMapController = controller;
          },
          onTap: (position) {},
        ),
        CustomInfoWindow(
            controller: _customInfoWindowController!,
            height: 150,
            width: 300,
            offset: 35)
      ]),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kblue,
        onPressed: loadData,
        tooltip: 'Go to location',
        child: const Icon(Icons.my_location),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
    );
  }
}
