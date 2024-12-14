class QuestionModel {
  final List<int> numbers;
  final int correctAnswer;
  final String operation;
  List<int> options;
  bool isAnswered;
  bool? isCorrect;

  QuestionModel({
    required this.numbers,
    required this.correctAnswer,
    required this.operation,
    List<int>? options,
    this.isAnswered = false,
    this.isCorrect,
  }) : options = options ?? [];

  String get questionText {
    return '${numbers[0]} $operation ${numbers[1]} = ?';
  }
}
