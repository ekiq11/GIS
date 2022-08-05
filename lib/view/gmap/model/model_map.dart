// To parse this JSON data, do
//
//     final mapsModel = mapsModelFromJson(jsonString);

import 'dart:convert';

List<MapsModel> mapsModelFromJson(String str) =>
    List<MapsModel>.from(json.decode(str).map((x) => MapsModel.fromJson(x)));

String mapsModelToJson(List<MapsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MapsModel {
  MapsModel({
    this.idWisata,
    this.nmWisata,
    this.alamat,
    this.latitudeLoc,
    this.longitudeLoc,
    this.deskripsi,
    this.hargaTiket,
    this.jamBuka,
    this.jamTutup,
    this.foto,
    this.linkVideo,
    this.rating,
    this.ket,
    this.idJenis,
  });

  String? idWisata;
  String? nmWisata;
  String? alamat;
  String? latitudeLoc;
  String? longitudeLoc;
  String? deskripsi;
  String? hargaTiket;
  String? jamBuka;
  String? jamTutup;
  String? foto;
  String? linkVideo;
  String? rating;
  String? ket;
  String? idJenis;

  factory MapsModel.fromJson(Map<String, dynamic> json) => MapsModel(
        idWisata: json["id_wisata"],
        nmWisata: json["nm_wisata"],
        alamat: json["alamat"],
        latitudeLoc: json["latitude_loc"],
        longitudeLoc: json["longitude_loc"],
        deskripsi: json["deskripsi"],
        hargaTiket: json["harga_tiket"],
        jamBuka: json["jam_buka"],
        jamTutup: json["jam_tutup"],
        foto: json["foto"],
        linkVideo: json["link_video"],
        rating: json["rating"],
        ket: json["ket"],
        idJenis: json["id_jenis"],
      );

  Map<String, dynamic> toJson() => {
        "id_wisata": idWisata,
        "nm_wisata": nmWisata,
        "alamat": alamat,
        "latitude_loc": latitudeLoc,
        "longitude_loc": longitudeLoc,
        "deskripsi": deskripsi,
        "harga_tiket": hargaTiket,
        "jam_buka": jamBuka,
        "jam_tutup": jamTutup,
        "foto": foto,
        "link_video": linkVideo,
        "rating": rating,
        "ket": ket,
        "id_jenis": idJenis,
      };
}
