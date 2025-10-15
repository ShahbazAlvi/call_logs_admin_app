import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../Provider/MeetingProvider/Meeting_provider.dart';


class UpcomingMeetingsScreen extends StatefulWidget {
  const UpcomingMeetingsScreen({super.key});

  @override
  State<UpcomingMeetingsScreen> createState() => _UpcomingMeetingsScreenState();
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

    return Scaffold(
      appBar: AppBar(
        title: const Text("Upcoming Meetings"),
        backgroundColor: Colors.indigo,
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // 🔹 Calendar View
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TableCalendar(
              firstDay: DateTime.utc(2024, 1, 1),
              lastDay: DateTime.utc(2026, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) =>
                  isSameDay(_selectedDay, day),
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
                defaultBuilder: (context, day, _) {
                  bool isMeeting = provider.isMeetingDay(day);
                  return Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: isMeeting
                          ? Colors.greenAccent.withOpacity(0.8)
                          : null,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${day.day}',
                      style: TextStyle(
                        color: isMeeting ? Colors.white : Colors.black,
                        fontWeight:
                        isMeeting ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 10),

          // 🔹 Meeting List Below Calendar
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
                final company = meeting['companyName'] ?? "Unknown";
                final times = (meeting['times'] as List)
                    .map((t) => t.toString())
                    .join(", ");

                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    leading: const Icon(Icons.business,
                        color: Colors.indigo),
                    title: Text(company),
                    subtitle: Text("Time: $times"),
                    trailing: Text(
                      meeting['timeline'] ?? '',
                      style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold),
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
