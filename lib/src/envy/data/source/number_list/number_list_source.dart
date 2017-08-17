import '../data_source.dart';
import '../../../graphic/twod/number_list.dart';

abstract class NumberListSource extends DataSource<NumberList> {}

class NumberListConstant extends ArrayDataSource<NumberList> implements NumberListSource {
  NumberListConstant(NumberList numberList) {
    this.values.add(numberList);
  }

  NumberListConstant.array(List<NumberList> numberLists) {
    this.values.addAll(numberLists);
  }

  // No-op refresh
  void refresh() {}
}