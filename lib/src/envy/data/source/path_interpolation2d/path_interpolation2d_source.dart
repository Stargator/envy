import '../../../graphic/twod/enum/path_interpolation2d.dart';
import '../data_source.dart';

abstract class PathInterpolation2dSource extends DataSource<PathInterpolation2d> {}

class PathInterpolation2dConstant extends ArrayDataSource<PathInterpolation2d> implements PathInterpolation2dSource {
  static final PathInterpolation2dConstant linear = new PathInterpolation2dConstant(PathInterpolation2d.linear);

  PathInterpolation2dConstant(PathInterpolation2d interpolation) {
    values.add(interpolation);
  }

  PathInterpolation2dConstant.array(List<PathInterpolation2d> interpolation) {
    values.addAll(interpolation);
  }

  // No-op refresh
  @override
  void refresh() {}
}
