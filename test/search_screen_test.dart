import 'package:edutrack/features/search/controllers/search_controller.dart';
import 'package:edutrack/features/search/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  testWidgets('search error state fits above the keyboard', (tester) async {
    addTearDown(Get.reset);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetViewInsets);
    addTearDown(tester.view.resetDevicePixelRatio);
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 640);
    tester.view.viewInsets = const FakeViewPadding(bottom: 300);

    await tester.pumpWidget(
      const GetMaterialApp(home: SearchScreen(role: 'teacher')),
    );
    Get.find<AppSearchController>(tag: 'search_teacher').errorMessage.value =
        'I could not understand the search response. Please rephrase the question.';
    await tester.pumpAndSettle();

    expect(find.text('Quick searches'), findsNothing);
    expect(find.textContaining('could not understand'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
