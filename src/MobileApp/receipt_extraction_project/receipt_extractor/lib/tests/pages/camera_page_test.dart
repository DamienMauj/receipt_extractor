import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_extractor/pages/camera_page.dart';
import 'package:image_picker/image_picker.dart';


void main() { 
    
    group("camera page initialization", () {
      testWidgets("camera page initializes with no image", (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: CameraPage()));
        await tester.pump();
        expect(find.byKey(const Key("Camera Page")), findsOneWidget);
        expect(find.byKey(const Key("No Image Selected Message")), findsOneWidget);
        expect(find.byKey(const Key("Open Camera Button")), findsOneWidget);
        expect(find.byKey(const Key("Open Gallery Button")), findsOneWidget);
        expect(find.byKey(const Key("Extract Button")), findsNothing);
      });

      testWidgets("Test Camera Popup", (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: CameraPage()));
        await tester.pump();
        await tester.tap(find.byKey(const Key("Open Camera Button")));
        await tester.pump(const Duration(seconds: 1));
        expect(find.byKey(const Key("Camera Popup Widget")), findsOneWidget);
      });

      // TODO: Find a way to test the camera roll popup
      // testWidgets("Test Gallery Popup", (WidgetTester tester) async {
      //   await tester.pumpWidget(MaterialApp(home: CameraPage()));
      //   await tester.pump();
      //   await tester.tap(find.byKey(const Key("Open Gallery Button")));
      //   await tester.pump(const Duration(seconds: 1));
      //   expect(find.byKey(const Key("Gallery Popup Widget")), findsOneWidget);
      // });

      testWidgets("test initialisation with image", (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: CameraPage(initialImageFile: XFile("lib/tests/assets/image.png"))));
        await tester.pump();
        expect(find.byKey(const Key("Camera Page")), findsOneWidget);
        expect(find.byKey(const Key("No Image Selected Message")), findsNothing);
        expect(find.byKey(const Key("Open Camera Button")), findsOneWidget);
        expect(find.byKey(const Key("Open Gallery Button")), findsOneWidget);
        expect(find.byKey(const Key("Extract Button")), findsOneWidget);
      });


    
    });

    
}