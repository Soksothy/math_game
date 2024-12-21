import 'package:flutter/material.dart';
import '../controller/plus_grid_controller.dart';
import 'number_pad.dart';

class PlusGrid extends StatefulWidget {
  final PlusGridController controller;
  final Function(bool) onAnswerValidated;

  const PlusGrid({
    super.key,
    required this.controller,
    required this.onAnswerValidated,
  });

  @override
  State<PlusGrid> createState() => _PlusGridState();
}

class _PlusGridState extends State<PlusGrid> {
  late List<FocusNode> focusNodes;
  int currentFocusIndex = 0;
  List<TextEditingController> textControllers = [];

  @override
  void initState() {
    super.initState();
    initializeFocusNodes();
    currentFocusIndex = widget.controller.getMaxLength() - 1;
  }

  void initializeFocusNodes() {
    int maxLength = widget.controller.getMaxLength();
    focusNodes = List.generate(maxLength, (index) => FocusNode());
    textControllers = List.generate(maxLength, (index) => TextEditingController());
  }

  @override
  void didUpdateWidget(PlusGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reset controllers when question changes
    int maxLength = widget.controller.getMaxLength();
    if (textControllers.length != maxLength) {
      // Dispose old controllers
      for (var controller in textControllers) {
        controller.dispose();
      }
      
      textControllers = List.generate(maxLength, (index) => TextEditingController());
      focusNodes = List.generate(maxLength, (index) => FocusNode());
      currentFocusIndex = maxLength - 1; // Reset to rightmost position
    } else {
      
      for (var controller in textControllers) {
        controller.clear();
      }
    }
  }

  @override
  void dispose() {
    for (var node in focusNodes) {
      node.dispose();
    }
    for (var controller in textControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void handleDigitInput(int columnIndex, String value) {
    if (value.isEmpty) return;
    final int digit = int.parse(value);

    setState(() {
      widget.controller.userAnswers[columnIndex] = digit;
      if (widget.controller.checkCarryOver(columnIndex)) {
        widget.controller.carryOvers[columnIndex + 1] = 1;
      }
    });

    // Check if all answers are filled
    if (!widget.controller.userAnswers.contains(null)) {
      bool isCorrect = widget.controller.validateFullAnswer();
      widget.onAnswerValidated(isCorrect);
      
      // Clear answers after delay
      Future.delayed(const Duration(seconds: 1), () {
        if (!mounted) return;
        // Clear all inputs
        for (var controller in textControllers) {
          controller.clear();
        }
        // Reset carry-overs and user answers
        setState(() {
          widget.controller.carryOvers = List.filled(widget.controller.getMaxLength() + 1, null);
          widget.controller.userAnswers = List.filled(widget.controller.getMaxLength(), null);
          currentFocusIndex = widget.controller.getMaxLength() - 1; // Reset to rightmost position
        });
      });
    } else if (currentFocusIndex > 0) {
  
      setState(() {
        currentFocusIndex--;
        focusNodes[currentFocusIndex].requestFocus();
      });
    }
  }

  void handleNumberInput(int number) {
    if (currentFocusIndex < 0 || currentFocusIndex >= textControllers.length) return;

    setState(() {
      textControllers[currentFocusIndex].text = number.toString();
      
      widget.controller.userAnswers[textControllers.length - 1 - currentFocusIndex] = number;
      
      // Check for carry over
      if (widget.controller.checkCarryOver(textControllers.length - 1 - currentFocusIndex)) {
        int carryOverIndex = textControllers.length - currentFocusIndex;
        if (carryOverIndex < widget.controller.carryOvers.length) {
          widget.controller.carryOvers[carryOverIndex] = 1;
        }
      }
      
      if (!widget.controller.userAnswers.contains(null)) {
        bool isCorrect = widget.controller.validateFullAnswer();
        widget.onAnswerValidated(isCorrect);
        
        if (isCorrect) {
          _showFeedback(true);
        } else {
          _showFeedback(false);
        }
        
        Future.delayed(const Duration(seconds: 1), () {
          if (!mounted) return;
          _resetInputs();
        });
      } else if (currentFocusIndex > 0) {
        
        currentFocusIndex--;
      }
    });
  }

  void _resetInputs() {
    setState(() {
      for (var controller in textControllers) {
        controller.clear();
      }
      widget.controller.carryOvers = List.filled(widget.controller.getMaxLength() + 1, null);
      widget.controller.userAnswers = List.filled(widget.controller.getMaxLength(), null);
    
      currentFocusIndex = textControllers.length - 1;
    });
  }

  void _showFeedback(bool isCorrect) {
    setState(() {
      for (int i = 0; i < textControllers.length; i++) {
        textControllers[i].text = widget.controller.userAnswers[i]?.toString() ?? '';
      }
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        for (int i = 0; i < textControllers.length; i++) {
          textControllers[i].clear();
        }
      });
    });
  }

