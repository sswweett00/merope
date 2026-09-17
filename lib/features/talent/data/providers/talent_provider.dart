import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TalentJob {
  final String id;
  final String title;
  final String company;
  final String location;
  final String type;
  final String compensation;
  final List<String> tags;

  TalentJob({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.type,
    required this.compensation,
    required this.tags,
  });
}

class TalentJobs extends AsyncNotifier<List<TalentJob>> {
  @override
  FutureOr<List<TalentJob>> build() async {
    // Simulated API fetch
    await Future.delayed(const Duration(milliseconds: 900));
    return [
      TalentJob(
        id: 'j1',
        title: 'Lead Distributed Systems Engineer',
        company: 'Nexus Core',
        location: 'Remote / Global',
        type: 'Full-time',
        compensation: r'$160k - $220k',
        tags: ['Go', 'Rust', 'Distributed Systems', 'NATS'],
      ),
      TalentJob(
        id: 'j2',
        title: 'Senior Flutter Architect',
        company: 'Wave Labs',
        location: 'Istanbul / Hybrid',
        type: 'Contract',
        compensation: r'$120k - $150k',
        tags: ['Flutter', 'Riverpod', 'Drift', 'Architecture'],
      ),
      TalentJob(
        id: 'j3',
        title: 'Security Researcher (Zero Trust)',
        company: 'Neural Waves',
        location: 'Remote',
        type: 'Full-time',
        compensation: r'$140k - $190k',
        tags: ['E2EE', 'Zero Trust', 'Security', 'Protocols'],
      ),
    ];
  }

  Future<void> addJob(TalentJob job) async {
    final currentJobs = state.value ?? [];
    state = AsyncData([...currentJobs, job]);
  }
}

final talentJobsProvider =
    AsyncNotifierProvider<TalentJobs, List<TalentJob>>(TalentJobs.new);
