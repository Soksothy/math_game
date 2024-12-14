import 'base_controller.dart';
import 'addition_controller.dart';
import 'subtraction_controller.dart';
import 'multiplication_controller.dart';
import 'division_controller.dart';

class GameControllerFactory {
  static BaseGameController createController(String gameType) {
    switch (gameType.toLowerCase()) {
      case 'addition':
        return AdditionGameController();
      case 'subtraction':
        return SubtractionGameController();
      case 'multiplication':
        return MultiplicationGameController();
      case 'division':
        return DivisionGameController();
      default:
        throw ArgumentError('Invalid game type: $gameType');
    }
  }
}
