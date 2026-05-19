// lib/screens/trivia_screen.dart

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/destination.dart';
import '../services/database_service.dart';

class TriviaScreen extends StatefulWidget {
  final Destination destination;
  final String userId;
  const TriviaScreen({super.key, required this.destination, this.userId = 'user1'});

  @override
  State<TriviaScreen> createState() => _TriviaScreenState();
}

class _TriviaScreenState extends State<TriviaScreen> {
  int _currentIndex = 0;
  int _score = 0;
  int? _selectedAnswer;
  bool _answered = false;
  bool _finished = false;
  bool _scoreSaved = false;
  static const int _pointsPerCorrect = 20;

  List<TriviaQuestion> get _questions => widget.destination.trivia;

  void _selectAnswer(int index) {
    if (_answered) return;
    setState(() {
      _selectedAnswer = index;
      _answered = true;
      if (index == _questions[_currentIndex].correctIndex) {
        _score += _pointsPerCorrect;
      }
    });
  }

  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedAnswer = null;
        _answered = false;
      });
    } else {
      setState(() => _finished = true);
      _saveScore();
    }
  }

  Future<void> _saveScore() async {
    if (_scoreSaved) return;
    _scoreSaved = true;
    await DatabaseService().saveScore(widget.userId, widget.destination.id, _score);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: Text(
          'Trivia: ${widget.destination.name}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        elevation: 0,
      ),
      body: _finished ? _buildResult() : _buildQuestion(),
    );
  }

  Widget _buildQuestion() {
    final question = _questions[_currentIndex];
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('${_currentIndex + 1} / ${_questions.length}', style: AppTextStyles.caption),
              const SizedBox(width: 12),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (_currentIndex + 1) / _questions.length,
                    backgroundColor: AppColors.inputBg,
                    color: AppColors.primary,
                    minHeight: 8,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text('$_score poin', style: AppTextStyles.caption),
                ],
              ),
            ],
          ),
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
            ),
            child: Text(
              question.question,
              style: AppTextStyles.subheading.copyWith(fontSize: 17, height: 1.5),
            ),
          ),
          const SizedBox(height: 24),
          ...List.generate(question.options.length, (i) {
            Color bgColor = AppColors.white;
            Color borderColor = AppColors.border;
            Widget? trailingIcon;
            if (_answered) {
              if (i == question.correctIndex) {
                bgColor = const Color(0xFFE8F5E9);
                borderColor = Colors.green;
                trailingIcon = const Icon(Icons.check_circle, color: Colors.green);
              } else if (i == _selectedAnswer && i != question.correctIndex) {
                bgColor = const Color(0xFFFFEBEE);
                borderColor = Colors.red;
                trailingIcon = const Icon(Icons.cancel, color: Colors.red);
              }
            }
            return GestureDetector(
              onTap: () => _selectAnswer(i),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor, width: 1.5),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 28, height: 28,
                      decoration: BoxDecoration(
                        color: _selectedAnswer == i ? AppColors.primary : AppColors.inputBg,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        String.fromCharCode(65 + i),
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                          color: _selectedAnswer == i ? Colors.white : AppColors.textPrimary),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(question.options[i], style: AppTextStyles.label)),
                    if (trailingIcon != null) trailingIcon,
                  ],
                ),
              ),
            );
          }),
          const Spacer(),
          if (_answered)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _nextQuestion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(
                  _currentIndex < _questions.length - 1 ? 'Pertanyaan Berikutnya' : 'Lihat Hasil',
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildResult() {
    final total = _questions.length * _pointsPerCorrect;
    final correct = _score ~/ _pointsPerCorrect;
    final percentage = (_score / total * 100).round();

    String emoji;
    String message;
    if (percentage == 100) {
      emoji = '🏆';
      message = 'Sempurna! Kamu ahli tentang ${widget.destination.name}!';
    } else if (percentage >= 60) {
      emoji = '👍';
      message = 'Bagus! Kamu tahu banyak tentang ${widget.destination.name}!';
    } else {
      emoji = '📚';
      message = 'Terus belajar! Yuk kunjungi ${widget.destination.name} langsung!';
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Text(emoji, style: const TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          Text('Trivia Selesai!', style: AppTextStyles.heading),
          const SizedBox(height: 8),
          Text(message, style: AppTextStyles.body, textAlign: TextAlign.center),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12)],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(children: [
                      Text('$correct/${_questions.length}',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.green)),
                      const SizedBox(height: 4),
                      Text('Benar', style: AppTextStyles.caption),
                    ]),
                    Column(children: [
                      Text('$_score',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xFF2A7F7F))),
                      const SizedBox(height: 4),
                      Text('Skor', style: AppTextStyles.caption),
                    ]),
                    Column(children: [
                      Text('$percentage%',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.amber)),
                      const SizedBox(height: 4),
                      Text('Persentase', style: AppTextStyles.caption),
                    ]),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        '+$_score poin ditambahkan ke akun kamu!',
                        style: AppTextStyles.label.copyWith(color: AppColors.primary),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('Kembali ke Destinasi',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
