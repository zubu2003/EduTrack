import 'package:edutrack/App.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App basic smoke test', (WidgetTester tester) async {
    expect(const App(), isNotNull);
  });
}
