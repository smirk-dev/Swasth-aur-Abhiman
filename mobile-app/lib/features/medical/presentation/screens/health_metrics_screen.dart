import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

// Health metrics data model
class HealthMetric {
  final String id;
  final String metricType;
  final double value;
  final String unit;
  final String? condition;
  final DateTime recordedAt;

  HealthMetric({
    required this.id,
    required this.metricType,
    required this.value,
    required this.unit,
    this.condition,
    required this.recordedAt,
  });

  factory HealthMetric.fromJson(Map<String, dynamic> json) {
    return HealthMetric(
      id: json['id'],
      metricType: json['metricType'],
      value: (json['value'] as num).toDouble(),
      unit: json['unit'],
      condition: json['condition'],
      recordedAt: DateTime.parse(json['recordedAt']),
    );
  }
}

// Riverpod providers for health metrics
final healthMetricsProvider =
    StateNotifierProvider<HealthMetricsNotifier, AsyncValue<List<HealthMetric>>>(
  (ref) => HealthMetricsNotifier(),
);

final healthSummaryProvider =
    FutureProvider<Map<String, dynamic>>((ref) async {
  // TODO: Fetch from API
  return {};
});

// State notifier for managing health metrics
class HealthMetricsNotifier extends StateNotifier<AsyncValue<List<HealthMetric>>> {
  HealthMetricsNotifier() : super(const AsyncValue.loading()) {
    fetchMetrics();
  }

