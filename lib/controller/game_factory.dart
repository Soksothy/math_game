import 'base_controller.dart';
import 'addition_controller.dart';
import 'subtraction_controller.dart';
import 'multiplication_controller.dart';
import 'division_controller.dart';
import 'plus_grid_controller.dart';

class GameControllerFactory {
  static BaseGameController createController(String gameType, {String? gameName}) {
    if (gameName == 'Plus Grid') {
      return PlusGridController();
    }
    
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
