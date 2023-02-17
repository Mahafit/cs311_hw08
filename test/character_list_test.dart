import 'package:flutter/material.dart';
import 'package:cs311hw08/character_detail.dart';
import 'package:cs311hw08/character_list.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'character_list_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  testWidgets('return as ListView', (widgertester) async {
    // testWidgets that return Listview
    final client = MockClient(); // create a mock client

    when(client.get(Uri.parse(
        'https://api.genshin.dev/characters'))) // when client get the url
        .thenAnswer((_) async => http.Response(
        '["albedo","aloy","amber","arataki-itto","ayaka","ayato"]',
        200)); // return the response

    await widgertester.pumpWidget(MaterialApp(
        home:
        Scaffold(body: CharacterList(client: client)))); // pump the widget
    await widgertester.pumpAndSettle(); // pump and settle
    // pumpwidget is to build the widget
    // pumpandsettle is to wait for the widget to be built

    final findListView = find.byType(ListView); // find the listview

    expect(findListView,
        findsOneWidget); // expect the listview to be found from character_list.dart line 22-40
    // findsOneWidget is to check if the widget is found
  });

  testWidgets('ListView not found', (widgertester) async {
    final client = MockClient();

    when(client.get(Uri.parse('https://api.genshin.dev/characters')))
        .thenAnswer((_) async => http.Response('Not Found', 404)); // return 404

    await widgertester.pumpWidget(
        MaterialApp(home: Scaffold(body: CharacterList(client: client))));
    await widgertester.pumpAndSettle();

    final findListView = find.byType(ListView); // find the listview
    final findText =
    find.byType(Text); // find the text from character_list.dart line 41-43

    expect(findListView, findsNothing); // expect the listview to be not found
    expect(findText, findsOneWidget); // expect the text to be found
    // findsNothing is to check if the widget is not found
  });

  testWidgets('it should return at least one ListTile ', (widgertester) async {
    // if the listview is found,
    final client = MockClient();

    when(client.get(Uri.parse('https://api.genshin.dev/characters')))
        .thenAnswer((_) async => http.Response(
        '["albedo","aloy","amber","arataki-itto","ayaka","ayato"]', 200));

    await widgertester.pumpWidget(
        MaterialApp(home: Scaffold(body: CharacterList(client: client))));
    await widgertester.pumpAndSettle();

    final findListView = find.byType(
        ListTile); // find the listtile from character_list.dart line 26-38

    expect(findListView, findsWidgets);
  });

  testWidgets(
      'tab a ListTile should navigate to CharacterDetail', // if the listtile is found, it should be able to tap and navigate to character_detail.dart
          (widgertester) async {
        final client = MockClient();

        when(client.get(Uri.parse('https://api.genshin.dev/characters')))
            .thenAnswer((_) async => http.Response(
            '["albedo","aloy","amber","arataki-itto","ayaka","ayato"]', 200));

        await widgertester.pumpWidget(
            MaterialApp(home: Scaffold(body: CharacterList(client: client))));
        await widgertester.pumpAndSettle();

        await widgertester.tapAt(widgertester
            .getCenter(find.byType(ListTile).first)); // tap the first listtile
        await widgertester.pumpAndSettle(); //

        final findCharacterDetail = find.byType(
            CharacterDetail); // find the character detail from character_list.dart line 33-36 that import from character_detail.dart
        // find bu type is to find the widget by type
        expect(findCharacterDetail, findsOneWidget);
      });
}