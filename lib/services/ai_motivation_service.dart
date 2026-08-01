import 'dart:convert';
import '../models/habit_type.dart';

import 'package:http/http.dart' as http;

import '../config.dart';
import '../models/daily_entry.dart';
import '../models/habit_goal.dart';
import '../models/milestone.dart';
import '../models/user_profile.dart';

class AiMotivationResult {
  const AiMotivationResult({
    required this.text,
    required this.source,
  });

  final String text;
  final String source; // ai | template | hybrid
}

class AiMotivationService {
  AiMotivationService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<AiMotivationResult> generate({
    required UserProfile user,
    required HabitGoal goal,
    required int dayNumber,
    required Milestone milestone,
    required String templateMotivation,
    required List<DailyEntry> recentEntries,
  }) async {
    if (!AppConfig.hasAiConfigured) {
      return AiMotivationResult(text: templateMotivation, source: 'template');
    }

    final prompt = _buildPrompt(
      user: user,
      goal: goal,
      dayNumber: dayNumber,
      milestone: milestone,
      templateMotivation: templateMotivation,
      recentEntries: recentEntries,
    );

    try {
      String? text;
      if (AppConfig.aiProxyUrl.isNotEmpty) {
        text = await _callProxy(prompt);
      } else if (AppConfig.openAiApiKey.isNotEmpty) {
        text = await _callOpenAi(prompt);
      } else if (AppConfig.geminiApiKey.isNotEmpty) {
        text = await _callGemini(prompt);
      }
      final cleaned = (text ?? '').trim();
      if (cleaned.isEmpty) {
        return AiMotivationResult(text: templateMotivation, source: 'template');
      }
      return AiMotivationResult(text: cleaned, source: 'hybrid');
    } catch (_) {
      return AiMotivationResult(text: templateMotivation, source: 'template');
    }
  }

  String _buildPrompt({
    required UserProfile user,
    required HabitGoal goal,
    required int dayNumber,
    required Milestone milestone,
    required String templateMotivation,
    required List<DailyEntry> recentEntries,
  }) {
    final history = recentEntries.reversed.map((e) {
      return 'Gün ${e.dayNumber}: ${e.motivationText ?? e.milestoneBody ?? ''}';
    }).join('\n');

    final buf = StringBuffer()
      ..writeln('You are a supportive habit coach. Write in the same language as this instruction language preference: Turkish if user profile implies TR, otherwise match the milestone language. Prefer clear short sentences.')
      ..writeln('Tıbbi teşhis koyma; abartılı sağlık iddiası kurma.')
      ..writeln('2-4 kısa cümle yaz. Samimi, tutarlı ve motive edici ol.')
      ..writeln('Bugünkü bilimsel/eğitsel bilgiyi değiştirme; onu pekiştir.')
      ..writeln()
      ..writeln('Hedef: ${goal.type.titleTr}')
      ..writeln('Gün: $dayNumber')
      ..writeln('Yaş: ${user.age ?? 'bilinmiyor'}')
      ..writeln('Cinsiyet: ${user.gender ?? 'bilinmiyor'}')
      ..writeln('Profil alanları: ${jsonEncode(goal.extra)}')
      ..writeln('Bugünkü başlık: ${milestone.title}')
      ..writeln('Bugünkü bilgi: ${milestone.body}')
      ..writeln('Şablon motivasyon (yedek): $templateMotivation')
      ..writeln('Önceki günler:')
      ..writeln(history.isEmpty ? '(yok)' : history)
      ..writeln()
      ..writeln('Sadece motivasyon metnini döndür, başka açıklama ekleme.');

    return buf.toString();
  }

  Future<String?> _callProxy(String prompt) async {
    final res = await _client.post(
      Uri.parse(AppConfig.aiProxyUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'prompt': prompt}),
    );
    if (res.statusCode < 200 || res.statusCode >= 300) return null;
    final data = jsonDecode(res.body);
    if (data is Map && data['text'] != null) return data['text'].toString();
    return null;
  }

  Future<String?> _callOpenAi(String prompt) async {
    final res = await _client.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AppConfig.openAiApiKey}',
      },
      body: jsonEncode({
        'model': AppConfig.openAiModel,
        'messages': [
          {'role': 'user', 'content': prompt},
        ],
        'temperature': 0.7,
        'max_tokens': 220,
      }),
    );
    if (res.statusCode < 200 || res.statusCode >= 300) return null;
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    final choices = data['choices'] as List?;
    if (choices == null || choices.isEmpty) return null;
    final msg = choices.first['message'] as Map<String, dynamic>?;
    return msg?['content']?.toString();
  }

  Future<String?> _callGemini(String prompt) async {
    final uri = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/'
      '${AppConfig.geminiModel}:generateContent?key=${AppConfig.geminiApiKey}',
    );
    final res = await _client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': prompt},
            ],
          },
        ],
      }),
    );
    if (res.statusCode < 200 || res.statusCode >= 300) return null;
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    final candidates = data['candidates'] as List?;
    if (candidates == null || candidates.isEmpty) return null;
    final content = candidates.first['content'] as Map<String, dynamic>?;
    final parts = content?['parts'] as List?;
    if (parts == null || parts.isEmpty) return null;
    return parts.first['text']?.toString();
  }
}