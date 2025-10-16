
import 'package:flutter/material.dart';
import 'package:infinity/View/Meeting_calender/AllMeeting.dart';
import 'package:infinity/View/home/weekly_charts.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:table_calendar/table_calendar.dart';


import '../../Provider/dashboard_provider.dart';
import '../Meeting_calender/MeetingCalender.dart';
import '../followUpScreen/FollowUpScreen.dart';
import '../monthly chats.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();

    // ✅ Run async calls safely after widget build
    Future.microtask(() async {
      final dashboardProvider = Provider.of<DashBoardProvider>(context, listen: false);
      await dashboardProvider.Performance_Summary();
      await dashboardProvider.fetchCalendarMeetings();
      await dashboardProvider..fetchMonthlyTrends();
      await dashboardProvider.fetchWeeklyTrends();
      await dashboardProvider.CountProduct();
      await dashboardProvider.CountCustomer();
      await dashboardProvider.CountStaff();
      await dashboardProvider.CountTransaction();
    });
  }

  Widget build(BuildContext context) {
    final provider = Provider.of<DashBoardProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Center(child: const Text("Dashboard",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
        backgroundColor: Colors.indigo,
      ),

      // ✅ Drawer Menu Added
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.indigo,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: Colors.indigo, size: 35),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Welcome Admin',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),

            ListTile(
              leading: const Icon(Icons.dashboard, color: Colors.indigo),
              title: const Text('Dashboard'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.dashboard, color: Colors.indigo),
              title: const Text('All Meeting detail'),
              onTap: () {
                Navigator.push(context,MaterialPageRoute(builder: (context)=>AllMeetingScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.dashboard, color: Colors.indigo),
              title: const Text('Follow Up'),
              onTap: () {
                Navigator.push(context,MaterialPageRoute(builder: (context)=>FollowUpScreen()));
              },
            ),

            ListTile(
              leading: const Icon(Icons.calendar_month, color: Colors.indigo),
              title: const Text('Calendar'),
    //           {
    //             Navigator.pop(context);
    //           showDialog(
    //           context: context,
    //           builder: (_) => AlertDialog(
    //             content: SizedBox(
    //               height: 400,
    //               width: 400,
    //               child: CalendarWidget(), // ✅ Reuse your existing calendar
    //             ),
    //           ),
    //         );
    // },
              onTap: () {
                Navigator.push(context,MaterialPageRoute(builder: (context)=>UpcomingMeetingsScreen()));
              }
            ),

            ListTile(
              leading: const Icon(Icons.settings, color: Colors.indigo),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => const SettingsScreen()),
                // );
              },
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                // Add logout logic here if needed
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child:provider.isLoading
            ? const Center(child: CircularProgressIndicator()):
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F8FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        AnimatedDashboardCard(icon: Icons.person, title:'Customer', count:provider.totalCustomers.toString(), bcolor:Colors.green),
                        AnimatedDashboardCard(icon: Icons.shop, title:'Products', count:provider.totalProducts.toString(), bcolor:Colors.red),
                        AnimatedDashboardCard(icon: Icons.people_rounded, title:'Staff', count:provider.totalStaffs.toString(), bcolor:Colors.blue),
                        AnimatedDashboardCard(icon: Icons.person, title:'Transactions', count:provider.totalTransactions.toString(), bcolor:Colors.orange)

                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Text("Performance Summary",style: TextStyle(fontWeight: FontWeight.bold),),
                // Container(
                //   decoration: BoxDecoration(
                //     color: const Color(0xFFF5F8FF),
                //       borderRadius: BorderRadius.circular(12),
                //   ),
                //   child: SizedBox(
                //     height: 250,
                //     child: PieChart(
                //       PieChartData(
                //         sectionsSpace: 3,
                //         centerSpaceRadius: 60,
                //         sections: provider.chartData
                //             .map(
                //               (item) => PieChartSectionData(
                //             color: item["color"],
                //             value: item["value"],
                //             title: "${item["value"].toInt()}", // show 576, 577
                //             radius: 40,
                //             titleStyle: const TextStyle(
                //               fontSize: 14,
                //               fontWeight: FontWeight.bold,
                //               color: Colors.white,
                //             ),
                //           ),
                //         )
                //             .toList(),
                //       ),
                //     ),
                //   ),
                // ),
                //
                // const SizedBox(height: 30),
                // _buildLegend(provider.chartData),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F8FF),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            const Text(
                              "Performance Overview",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              height: 250,
                              child: PieChart(
                                PieChartData(
                                  sectionsSpace: 2,
                                  centerSpaceRadius: 50,
                                  borderData: FlBorderData(show: false),
                                  sections: provider.chartData
                                      .map(
                                        (item) => PieChartSectionData(
                                      color: item["color"],
                                      value: item["value"],
                                      title: "${item["value"].toStringAsFixed(1)}%",
                                      radius: 60,
                                      titleStyle: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                      .toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Legends
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 16,
                        runSpacing: 8,
                        children: provider.chartData
                            .map((item) => Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: item["color"],
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "${item["title"]} (${item["value"].toStringAsFixed(1)}%)",
                              style: const TextStyle(fontSize: 14, color: Colors.black87),
                            ),
                          ],
                        ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Text("Follow-up Meeting",style: TextStyle(fontWeight: FontWeight.bold),),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CalendarWidget(), // 👈 use calendar here
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: provider.monthlyTrends.isEmpty
                      ? const Center(child: Text("No data available"))
                      : MonthlyTrendsChart(
                    totalCalls: provider.totalCalls,
                    monthlyData: provider.monthlyTrends,
                  ),
                ),
                SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: WeeklyVolumeChart(
                totalCalls: provider.totalWeeklyCalls,
                weeklyData: provider.weeklyData,),
            )
              ],
            ),
          ),
            ),
          ),
          
          

    );
  }
  double _total(List<Map<String, dynamic>> list) =>
      list.fold(0, (sum, e) => sum + (e["value"] as double));
  Widget _buildLegend(List<Map<String, dynamic>> data) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.start,
      alignment: WrapAlignment.start,
      spacing: 20,
      runSpacing: 10,
      children: data
          .map((item) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundColor: item["color"],
            radius: 5,

          ),
          const SizedBox(width: 8),
          Text(
            "${item["title"]}: ${item["value"].toInt()}",
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ))
          .toList(),
    );
  }

}
class AnimatedDashboardCard extends StatefulWidget {
  final IconData icon;
  final  String title;
  final String count;
  final Color bcolor;
  const AnimatedDashboardCard({super.key, required this.icon, required this.title, required this.count, required this.bcolor});

