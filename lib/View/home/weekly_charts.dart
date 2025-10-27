

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WeeklyVolumeChart extends StatelessWidget {
  final int totalCalls;
  final List<Map<String, dynamic>> weeklyData;

  const WeeklyVolumeChart({
    super.key,
    required this.totalCalls,
    required this.weeklyData,
  });

  @override
  Widget build(BuildContext context) {
    double maxY = _calculateMaxY();
    double interval = _calculateInterval(maxY);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F8FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Weekly Call Volume",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              TextButton(
                onPressed: () {},
                child: const Text("View report →", style: TextStyle(color: Colors.blue)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            "$totalCalls calls this week",
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 16),

          // Chart
          AspectRatio(
            aspectRatio: 1.5,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                borderData: FlBorderData(show: false),

                // ✅ FIXED: Dynamic grid lines
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: interval,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.3),
                      strokeWidth: 1,
                    );
                  },
                ),

                // ✅ FIXED: Titles configuration
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        if (index < 0 || index >= weeklyData.length) return const SizedBox();
                        return Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            weeklyData[index]["day"],
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: interval,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            value.toInt().toString(),
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),

                barTouchData: BarTouchData(enabled: false),

                barGroups: weeklyData.asMap().entries.map((entry) {
                  int index = entry.key;
                  final item = entry.value;
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: (item["count"] ?? 0).toDouble(),
                        color: Colors.blue,
                        width: 14,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  );
                }).toList(),

                maxY: maxY,
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _calculateMaxY() {
    if (weeklyData.isEmpty) return 100;
    double maxValue = weeklyData.map((e) => (e["count"] ?? 0).toDouble()).reduce((a, b) => a > b ? a : b);
    return (maxValue * 1.2).ceilToDouble();
  }

  // ✅ Smart interval: keeps grid and labels readable
  double _calculateInterval(double maxY) {
    if (maxY <= 50) return 10;
    if (maxY <= 100) return 20;
    if (maxY <= 200) return 50;
    return (maxY / 5).ceilToDouble();
  }
}
