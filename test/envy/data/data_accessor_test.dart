@TestOn('browser')
import 'package:test/test.dart';
import 'package:envy/envy.dart';

main() {
  group('getData', () {
    test('keyed property', () {
      DataAccessor a = new DataAccessor.prop("x", keyProp: "id");

      Object dataset = [{"id": "id1", "x": 10}, {"id": "id2", "x": 20}, {"id": "id3", "x": 30},];
      Object data = a.getData(dataset);
      expect(data is List, true);
      List dataList = data as List;
      expect(dataList.length, 3);
      expect(dataList[0], 10);
      expect(dataList[1], 20);
      expect(dataList[2], 30);

      // Change order
      Object dataset2 = [{"id": "id2", "x": 10}, {"id": "id3", "x": 20}, {"id": "id1", "x": 30},];
      data = a.getData(dataset2);
      expect(data is List, true);
      dataList = data as List;
      expect(dataList.length, 3);
      expect(dataList[0], 30);
      expect(dataList[1], 10);
      expect(dataList[2], 20);

      // Expansion and hole
      Object dataset3 = [
        {"id": "id3", "x": 100},
        {"id": "id4", "x": 200},
        {"id": "id5", "x": 300},
        {"id": "id1", "x": 400},
        {"id": "id6", "x": 500}
      ];
      data = a.getData(dataset3);
      expect(data is List, true);
      dataList = data as List;
      expect(dataList.length, 6);
      expect(dataList[0], 400);
      expect(dataList[1], dataNotAvailable);
      expect(dataList[2], 100);
      expect(dataList[3], 200);
      expect(dataList[4], 300);
      expect(dataList[5], 500);

      // All new
      Object dataset4 = [{"id": "id7", "x": 700}, {"id": "id8", "x": 800}, {"id": "id9", "x": 900}];
      data = a.getData(dataset4);
      expect(data is List, true);
      dataList = data as List;
      expect(dataList.length, 9);
      expect(dataList[0], dataNotAvailable);
      expect(dataList[1], dataNotAvailable);
      expect(dataList[2], dataNotAvailable);
      expect(dataList[3], dataNotAvailable);
      expect(dataList[4], dataNotAvailable);
      expect(dataList[5], dataNotAvailable);
      expect(dataList[6], 700);
      expect(dataList[7], 800);
      expect(dataList[8], 900);

      // Reuse some old ones
      Object dataset5 = [{"id": "id3", "x": 333}, {"id": "id5", "x": 555}, {"id": "id1", "x": 111}];
      data = a.getData(dataset5);
      expect(data is List, true);
      dataList = data as List;
      expect(dataList.length, 9);
      expect(dataList[0], 111);
      expect(dataList[1], dataNotAvailable);
      expect(dataList[2], 333);
      expect(dataList[3], dataNotAvailable);
      expect(dataList[4], 555);
      expect(dataList[5], dataNotAvailable);
      expect(dataList[6], dataNotAvailable);
      expect(dataList[7], dataNotAvailable);
      expect(dataList[8], dataNotAvailable);
    });

    test('cullUnavailableData', () {
      DataAccessor a = new DataAccessor.prop("x", keyProp: "id");

      Object dataset = [
        {"id": "id1", "x": 10},
        {"id": "id2", "x": 20},
        {"id": "id3", "x": 30},
        {"id": "id4", "x": 30},
        {"id": "id5", "x": 30},
        {"id": "id6", "x": 30},
        {"id": "id7", "x": 30},
        {"id": "id8", "x": 30},
        {"id": "id9", "x": 30}
      ];
      Object data = a.getData(dataset);
      print(a.propOrderingMap["x"]);

      // omit 4 and 7
      Object dataset2 = [
        {"id": "id1", "x": 1},
        {"id": "id2", "x": 2},
        {"id": "id3", "x": 3},
        {"id": "id5", "x": 4},
        {"id": "id6", "x": 5},
        {"id": "id8", "x": 6},
        {"id": "id9", "x": 7}
      ];
      data = a.getData(dataset2);
      print(a.propOrderingMap["x"]);

      /*
      //print(a.propOrderingMap["x"]);
      expect(data is List, true);
      List dataList = data as List;
      expect(dataList.length, 9);
      expect(dataList[0], 10);
      expect(dataList[1], 20);
      expect(dataList[2], 30);
      expect(dataList[3], dataNotAvailable);
      expect(dataList[4], 30);
      expect(dataList[5], 30);
      expect(dataList[6], dataNotAvailable);
      expect(dataList[7], 30);
      expect(dataList[8], 30);*/

      a.cullUnavailableData();
      print(a.propOrderingMap["x"]);
    });
  });
}
