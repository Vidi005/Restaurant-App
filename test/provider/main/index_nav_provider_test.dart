import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/provider/main/index_nav_provider.dart';

void main() {
  late IndexNavProvider indexNavProvider;

  setUp(() {
    indexNavProvider = IndexNavProvider();
  });

  group('index navigation provider unit test', () {
    test('should return 0 when provider initialize', () {
      final initState = indexNavProvider.indexBottomNavBar;
      expect(initState, 0);
    });
  });
}
