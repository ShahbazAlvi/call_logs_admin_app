
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../../Provider/MeetingProvider/Meeting_provider.dart';

class UpcomingMeetingsScreen extends StatefulWidget {
  const UpcomingMeetingsScreen({super.key});

  @override
  State<UpcomingMeetingsScreen> createState() =>
      _UpcomingMeetingsScreenState();
}

class _UpcomingMeetingsScreenState extends State<UpcomingMeetingsScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<MeetingProvider>(context, listen: false)
            .fetchUpcomingMeetings());
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MeetingProvider>(context);
    final meetingsForSelectedDate = _selectedDay != null
        ? provider.getMeetingsForDate(_selectedDay!)
        : [];

    final currentMonth = DateFormat.MMMM().format(_focusedDay);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "$currentMonth - All Meetings",
          style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
        ),
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // 🔹 Calendar
          Padding(
            padding: const EdgeInsets.all(8.0),
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
              onPageChanged: (focusedDay) {
                setState(() => _focusedDay = focusedDay);
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
                outsideDaysVisible: false,
              ),
              // ✅ Highlight days with meetings
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, _) {
                  final meetings = provider.getMeetingsForDate(day);
                  final hasMeeting = meetings.isNotEmpty;

                  if (hasMeeting) {
                    // 🟢 Highlight meeting days
                    return Container(
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.greenAccent.withOpacity(0.4),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${day.day}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                        ),
                      ),
                    );
                  }

                  // Normal day
                  return Center(
                    child: Text(
                      '${day.day}',
                      style: const TextStyle(color: Colors.black),
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 10),

          // 🔹 Meeting list
          Expanded(
            child: meetingsForSelectedDate.isEmpty
                ? const Center(
              child: Text(
                "No meetings on this day",
                style: TextStyle(fontSize: 16),
              ),
            )
                : ListView.builder(
              itemCount: meetingsForSelectedDate.length,
              itemBuilder: (context, index) {
                final meeting = meetingsForSelectedDate[index];
                final company =
                    meeting['companyName'] ?? "Unknown";
                final person = meeting['person'] ?? "";
                final times = (meeting['times'] as List)
                    .map((t) => t.toString())
                    .join(", ");
                final timeline = meeting['timeline'] ?? '';

                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.business,
                        color: Colors.indigo),
                    title: Text(company),
                    subtitle:
                    Text("Person: $person\nTime: $times"),
                    trailing: Text(
                      timeline,
                      style: TextStyle(
                        color: timeline == 'Hold'
                            ? Colors.orange
                            : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