  void clearCurrentInput() {
    if (currentFocusIndex >= 0 && currentFocusIndex < textControllers.length) {
      textControllers[currentFocusIndex].clear();
      widget.controller.userAnswers[currentFocusIndex] = null;
      setState(() {});
    }
  }

  void handleSubmit() {
    if (!widget.controller.userAnswers.contains(null)) {
      bool isCorrect = widget.controller.validateFullAnswer();
      widget.onAnswerValidated(isCorrect);
      
      // Show feedback for correct or incorrect answer
      if (isCorrect) {
        _showFeedback(true);
      } else {
        _showFeedback(false);
      }
      
      // Clear answers after delay
      Future.delayed(const Duration(seconds: 1), () {
        if (!mounted) return;
        _resetInputs();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final int maxLength = widget.controller.getMaxLength();
    final digits1Padded = List.filled(maxLength, -1);
    final digits2Padded = List.filled(maxLength, -1);
    
    for (int i = 0; i < widget.controller.digits1.length; i++) {
      digits1Padded[maxLength - 1 - i] = widget.controller.digits1[widget.controller.digits1.length - 1 - i];
    }
    
    for (int i = 0; i < widget.controller.digits2.length; i++) {
      digits2Padded[maxLength - 1 - i] = widget.controller.digits2[widget.controller.digits2.length - 1 - i];
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF6E3),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // First number row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < maxLength; i++)
                    Container(
                      width: 48,
                      height: 48,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: digits1Padded[i] == -1 ? Colors.transparent : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: digits1Padded[i] == -1 
                        ? null 
                        : Text(
                            digits1Padded[i].toString(),
                            style: const TextStyle(
                              fontSize: 32, 
                              fontFamily: 'Swiss',
                            ),
                          ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              // Operation symbol row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: (maxLength - 1) * 64.0), // Changed from left to right padding
                    child: const Text(
                      '+',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Swiss',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Second number row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < maxLength; i++)
                    Container(
                      width: 48, 
                      height: 48, 
                      margin: const EdgeInsets.symmetric(horizontal: 8), 
                      alignment: Alignment.center,  // Added alignment
                      decoration: BoxDecoration(
                        color: digits2Padded[i] == -1 ? Colors.transparent : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: digits2Padded[i] == -1 
                        ? null 
                        : Center(  // Wrapped Text in Center widget
                            child: Text(
                              digits2Padded[i].toString(),
                              style: const TextStyle(
                                fontSize: 32, 
                                fontFamily: 'Swiss',
                              ),
                            ),
                          ),
                    ),
                ],
              ),
              const Divider(height: 32, thickness: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < maxLength; i++)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          currentFocusIndex = i;
                        });
                      },
                      child: Container(
                        width: 48, 
                        height: 48, 
                        margin: const EdgeInsets.symmetric(horizontal: 8), // increased from 4
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: currentFocusIndex == i 
                              ? Colors.blue 
                              : Colors.grey.shade300,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          color: widget.controller.userAnswers[maxLength - 1 - i] != null
                              ? (widget.controller.validateColumn(maxLength - 1 - i) 
                                  ? Colors.green.shade100 
                                  : Colors.red.shade100)
                              : (i == currentFocusIndex ? Colors.blue.shade50 : Colors.white),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          widget.controller.userAnswers[maxLength - 1 - i]?.toString() ?? '',
                          style: const TextStyle(
                            fontSize: 32, 
                            fontFamily: 'Swiss',
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 35),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: clearCurrentInput,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF74CF48),
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Delete',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: handleSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF74CF48),
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Submit',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        NumberPad(
          onNumberSelected: handleNumberInput,
          textStyle: const TextStyle(
            fontFamily: 'Swiss',
            fontSize: 32,
          ),
        ),
      ],
    );
  }

  // Update back button handler
  void handleBack() {
    if (currentFocusIndex > 0) {
      setState(() {
        currentFocusIndex--;
        focusNodes[currentFocusIndex].requestFocus();
      });
    }
  }
}
