import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/health_models.dart';

class SugarChart extends StatelessWidget {
  final List<SugarReading> readings;

  const SugarChart({super.key, required this.readings});

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
          horizontalInterval: 50,
          getDrawingHorizontalLine: (value) {
            Color lineColor = Colors.grey.withOpacity(0.3);
            double strokeWidth = 1;
            
            // Highlight normal range boundaries
            if (value == 100 || value == 140) {
              lineColor = Colors.green.withOpacity(0.5);
              strokeWidth = 2;
            } else if (value == 126 || value == 200) {
              lineColor = Colors.red.withOpacity(0.5);
              strokeWidth = 2;
            }
            
            return FlLine(
              color: lineColor,
              strokeWidth: strokeWidth,
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
              interval: 50,
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
        minY: 50,
        maxY: 300,
        lineBarsData: [
          LineChartBarData(
            spots: displayReadings.asMap().entries.map((entry) {
              return FlSpot(entry.key.toDouble(), entry.value.level);
            }).toList(),
            isCurved: true,
            gradient: const LinearGradient(
              colors: [Colors.blue, Colors.purple],
            ),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                final reading = displayReadings[index];
                Color dotColor;
                switch (reading.status) {
                  case 'Normal':
                    dotColor = Colors.green;
                    break;
                  case 'Pre-diabetic':
                    dotColor = Colors.orange;
                    break;
                  case 'Diabetic':
                    dotColor = Colors.red;
                    break;
                  default:
                    dotColor = Colors.blue;
                }
                return FlDotCirclePainter(
                  radius: 5,
                  color: dotColor,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  Colors.blue.withOpacity(0.2),
                  Colors.purple.withOpacity(0.1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final reading = displayReadings[spot.x.toInt()];
                return LineTooltipItem(
                  '${reading.level.toStringAsFixed(1)} mg/dL\n${reading.type}',
                  const TextStyle(
                    color: Colors.white,
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
