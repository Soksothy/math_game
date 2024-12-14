import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:math_game/models/user_model.dart';
import 'package:math_game/services/user_storage.dart';  // Add this import


class CreateAgeScreen extends StatefulWidget {
  const CreateAgeScreen({super.key});

  @override
  State<CreateAgeScreen> createState() => CreateAgeScreenState();
}

class CreateAgeScreenState extends State<CreateAgeScreen> {
  String age = '5';  // Changed from empty string to '5'
  late UserModel userModel;
  bool isInitialized = false;
  bool? isBoySelected;  // This will be initialized from userModel

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInitialized) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      userModel = args?['userModel'] as UserModel;
      isBoySelected = userModel.isBoy;  // Set isBoySelected from userModel
      isInitialized = true;
    }
  }

  void showValidationSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF74CF48),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 1800),
        margin: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 10,
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).size.height - 150,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Create Profile',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 30,
          ),
        ),
        leading: IconButton(
          icon: Image.asset('lib/asset/back_icon.png', width: 200, height: 200),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(
              '/create',
              arguments: {
                'userModel': userModel,
              },
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 40), // Reduced from 44
              // Display selected gender options (disabled)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(  // Replace GestureDetector with Container since we don't want it to be interactive
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: userModel.isBoy  // Use userModel.isBoy instead of isBoySelected
                          ? const Color(0xFF74CF48)
                          : const Color(0xFFE5E5E5),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Boy',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                            color: userModel.isBoy ? Colors.white : Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Image.asset('lib/asset/boy.png', width: 40, height: 40),
                      ],
                    ),
                  ),
                  Container(  // Replace GestureDetector with Container since we don't want it to be interactive
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: !userModel.isBoy
                          ? const Color(0xFFFF69B4)
                          : const Color(0xFFE5E5E5),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Girl',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                            color: !userModel.isBoy ? Colors.white : Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Image.asset('lib/asset/girl.png', width: 40, height: 40),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30), // Reduced from 50
              // Avatar display
              SizedBox(
                height: 350, // Reduced from 400
                child: PageView.builder(
                  itemCount: 13,
                  controller: PageController(
                    initialPage: userModel.avatarIndex
                  ),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'lib/asset/avatar/${index + 1}.png',
                        width: 1200,
                        height: 1200,
                        fit: BoxFit.contain,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20), // Reduced from 35
              AgeCarousel(
                selectedAge: age,
                onAgeSelected: (newAge) {
                  setState(() {
                    age = newAge;
                  });
                },
              ),
              const SizedBox(height: 20), // Reduced from 40
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: SizedBox(
                  width: 400,
                  child: ElevatedButton(
                    onPressed: () async {
                      // Update age in userModel
                      userModel.age = int.parse(age);
                      
                      // Save user data
                      await UserStorage.saveUser(userModel);
                      
                      if (mounted) {
                        // Navigate to home screen
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          '/home',
                          (Route<dynamic> route) => false,
                          arguments: {
                            'userModel': userModel,
                          }
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF74CF48),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AgeCarousel extends StatefulWidget {
  final Function(String) onAgeSelected;
  final String selectedAge;

  const AgeCarousel({
    required this.onAgeSelected,
    required this.selectedAge,
    super.key,
  });

  @override
  State<AgeCarousel> createState() => _AgeCarouselState();
}

class _AgeCarouselState extends State<AgeCarousel> {
  late PageController _pageController;
  final int minAge = 2;
  final int maxAge = 18;

  @override
  void initState() {
    super.initState();
    int initialPage = widget.selectedAge.isEmpty 
        ? 3  // Changed from 0 to 3 (5-2=3) to show age 5 by default
        : int.parse(widget.selectedAge) - minAge;
    _pageController = PageController(
      viewportFraction: 0.3,
      initialPage: initialPage,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateAge(bool next) {
    if (next && _pageController.page! < maxAge - minAge) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      HapticFeedback.lightImpact();
    } else if (!next && _pageController.page! > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      HapticFeedback.lightImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Your Age",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF525252),
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 30),
        SizedBox(
          height: 120,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildArrowButton(false),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    widget.onAgeSelected((index + minAge).toString());
                    HapticFeedback.selectionClick();
                  },
                  itemCount: maxAge - minAge + 1,
                  itemBuilder: (context, index) {
                    final currentAge = (index + minAge).toString();
                    final isSelected = currentAge == widget.selectedAge;
                    
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOutCubic,
                      child: Transform.scale(
                        scale: isSelected ? 1.0 : 0.7,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            color: isSelected 
                                ? const Color(0xFF74CF48) 
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: isSelected ? [
                              BoxShadow(
                                color: const Color(0xFF74CF48).withOpacity(0.3),
                                blurRadius: 12,
                                spreadRadius: 2,
                              )
                            ] : [],
                          ),
                          child: Center(
                            child: Text(
                              currentAge,
                              style: TextStyle(
                                fontSize: isSelected ? 48 : 36,
                                fontWeight: FontWeight.bold,
                                color: isSelected 
                                    ? Colors.white 
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              _buildArrowButton(true),
            ],
          ),
        ),
      ],
    );
  }


  Widget _buildArrowButton(bool isNext) {
    return GestureDetector(
      onTap: () => _navigateAge(isNext),
      child: Container(
        width: 50,
        height: 50,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFE5E5E5),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Icon(
          isNext ? Icons.chevron_right : Icons.chevron_left,
          color: const Color(0xFF525252),
          size: 30,
        ),
      ),
    );
  }
}
