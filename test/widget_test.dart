import 'package:flutter_test/flutter_test.dart';
import 'package:worktrack_pro/main.dart';

void main() {
  testWidgets('App starts', (tester) async {
    await tester.pumpWidget(const WorkTrackProApp());
    expect(find.text('WorkTrack Pro'), findsOneWidget);
  });
}
