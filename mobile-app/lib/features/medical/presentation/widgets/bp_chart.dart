import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/health_models.dart';

class BPChart extends StatelessWidget {
  final List<BPReading> readings;

  const BPChart({super.key, required this.readings});

  @override
  Widget build(BuildContext context) {
    if (readings.isEmpty) {
      return const Center(child: Text('No data to display'));
    }

    final displayReadings = readings.length > 14 
        ? readings.sublist(readings.length - 14) 
        : readings;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 20,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.withOpacity(0.3),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < displayReadings.length) {
                  final date = displayReadings[index].date;
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      '${date.day}/${date.month}',
                      style: const TextStyle(fontSize: 10),
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 20,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: (displayReadings.length - 1).toDouble(),
        minY: 40,
        maxY: 200,
        lineBarsData: [
          // Systolic line
          LineChartBarData(
            spots: displayReadings.asMap().entries.map((entry) {
              return FlSpot(entry.key.toDouble(), entry.value.systolic.toDouble());
            }).toList(),
            isCurved: true,
            color: Colors.red,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.red.withOpacity(0.1),
            ),
          ),
          // Diastolic line
          LineChartBarData(
            spots: displayReadings.asMap().entries.map((entry) {
              return FlSpot(entry.key.toDouble(), entry.value.diastolic.toDouble());
            }).toList(),
            isCurved: true,
            color: Colors.blue,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.blue.withOpacity(0.1),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final isSystemic = spot.barIndex == 0;
                return LineTooltipItem(
                  '${isSystemic ? 'Sys' : 'Dia'}: ${spot.y.toInt()}',
                  TextStyle(
                    color: isSystemic ? Colors.red : Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }
}
