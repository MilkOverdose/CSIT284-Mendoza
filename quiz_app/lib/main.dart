import 'package:flutter/material.dart';

void main() {
  runApp(const QuizApp());
}

const Color kBackground = Color.fromARGB(255, 83, 42, 155);
const Color kAnswerButton = Color.fromARGB(255, 45, 20, 85);
const Color kQuestionText = Color.fromARGB(255, 199, 155, 255);
const Color kCorrectBadge = Color.fromARGB(255, 90, 170, 255);
const Color kWrongBadge = Color.fromARGB(255, 230, 90, 200);
const Color kFadedText = Color.fromARGB(255, 170, 140, 210);

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const QuizHome(),
    );
  }
}

class Question {
  final String text;
  final List<String> options;
  final String correctAnswer;

  const Question({
    required this.text,
    required this.options,
    required this.correctAnswer,
  });
}

final List<Question> questions = [
  const Question(
    text: 'What are the main building blocks of Flutter UIs?',
    options: ['Blocks', 'Components', 'Widgets', 'Functions'],
    correctAnswer: 'Widgets',
  ),
  const Question(
    text: 'How are Flutter UIs built?',
    options: [
      'By combining widgets in a visual editor',
      'By using XCode for iOS and Android Studio for Android',
      'By combining widgets in code',
      'By defining widgets in config files',
    ],
    correctAnswer: 'By combining widgets in code',
  ),
  const Question(
    text: "What's the purpose of a StatefulWidget?",
    options: [
      'Ignore data changes',
      'Update UI as data changes',
      'Only render static text',
      'Replace the MaterialApp',
    ],
    correctAnswer: 'Update UI as data changes',
  ),
  const Question(
    text: 'Which widget should you try to use more often: '
        'StatelessWidget or StatefulWidget?',
    options: [
      'None of the above',
      'StatelessWidget',
      'StatefulWidget',
      'Both are equally recommended',
    ],
    correctAnswer: 'StatelessWidget',
  ),
  const Question(
    text: 'What happens if you change data in a StatelessWidget?',
    options: [
      'The UI is not updated',
      'The UI updates automatically',
      'The app crashes',
      'A new widget is created',
    ],
    correctAnswer: 'The UI is not updated',
  ),
  const Question(
    text: 'How should you update data inside of StatefulWidgets?',
    options: [
      'By calling setState()',
      'By editing the widget directly',
      'By restarting the app',
      'Data cannot be updated',
    ],
    correctAnswer: 'By calling setState()',
  ),
];

class QuizHome extends StatefulWidget {
  const QuizHome({super.key});

  @override
  State<QuizHome> createState() => _QuizHomeState();
}

enum QuizStage { start, quiz, results }

class _QuizHomeState extends State<QuizHome> {
  QuizStage stage = QuizStage.start;
  int currentQuestionIndex = 0;
  List<String> selectedAnswers = [];

  void startQuiz() {
    setState(() {
      stage = QuizStage.quiz;
      currentQuestionIndex = 0;
      selectedAnswers = [];
    });
  }

  void selectAnswer(String answer) {
    setState(() {
      selectedAnswers.add(answer);
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
      } else {
        stage = QuizStage.results;
      }
    });
  }

  void restartQuiz() {
    setState(() {
      stage = QuizStage.quiz;
      currentQuestionIndex = 0;
      selectedAnswers = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    switch (stage) {
      case QuizStage.start:
        body = StartScreen(onStart: startQuiz);
        break;
      case QuizStage.quiz:
        body = QuizScreen(
          question: questions[currentQuestionIndex],
          onSelect: selectAnswer,
        );
        break;
      case QuizStage.results:
        body = ResultsScreen(
          answers: selectedAnswers,
          onRestart: restartQuiz,
        );
        break;
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: kBackground),
        width: double.infinity,
        height: double.infinity,
        child: SafeArea(child: body),
      ),
    );
  }
}

class StartScreen extends StatelessWidget {
  final VoidCallback onStart;

  const StartScreen({super.key, required this.onStart});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/logo.png', width: 200),
          const SizedBox(height: 50),
          const Text(
            'Learn Flutter the fun way!',
            style: TextStyle(fontSize: 20, color: Colors.white70),
          ),
          const SizedBox(height: 20),
          TextButton.icon(
            onPressed: onStart,
            style: TextButton.styleFrom(
              shape: const RoundedRectangleBorder(),
            ),
            icon: const Icon(Icons.arrow_right_alt, color: Colors.white70),
            label: const Text(
              'Start Quiz',
              style: TextStyle(fontSize: 15, color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }
}

class QuizScreen extends StatelessWidget {
  final Question question;
  final ValueChanged<String> onSelect;

  const QuizScreen({
    super.key,
    required this.question,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            question.text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: kQuestionText,
            ),
          ),
          const SizedBox(height: 40),
          ...question.options.map(
            (option) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => onSelect(option),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kAnswerButton,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: const StadiumBorder(),
                  ),
                  child: Text(
                    option,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ResultsScreen extends StatelessWidget {
  final List<String> answers;
  final VoidCallback onRestart;

  const ResultsScreen({
    super.key,
    required this.answers,
    required this.onRestart,
  });

  int get correctCount {
    int count = 0;
    for (int i = 0; i < answers.length; i++) {
      if (answers[i] == questions[i].correctAnswer) count++;
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        children: [
          Text(
            'You answered $correctCount out of '
            '${questions.length} questions correctly!',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: kQuestionText,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              itemCount: questions.length,
              itemBuilder: (context, index) {
                final question = questions[index];
                final userAnswer = answers[index];
                final isCorrect = userAnswer == question.correctAnswer;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundColor:
                            isCorrect ? kCorrectBadge : kWrongBadge,
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              question.text,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            if (!isCorrect)
                              Text(
                                userAnswer,
                                style: const TextStyle(
                                  color: kFadedText,
                                  fontSize: 13,
                                ),
                              ),
                            Text(
                              question.correctAnswer,
                              style: TextStyle(
                                color: isCorrect ? Colors.white : kCorrectBadge,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          TextButton.icon(
            onPressed: onRestart,
            icon: const Icon(Icons.refresh, color: Colors.white),
            label: const Text(
              'Restart Quiz!',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}