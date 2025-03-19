import 'package:quizz_app/models/category.dart';
import 'package:quizz_app/models/question.dart';

final List<Category> categories = [
  Category(
    name: 'Science',
    icon: '🔬',
    questions: [
      Question(
        questionText: 'What is the chemical symbol for gold?',
        options: ['Au', 'Ag', 'Fe', 'Cu'],
        correctAnswerIndex: 0,
      ),
      Question(
        questionText: 'Which planet is known as the Red Planet?',
        options: ['Venus', 'Mars', 'Jupiter', 'Saturn'],
        correctAnswerIndex: 1,
      ),
      Question(
        questionText: 'What is the largest organ in the human body?',
        options: ['Heart', 'Brain', 'Liver', 'Skin'],
        correctAnswerIndex: 3,
      ),
      Question(
        questionText: 'What is the speed of light?',
        options: ['299,792 km/s', '199,792 km/s', '399,792 km/s', '499,792 km/s'],
        correctAnswerIndex: 0,
      ),
      Question(
        questionText: 'What is the hardest natural substance on Earth?',
        options: ['Gold', 'Iron', 'Diamond', 'Platinum'],
        correctAnswerIndex: 2,
      ),
    ],
  ),
  Category(
    name: 'History',
    icon: '📚',
    questions: [
      Question(
        questionText: 'Who was the first President of the United States?',
        options: ['John Adams', 'Thomas Jefferson', 'George Washington', 'Benjamin Franklin'],
        correctAnswerIndex: 2,
      ),
      Question(
        questionText: 'In which year did World War II end?',
        options: ['1943', '1944', '1945', '1946'],
        correctAnswerIndex: 2,
      ),
      Question(
        questionText: 'Which empire was ruled by Caesar?',
        options: ['Greek', 'Persian', 'Roman', 'Ottoman'],
        correctAnswerIndex: 2,
      ),
      Question(
        questionText: 'Who painted the Mona Lisa?',
        options: ['Van Gogh', 'Da Vinci', 'Picasso', 'Michelangelo'],
        correctAnswerIndex: 1,
      ),
      Question(
        questionText: 'Which civilization built the pyramids?',
        options: ['Roman', 'Greek', 'Egyptian', 'Persian'],
        correctAnswerIndex: 2,
      ),
    ],
  ),
];
