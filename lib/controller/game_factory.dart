import 'base_controller.dart';
import 'addition_controller.dart';
import 'subtraction_controller.dart';
import 'multiplication_controller.dart';
import 'division_controller.dart';
import 'plus_grid_controller.dart';
import 'minus_grid_controller.dart';
import 'judgement_controller.dart';

class GameControllerFactory {
  static BaseGameController createController(String gameType, {String? gameName}) {
    if (gameName == 'Plus Grid') {
      return PlusGridController();
    }
    if (gameName == 'Minus Grid') {
      return MinusGridController();
    }
    if (gameName == 'Judgement') {
      return JudgementController(gameType: 'addition');
    }
    if (gameName == 'Judge It') {
      return JudgementController(gameType: 'subtraction');
    }
    if (gameName == 'Perfect Mul') {
      return JudgementController(gameType: 'multiplication');
    }
    if (gameName == 'Side Quest') {
      return JudgementController(gameType: 'division');
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
