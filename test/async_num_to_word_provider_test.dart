import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:calculator_converters/providers/num_to_word_provider.dart';

void main() {
  group('NumToWordNotifier Provider Async Isolate Integration Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('Initial state is empty zero default', () {
      final state = container.read(numToWordProvider);
      expect(state.inputExpression, '');
      expect(state.evaluatedValue, 0);
      expect(state.englishWord, 'Zero');
      expect(state.hindiWord, 'शून्य');
      expect(state.bengaliWord, 'শূন্য');
    });

    test('onKeypadInput updates state and processes async isolate word output', () async {
      final notifier = container.read(numToWordProvider.notifier);
      
      notifier.onKeypadInput('1');
      notifier.onKeypadInput('2');
      notifier.onKeypadInput('3');

      // Allow microtasks and isolate calculation to complete
      await Future.delayed(const Duration(milliseconds: 50));

      final state = container.read(numToWordProvider);
      expect(state.inputExpression, '123');
      expect(state.evaluatedValue, 123);
      expect(state.englishWord, 'One Hundred Twenty Three');
      expect(state.hindiWord, 'एक सौ तेईस');
      expect(state.bengaliWord, 'একশত তেইশ');
    });

    test('onKeypadInput Clear resets state cleanly', () async {
      final notifier = container.read(numToWordProvider.notifier);
      
      notifier.onKeypadInput('5');
      notifier.onKeypadInput('0');
      await Future.delayed(const Duration(milliseconds: 50));
      expect(container.read(numToWordProvider).evaluatedValue, 50);

      notifier.onKeypadInput('C');
      expect(container.read(numToWordProvider).inputExpression, '');
    });
  });
}