  Future<void> fetchMetrics() async {
    try {
      state = const AsyncValue.loading();
      // TODO: Fetch from API /health/metrics
      state = const AsyncValue.data([]);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> recordMetric(String metricType, double value) async {
    try {
      // TODO: POST to API /health/metrics
      await fetchMetrics();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

// Health Metrics Tracking Screen
class HealthMetricsScreen extends ConsumerStatefulWidget {
  const HealthMetricsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HealthMetricsScreen> createState() => _HealthMetricsScreenState();
}

class _HealthMetricsScreenState extends ConsumerState<HealthMetricsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _selectedMetricType = 'BLOOD_SUGAR';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final metricsAsync = ref.watch(healthMetricsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Metrics'),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.favorite), text: 'BP'),
            Tab(icon: Icon(Icons.bloodtype), text: 'Sugar'),
            Tab(icon: Icon(Icons.scale), text: 'BMI'),
            Tab(icon: Icon(Icons.analytics), text: 'Trends'),
          ],
        ),
      ),
      body: metricsAsync.when(
        data: (metrics) => TabBarView(
          controller: _tabController,
          children: [
            _buildBPTab(metrics),
            _buildBloodSugarTab(metrics),
            _buildBMITab(metrics),
            _buildTrendsTab(metrics),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showRecordMetricDialog(context, ref),
        tooltip: 'Record Metric',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBPTab(List<HealthMetric> allMetrics) {
    final bpMetrics = allMetrics
        .where((m) => m.metricType == 'BP_SYSTOLIC' || m.metricType == 'BP_DIASTOLIC')
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLatestValueCard('Blood Pressure', bpMetrics),
          const SizedBox(height: 24),
          Text(
            'BP History',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          _buildBPChart(bpMetrics),
          const SizedBox(height: 24),
          _buildMetricsList(bpMetrics),
        ],
      ),
    );
  }

  Widget _buildBloodSugarTab(List<HealthMetric> allMetrics) {
    final sugarMetrics = allMetrics
        .where((m) => m.metricType == 'BLOOD_SUGAR')
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLatestValueCard('Blood Sugar', sugarMetrics),
          const SizedBox(height: 24),
          Text(
            'Blood Sugar Trend',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          _buildLineChart(sugarMetrics),
          const SizedBox(height: 24),
          _buildMetricsList(sugarMetrics),
        ],
      ),
    );
  }

  Widget _buildBMITab(List<HealthMetric> allMetrics) {
    final bmiMetrics = allMetrics.where((m) => m.metricType == 'BMI').toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLatestValueCard('BMI', bmiMetrics),
          const SizedBox(height: 24),
          Text(
            'BMI Progress',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          _buildLineChart(bmiMetrics),
          const SizedBox(height: 24),
          _buildBMIRecommendations(bmiMetrics),
        ],
      ),
    );
  }

  Widget _buildTrendsTab(List<HealthMetric> allMetrics) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Health Overview',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          _buildHealthSummaryCards(allMetrics),
        ],
      ),
    );
  }

  Widget _buildLatestValueCard(String title, List<HealthMetric> metrics) {
    if (metrics.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text('No $title data recorded yet'),
        ),
      );
    }

    final latest = metrics.first;
    Color statusColor = Colors.green;

    if (latest.condition == 'high' || latest.condition == 'elevated') {
      statusColor = Colors.orange;
    } else if (latest.condition == 'critical' || latest.condition == 'low') {
      statusColor = Colors.red;
    }

    return Card(
      color: statusColor.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.labelSmall,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${latest.value.toStringAsFixed(1)} ${latest.unit}',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Chip(
                  label: Text(latest.condition ?? 'Normal'),
                  backgroundColor: statusColor,
                  labelStyle: const TextStyle(color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Recorded: ${DateFormat('MMM dd, yyyy HH:mm').format(latest.recordedAt)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLineChart(List<HealthMetric> metrics) {
    if (metrics.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(child: Text('No data available')),
      );
    }

    final sortedMetrics = metrics.toList()..sort((a, b) => a.recordedAt.compareTo(b.recordedAt));
    final spots = <FlSpot>[];

    for (int i = 0; i < sortedMetrics.length; i++) {
      spots.add(FlSpot(i.toDouble(), sortedMetrics[i].value));
    }

    return SizedBox(
      height: 250,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: true),
          titlesData: const FlTitlesData(show: true),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineBarData(
              spots: spots,
              isCurved: true,
              color: Colors.blue,
              barWidth: 2,
              dotData: const FlDotData(show: true),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBPChart(List<HealthMetric> metrics) {
    if (metrics.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(child: Text('No BP data available')),
      );
    }

    final sortedMetrics = metrics.toList()..sort((a, b) => a.recordedAt.compareTo(b.recordedAt));

    final systolicSpots = <FlSpot>[];
    final diastolicSpots = <FlSpot>[];

    int idx = 0;
    for (final metric in sortedMetrics) {
      if (metric.metricType == 'BP_SYSTOLIC') {
        systolicSpots.add(FlSpot(idx.toDouble(), metric.value));
      } else if (metric.metricType == 'BP_DIASTOLIC') {
        diastolicSpots.add(FlSpot(idx.toDouble(), metric.value));
      }
      idx++;
    }

    return SizedBox(
      height: 250,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: true),
          titlesData: const FlTitlesData(show: true),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            if (systolicSpots.isNotEmpty)
              LineBarData(
                spots: systolicSpots,
                isCurved: true,
                color: Colors.red,
                barWidth: 2,
                dotData: const FlDotData(show: true),
              ),
            if (diastolicSpots.isNotEmpty)
              LineBarData(
                spots: diastolicSpots,
                isCurved: true,
                color: Colors.blue,
                barWidth: 2,
                dotData: const FlDotData(show: true),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsList(List<HealthMetric> metrics) {
    if (metrics.isEmpty) {
      return const Text('No metrics recorded yet');
    }

    final sorted = metrics.toList()..sort((a, b) => b.recordedAt.compareTo(a.recordedAt));

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sorted.length.clamp(0, 10),
      itemBuilder: (context, index) {
        final metric = sorted[index];
        return ListTile(
          title: Text('${metric.value} ${metric.unit}'),
          subtitle: Text(DateFormat('MMM dd, yyyy HH:mm').format(metric.recordedAt)),
          trailing: Chip(label: Text(metric.condition ?? 'Normal')),
        );
      },
    );
  }

  Widget _buildBMIRecommendations(List<HealthMetric> bmiMetrics) {
    if (bmiMetrics.isEmpty) return const SizedBox();

    final latestBMI = bmiMetrics.first.value;
    String recommendation = 'Maintain a healthy lifestyle.';
    Color color = Colors.green;

    if (latestBMI < 18.5) {
      recommendation = 'You are underweight. Ensure a balanced diet with adequate calories.';
      color = Colors.orange;
    } else if (latestBMI < 25) {
      recommendation = 'Your BMI is in the healthy range. Keep up the good work!';
      color = Colors.green;
    } else if (latestBMI < 30) {
      recommendation = 'You are overweight. Exercise regularly and maintain a balanced diet.';
      color = Colors.orange;
    } else {
      recommendation = 'You are obese. Consult a nutritionist for a weight management plan.';
      color = Colors.red;
    }

    return Card(
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recommendation',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Text(recommendation),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthSummaryCards(List<HealthMetric> allMetrics) {
    return Column(
      children: [
        _buildSummaryCard('BP', allMetrics, 'BP_SYSTOLIC'),
        const SizedBox(height: 12),
        _buildSummaryCard('Blood Sugar', allMetrics, 'BLOOD_SUGAR'),
        const SizedBox(height: 12),
        _buildSummaryCard('BMI', allMetrics, 'BMI'),
      ],
    );
  }

  Widget _buildSummaryCard(String title, List<HealthMetric> allMetrics, String metricType) {
    final metrics = allMetrics.where((m) => m.metricType == metricType).toList();

    if (metrics.isEmpty) {
      return Card(
        child: ListTile(
          title: Text(title),
          subtitle: const Text('No data recorded'),
        ),
      );
    }

    final latest = metrics.first;
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text('${latest.value} ${latest.unit}'),
        trailing: Chip(label: Text(latest.condition ?? 'Normal')),
      ),
    );
  }

  void _showRecordMetricDialog(BuildContext context, WidgetRef ref) {
    final valueController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Record Health Metric'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButton<String>(
              value: _selectedMetricType,
              isExpanded: true,
              items: const [
                DropdownMenuItem(value: 'BLOOD_SUGAR', child: Text('Blood Sugar')),
                DropdownMenuItem(value: 'BP_SYSTOLIC', child: Text('BP Systolic')),
                DropdownMenuItem(value: 'BP_DIASTOLIC', child: Text('BP Diastolic')),
                DropdownMenuItem(value: 'BMI', child: Text('BMI')),
                DropdownMenuItem(value: 'WEIGHT', child: Text('Weight')),
                DropdownMenuItem(value: 'TEMPERATURE', child: Text('Temperature')),
                DropdownMenuItem(value: 'PULSE', child: Text('Pulse')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedMetricType = value;
                });
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: valueController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Value',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (valueController.text.isNotEmpty && _selectedMetricType != null) {
                final value = double.parse(valueController.text);
                ref
                    .read(healthMetricsProvider.notifier)
                    .recordMetric(_selectedMetricType!, value);
                Navigator.pop(context);
              }
            },
            child: const Text('Record'),
          ),
        ],
      ),
    );
  }
}
