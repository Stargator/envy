import 'dart:math' show min, max;
import '../number_list/number_list_source.dart';
import 'point_list_source.dart';
import '../geo/projection_source.dart';
import '../data_source.dart';
import '../../../graphic/twod/number_list.dart';
import '../../../graphic/twod/point_list.dart';
import '../../../geo/projections.dart';

/*
class GeoPointListAngles extends ArrayDataSource<PointList> implements PointListSource {
  ProjectionSource projSource;
  AngleSource latSource;
  AngleSource longSource;

  GeoPointListAngles(this.projSource, this.latSource, this.longSource);

  PointList valueAt(int i) {

    projSource.valueAt(i).toPoint(latSource.valueAt(i));

    //TODO check for nulls?
    //return new Color(red.valueAt(i), green.valueAt(i), blue.valueAt(i));
  }

  int get rawSize => Math.max(Math.max(projSource.rawSize, latSource.rawSize), longSource.rawSize);

  // No-op refresh
  void refresh();

}
*/

class GeoPointListDegrees extends ArrayDataSource<PointList> implements PointListSource {
  ProjectionSource projSource;
  NumberListSource latListSource;
  NumberListSource longListSource;

  GeoPointListDegrees(this.projSource, {this.latListSource, this.longListSource} );

  /*
  PointList valueAt(int i) {
    var pts = new PointList();
    var proj = projSource.valueAt(i);
    var lats = latListSource.valueAt(i);
    var longs = longListSource.valueAt(i);

    // Only create points for which both lat and long are available
    int numPoints = lats?.length ?? 0;
    if(numPoints > 0 && numPoints != longs.length) {
      numPoints = Math.min(lats.length, longs.length);
    }
    for(int p=0; p<numPoints; p++) {
      pts.addPoint(proj.degreesToPoint(latDeg: lats[p], longDeg: longs[p]));
    }

    print("INDEX $i");
    print(pts);
    return pts;
  }*/


  /// Refreshes the member sources.
  ///
  void refresh() {
    projSource.refresh();
    latListSource.refresh();
    longListSource.refresh();

    values.clear();
    int size = max(projSource.rawSize, max(latListSource.rawSize, longListSource.rawSize));
    for(int i = 0; i< size; i++) {
      var pts = new PointList();
      Projection proj = projSource.valueAt(i) as Projection;
      NumberList lats = latListSource.valueAt(i) as NumberList;
      NumberList longs = longListSource.valueAt(i) as NumberList;

      // Only create points for which both lat and long are available
      int numPoints = lats?.length ?? 0;
      if(numPoints > 0 && numPoints != longs.length) {
        numPoints = min(lats.length, longs.length);
      }
      for(int p=0; p<numPoints; p++) {
        pts.addPoint(proj.degreesToPoint(latDeg: lats[p], longDeg: longs[p]));
      }
      values.add(pts);
    }
  }

}
