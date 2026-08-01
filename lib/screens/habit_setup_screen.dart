import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../l10n/habit_l10n.dart';
import 'package:provider/provider.dart';

import '../models/habit_type.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

class HabitSetupScreen extends StatefulWidget {
  const HabitSetupScreen({super.key, required this.type});

  final HabitType type;

  @override
  State<HabitSetupScreen> createState() => _HabitSetupScreenState();
}

class _HabitSetupScreenState extends State<HabitSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime _startDate = DateTime.now();

  // smoking
  final _cigarettesCtrl = TextEditingController();
  final _yearsCtrl = TextEditingController();

  // alcohol
  final _drinksCtrl = TextEditingController();

  // drugs
  final _substanceCtrl = TextEditingController();

  // diet
  final _weightCtrl = TextEditingController();
  final _heightCtrl = TextEditingController();
  final _targetWeightCtrl = TextEditingController();
  final _conditionsCtrl = TextEditingController();

  // sports
  String _sportsLevel = 'beginner';
  final _weeklyDaysCtrl = TextEditingController(text: '3');

  // shared from profile prefill
  final _ageCtrl = TextEditingController();
  String? _gender;

  @override
  void initState() {
    super.initState();
    final user = context.read<AppState>().user;
    if (user?.age != null) _ageCtrl.text = '${user!.age}';
    _gender = user?.gender;
    final existing = context.read<AppState>().goalFor(widget.type);
    if (existing != null) {
      _startDate = existing.startDate;
      final e = existing.extra;
      _cigarettesCtrl.text = '${e['cigarettesPerDay'] ?? ''}';
      _yearsCtrl.text = '${e['yearsSmoking'] ?? ''}';
      _drinksCtrl.text = '${e['drinksPerWeek'] ?? ''}';
      _substanceCtrl.text = '${e['substanceNote'] ?? ''}';
      _weightCtrl.text = '${e['weightKg'] ?? ''}';
      _heightCtrl.text = '${e['heightCm'] ?? ''}';
      _targetWeightCtrl.text = '${e['targetWeightKg'] ?? ''}';
      _conditionsCtrl.text = '${e['conditions'] ?? ''}';
      _sportsLevel = (e['level'] as String?) ?? 'beginner';
      _weeklyDaysCtrl.text = '${e['weeklyDays'] ?? '3'}';
    }
  }

  @override
  void dispose() {
    _cigarettesCtrl.dispose();
    _yearsCtrl.dispose();
    _drinksCtrl.dispose();
    _substanceCtrl.dispose();
    _weightCtrl.dispose();
    _heightCtrl.dispose();
    _targetWeightCtrl.dispose();
    _conditionsCtrl.dispose();
    _weeklyDaysCtrl.dispose();
    _ageCtrl.dispose();
    super.dispose();
  }

  Map<String, dynamic> _buildExtra() {
    switch (widget.type) {
      case HabitType.smoking:
        return {
          'cigarettesPerDay': int.tryParse(_cigarettesCtrl.text.trim()),
          'yearsSmoking': int.tryParse(_yearsCtrl.text.trim()),
        };
      case HabitType.alcohol:
        return {
          'drinksPerWeek': int.tryParse(_drinksCtrl.text.trim()),
        };
      case HabitType.drugs:
        return {
          'substanceNote': _substanceCtrl.text.trim(),
        };
      case HabitType.masturbation:
        return {};
      case HabitType.diet:
        return {
          'weightKg': double.tryParse(_weightCtrl.text.trim().replaceAll(',', '.')),
          'heightCm': double.tryParse(_heightCtrl.text.trim().replaceAll(',', '.')),
          'targetWeightKg':
              double.tryParse(_targetWeightCtrl.text.trim().replaceAll(',', '.')),
          'conditions': _conditionsCtrl.text.trim(),
        };
      case HabitType.sports:
        return {
          'level': _sportsLevel,
          'weeklyDays': int.tryParse(_weeklyDaysCtrl.text.trim()) ?? 3,
        };
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now().subtract(const Duration(days: 3650)),
      lastDate: DateTime.now(),
      locale: const Locale('tr', 'TR'),
    );
    if (picked != null) setState(() => _startDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).setupTitle(widget.type.shortTitle(AppLocalizations.of(context))))),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppTheme.pagePadding),
          children: [
            const Text(
              'Profil bilgileri (AI ve kişiselleştirme için)',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _ageCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Yaş'),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              initialValue: _gender,
              decoration: const InputDecoration(labelText: 'Cinsiyet'),
              items: const [
                DropdownMenuItem(value: 'male', child: Text('Erkek')),
                DropdownMenuItem(value: 'female', child: Text('Kadın')),
                DropdownMenuItem(value: 'other', child: Text('Diğer')),
                DropdownMenuItem(
                  value: 'prefer_not',
                  child: Text('Belirtmek istemiyorum'),
                ),
              ],
              onChanged: (v) => setState(() => _gender = v),
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Başlangıç tarihi'),
              subtitle: Text(
                '${_startDate.day}.${_startDate.month}.${_startDate.year}',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: _pickDate,
            ),
            const Divider(height: 28),
            ..._typeFields(),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                final app = context.read<AppState>();
                final age = int.tryParse(_ageCtrl.text.trim());
                await app.updateProfile(age: age, gender: _gender);
                await app.saveGoalSetup(
                  type: widget.type,
                  startDate: _startDate,
                  extra: _buildExtra(),
                );
                if (context.mounted) Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context).saveAndStart),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _typeFields() {
    switch (widget.type) {
      case HabitType.smoking:
        return [
          TextFormField(
            controller: _cigarettesCtrl,
            keyboardType: TextInputType.number,
            decoration:
                const InputDecoration(labelText: 'Günlük sigara adedi'),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _yearsCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Kaç yıldır?'),
          ),
        ];
      case HabitType.alcohol:
        return [
          TextFormField(
            controller: _drinksCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Haftalık ortalama içki sayısı',
            ),
          ),
        ];
      case HabitType.drugs:
        return [
          TextFormField(
            controller: _substanceCtrl,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Not (isteğe bağlı)',
              hintText: 'Bırakmak istediğin madde / sıklık',
            ),
          ),
        ];
      case HabitType.masturbation:
        return [
          const Text(
            'Ek alan gerekmez. İstersen başlangıç tarihini ayarla.',
            style: TextStyle(color: AppTheme.textMuted),
          ),
        ];
      case HabitType.diet:
        return [
          TextFormField(
            controller: _weightCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Kilo (kg)'),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _heightCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Boy (cm)'),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _targetWeightCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Hedef kilo (kg)'),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _conditionsCtrl,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Hastalık / kısıtlar',
              hintText: 'Örn. diyabet, tansiyon…',
            ),
          ),
        ];
      case HabitType.sports:
        return [
          DropdownButtonFormField<String>(
            initialValue: _sportsLevel,
            decoration: const InputDecoration(labelText: 'Seviye'),
            items: const [
              DropdownMenuItem(value: 'beginner', child: Text('Başlangıç')),
              DropdownMenuItem(value: 'intermediate', child: Text('Orta')),
              DropdownMenuItem(value: 'advanced', child: Text('İleri')),
            ],
            onChanged: (v) => setState(() => _sportsLevel = v ?? 'beginner'),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _weeklyDaysCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Haftalık hedef gün',
            ),
          ),
        ];
    }
  }
}