  @override
  State<AnimatedDashboardCard> createState() => _AnimatedDashboardCardState();
}

class _AnimatedDashboardCardState extends State<AnimatedDashboardCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2 - 24,
      decoration: BoxDecoration(
        color:widget.bcolor,
          borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
       children: [
         Icon(widget.icon,size: 32,color: Colors.white,),
         const SizedBox(height: 10),
    Text(widget.title,style: TextStyle(color: Colors.white),),
         const SizedBox(height: 10),
    Text(widget.count,style: TextStyle(color: Colors.white),),

        ],
      ),
    );
  }
}



class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DashBoardProvider>(context);

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
      //  color: Colors.white,
        color: const Color(0xFFF5F8FF),
        boxShadow: [
          BoxShadow(color: Colors.grey.shade300, blurRadius: 5, spreadRadius: 2)
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TableCalendar(
        firstDay: DateTime.utc(2024, 1, 1),
        lastDay: DateTime.utc(2026, 12, 31),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        calendarFormat: CalendarFormat.month,
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            color: Colors.indigo.shade300,
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: Colors.indigo,
            shape: BoxShape.circle,
          ),
        ),
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, focusedDay) {
            bool isMeeting = provider.isMeetingDay(day);
            return Container(
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isMeeting ? Colors.greenAccent.withOpacity(0.8) : null,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                '${day.day}',
                style: TextStyle(
                  color: isMeeting ? Colors.white : Colors.black,
                  fontWeight: isMeeting ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            );
          },
        ),
      ),

    );
  }
}

