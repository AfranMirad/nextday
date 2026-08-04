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

  // custom
  final _customTitleCtrl = TextEditingController();

  // shared from profile prefill
  DateTime? _birthDate;
  String? _gender;

  @override
  void initState() {
    super.initState();
    final user = context.read<AppState>().user;
    _birthDate = user?.birthDate;
    _gender = user?.gender;
    final existing = widget.type.isCustom
        ? null
        : context.read<AppState>().goalFor(widget.type);
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
    _customTitleCtrl.dispose();
    super.dispose();
  }

  Map<String, dynamic> _buildExtra() {
    final id = widget.type.id;
    if (widget.type.isCustom) {
      return {'title': _customTitleCtrl.text.trim()};
    }
    switch (id) {
      case 'smoking':
        return {
          'cigarettesPerDay': int.tryParse(_cigarettesCtrl.text.trim()),
          'yearsSmoking': int.tryParse(_yearsCtrl.text.trim()),
        };
      case 'alcohol':
        return {
          'drinksPerWeek': int.tryParse(_drinksCtrl.text.trim()),
        };
      case 'drugs':
        return {
          'substanceNote': _substanceCtrl.text.trim(),
        };
      case 'diet':
        return {
          'weightKg':
              double.tryParse(_weightCtrl.text.trim().replaceAll(',', '.')),
          'heightCm':
              double.tryParse(_heightCtrl.text.trim().replaceAll(',', '.')),
          'targetWeightKg':
              double.tryParse(_targetWeightCtrl.text.trim().replaceAll(',', '.')),
          'conditions': _conditionsCtrl.text.trim(),
        };
      case 'sports':
        return {
          'level': _sportsLevel,
          'weeklyDays': int.tryParse(_weeklyDaysCtrl.text.trim()) ?? 3,
        };
      default:
        return {};
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now().subtract(const Duration(days: 3650)),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _startDate = picked);
  }

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final initial = _birthDate ?? DateTime(now.year - 25, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(now.year - 120),
      lastDate: now,
      helpText: AppLocalizations.of(context).birthDate,
    );
    if (picked != null) setState(() => _birthDate = picked);
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.setupTitle(widget.type.shortTitle(l10n))),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppTheme.pagePadding),
          children: [
            Text(
              l10n.profileForAi,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.birthDate),
              subtitle: Text(
                _birthDate != null
                    ? _formatDate(_birthDate!)
                    : l10n.birthDateHint,
              ),
              trailing: const Icon(Icons.calendar_today_outlined),
              onTap: _pickBirthDate,
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              initialValue: _gender,
              decoration: InputDecoration(labelText: l10n.gender),
              items: [
                DropdownMenuItem(value: 'male', child: Text(l10n.genderMale)),
                DropdownMenuItem(
                  value: 'female',
                  child: Text(l10n.genderFemale),
                ),
                DropdownMenuItem(value: 'other', child: Text(l10n.genderOther)),
                DropdownMenuItem(
                  value: 'prefer_not',
                  child: Text(l10n.genderPreferNot),
                ),
              ],
              onChanged: (v) => setState(() => _gender = v),
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.startDate),
              subtitle: Text(_formatDate(_startDate)),
              trailing: const Icon(Icons.calendar_today),
              onTap: _pickDate,
            ),
            const Divider(height: 28),
            ..._typeFields(),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                if (widget.type.isCustom &&
                    _customTitleCtrl.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.customTopicTitle)),
                  );
                  return;
                }
                final app = context.read<AppState>();
                await app.updateProfile(
                  birthDate: _birthDate,
                  clearBirthDate: _birthDate == null,
                  gender: _gender,
                );
                await app.saveGoalSetup(
                  type: widget.type,
                  startDate: _startDate,
                  extra: _buildExtra(),
                );
                if (context.mounted) Navigator.pop(context);
              },
              child: Text(l10n.saveAndStart),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _typeFields() {
    final id = widget.type.id;
    if (widget.type.isCustom) {
      final l10n = AppLocalizations.of(context);
      return [
        TextFormField(
          controller: _customTitleCtrl,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            labelText: l10n.customTopicTitle,
            hintText: l10n.customTopicHint,
          ),
        ),
      ];
    }
    switch (id) {
      case 'smoking':
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
      case 'alcohol':
        return [
          TextFormField(
            controller: _drinksCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Haftalık ortalama içki sayısı',
            ),
          ),
        ];
      case 'drugs':
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
      case 'diet':
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
      case 'sports':
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
      default:
        return [
          Text(
            widget.type.isQuitHabit
                ? 'Bu konu için ek alan gerekmez. Başlangıç tarihini ayarla ve başla.'
                : 'Bu iyi alışkanlık için ek alan gerekmez. Başlangıç tarihini ayarla ve başla.',
            style: TextStyle(color: AppTheme.muted(context), height: 1.4),
          ),
        ];
    }
  }
}