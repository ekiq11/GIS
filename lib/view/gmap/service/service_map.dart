import 'package:gis_tetebatu/view/gmap/model/model_map.dart';
import 'package:http/http.dart' as http;

import '../../../api/api.dart';

class MapsServices {
  static Future<List<MapsModel>> getMaps() async {
    try {
      final response = await http.get(Uri.parse(BaseURL.tampilMap));
      if (200 == response.statusCode) {
        final List<MapsModel> maps = mapsModelFromJson(response.body);
        return maps;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
