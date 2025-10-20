
import 'package:flutter/material.dart';
import 'package:infinity/View/Meeting_calender/AllMeeting.dart';
import 'package:infinity/View/home/weekly_charts.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';


import '../../Provider/dashboard_provider.dart';
import '../AssignScreen/AssignCustomer.dart';
import '../Auths/Login_screen.dart';
import '../Customer/customer_list.dart';
import '../Meeting_calender/MeetingCalender.dart';
import '../followUpScreen/FollowUpScreen.dart';
import '../monthly chats.dart';
import '../products/product_screen.dart';
import '../staff/staffListScreen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider = Provider.of<DashBoardProvider>(context, listen: false);
      provider.loadAllDashboardData();
    });
  }
  Future<String?> _getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }




  Widget build(BuildContext context) {
    final provider = Provider.of<DashBoardProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Center(child: const Text("Dashboard",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 1.2,
          )),
        ),
          centerTitle: true,
          elevation: 6,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF5B86E5), Color(0xFF36D1DC)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
      ),

      // ✅ Drawer Menu Added
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF5B86E5), Color(0xFF36D1DC)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: FutureBuilder<String?>(
                future: _getUsername(), // async method defined above
                builder: (context, snapshot) {
                  final username = snapshot.data ?? "User";
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          color: Color(0xFF5B86E5),
                          size: 35,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Welcome $username',
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // Now add username text outside const
            FutureBuilder<String?>(
              future: _getUsername(),
              builder: (context, snapshot) {
                final username = snapshot.data ?? "User";
                return Padding(
                  padding: const EdgeInsets.only(left: 16.0, bottom: 10),
                  child: Text(
                    '',
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.dashboard, color: Color(0xFF5B86E5)),
              title: const Text('Dashboard'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.meeting_room, color: Color(0xFF5B86E5)),
              title: const Text('All Meeting detail'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => NoDateMeetingScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.follow_the_signs, color: Color(0xFF5B86E5)),
              title: const Text('Follow Up'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FollowUpScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.assignment_ind, color: Color(0xFF5B86E5)),
              title: const Text('Assign To'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => UnassignCustomerScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month, color: Color(0xFF5B86E5)),
              title: const Text('Calendar'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => UpcomingMeetingsScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Color(0xFF5B86E5)),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout'),
              onTap: () async {
                Navigator.pop(context);
                final shouldLogout = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Confirm Logout'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Logout',),
                      ),
                    ],
                  ),
                );
                if (shouldLogout == true) {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.clear();
                  if (!context.mounted) return;
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                        (route) => false,
                  );
                }
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
                        GestureDetector(
                          onTap: (){Navigator.push(context,MaterialPageRoute(builder: (context)=>CompanyListScreen()));},
                            child: AnimatedDashboardCard(icon: Icons.person, title:'Customer', count:provider.totalCustomers.toString(), bcolor:Colors.green)),
                        GestureDetector(
                            onTap: (){Navigator.push(context,MaterialPageRoute(builder: (context)=>ProductScreen()));},
                            child: AnimatedDashboardCard(icon: Icons.shop, title:'Products', count:provider.totalProducts.toString(), bcolor:Colors.red)),
                        GestureDetector(
                            onTap: (){Navigator.push(context,MaterialPageRoute(builder: (context)=>StaffScreen()));},
                            child: AnimatedDashboardCard(icon: Icons.people_alt, title:'Staff', count:provider.totalStaffs.toString(), bcolor:Colors.blue)),
                        AnimatedDashboardCard(icon: Icons.account_balance_wallet, title:'Transactions', count:provider.totalTransactions.toString(), bcolor:Colors.orange)

                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Text("Performance Summary",style: TextStyle(fontWeight: FontWeight.bold),),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFEEF2FF), Color(0xFFFFFFFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.indigo.withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Chart
                SizedBox(
                  height: 240,
                  child: provider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : PieChart(
                    PieChartData(
                      sectionsSpace: 3,
                      centerSpaceRadius: 55,
                      borderData: FlBorderData(show: false),
                      sections: provider.chartData
                          .map(
                            (item) => PieChartSectionData(
                          color: item["color"],
                          value: item["value"],
                          title:
                          "${item["value"].toStringAsFixed(1)}%", // show % in each section
                          radius: 65,
                          titleStyle: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black26,
                                blurRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      )
                          .toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Divider
                Container(
                  height: 1,
                  width: double.infinity,
                  color: Colors.indigo.withOpacity(0.2),
                  margin: const EdgeInsets.symmetric(vertical: 12),
                ),

                // Legends Section
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 18,
                  runSpacing: 10,
                  children: provider.chartData
                      .map((item) => Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: item["color"].withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: item["color"],
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "${item["title"]} (${item["value"].toStringAsFixed(1)}%)",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ))
                      .toList(),
                ),
              ],
            ),
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
                  padding: const EdgeInsets.all(8.0),
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
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: widget.bcolor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: widget.bcolor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
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

