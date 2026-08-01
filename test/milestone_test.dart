import 'package:flutter_test/flutter_test.dart';
import 'package:gun_sayac/models/milestone.dart';

void main() {
  test('resolveForDay picks exact then nearest previous', () {
    const pack = HabitContentPack(
      habitId: 'smoking',
      disclaimer: 'x',
      milestones: [
        Milestone(day: 1, title: 'd1', body: 'b1'),
        Milestone(day: 3, title: 'd3', body: 'b3'),
        Milestone(day: 7, title: 'd7', body: 'b7'),
      ],
    );
    expect(pack.resolveForDay(1).title, 'd1');
    expect(pack.resolveForDay(3).title, 'd3');
    expect(pack.resolveForDay(5).title, 'd3');
    expect(pack.resolveForDay(10).title, 'd7');
  });

  test('templateMotivation cycles', () {
    const pack = HabitContentPack(
      habitId: 'diet',
      disclaimer: 'x',
      milestones: [],
      fallbackMotivation: ['a', 'b'],
    );
    expect(pack.templateMotivation(1), 'a');
    expect(pack.templateMotivation(2), 'b');
    expect(pack.templateMotivation(3), 'a');
  });
}