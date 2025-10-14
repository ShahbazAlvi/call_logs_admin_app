// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
//
// class WeeklyVolumeChart extends StatelessWidget {
//   final int totalCalls;
//   final List<Map<String, dynamic>> weeklyData;
//
//   const WeeklyVolumeChart({
//     super.key,
//     required this.totalCalls,
//     required this.weeklyData,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF5F8FF),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Header Row
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text(
//                 "Weekly Call Volume",
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//               ),
//               TextButton(
//                 onPressed: () {},
//                 child: const Text(
//                   "View report →",
//                   style: TextStyle(color: Colors.blue),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 4),
//           // Total Calls
//           Text(
//             "$totalCalls calls this week",
//             style: const TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: Colors.blue,
//             ),
//           ),
//           const SizedBox(height: 16),
//           // Chart
//           AspectRatio(
//             aspectRatio: 1.5,
//             child: BarChart(
//               BarChartData(
//                 alignment: BarChartAlignment.spaceAround,
//                 borderData: FlBorderData(show: false),
//                 gridData: FlGridData(
//                   show: true,
//                   drawVerticalLine: false,
//                   horizontalInterval: 100,
//                 ),
//                 titlesData: FlTitlesData(
//                   bottomTitles: AxisTitles(
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       getTitlesWidget: (value, meta) {
//                         int index = value.toInt();
//                         if (index < 0 || index >= weeklyData.length) {
//                           return const SizedBox();
//                         }
//                         return Padding(
//                           padding: const EdgeInsets.only(top: 4.0),
//                           child: Text(
//                             weeklyData[index]["day"],
//                             style: const TextStyle(
//                                 fontSize: 10, color: Colors.black54),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                   leftTitles: AxisTitles(
//                     sideTitles: SideTitles(showTitles: true, interval: 100),
//                   ),
//                   rightTitles: AxisTitles(
//                     sideTitles: SideTitles(showTitles: false),
//                   ),
//                   topTitles: AxisTitles(
//                     sideTitles: SideTitles(showTitles: false),
//                   ),
//                 ),
//                 barGroups: weeklyData.asMap().entries.map((entry) {
//                   int index = entry.key;
//                   final item = entry.value;
//                   return BarChartGroupData(
//                     x: index,
//                     barRods: [
//                       BarChartRodData(
//                         toY: (item["count"] ?? 0).toDouble(),
//                         color: Colors.blue,
//                         width: 14,
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                     ],
//                   );
//                 }).toList(),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F8FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Weekly Call Volume",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  "View report →",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Total Calls
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
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 100,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.3),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        if (index < 0 || index >= weeklyData.length) {
                          return const SizedBox();
                        }
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
                      interval: 100,
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
                      reservedSize: 40, // Reserve space for Y-axis labels
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
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
                // Set the max Y value based on your data
                maxY: _calculateMaxY(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _calculateMaxY() {
    double maxValue = 0;
    for (var item in weeklyData) {
      double value = (item["count"] ?? 0).toDouble();
      if (value > maxValue) maxValue = value;
    }
    // Add some padding to the max value for better visualization
    return (maxValue * 1.2).ceilToDouble();
  }
}