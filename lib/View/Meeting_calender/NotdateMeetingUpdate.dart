import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Provider/MeetingProvider/NoDateMeetingProvider.dart';
import '../../model/AllMeetingModel.dart';


class EditMeetingScreen extends StatefulWidget {
  final MeetingData meeting;


  const EditMeetingScreen({
    super.key,
    required this.meeting,
  });

  @override
  State<EditMeetingScreen> createState() => _EditMeetingScreenState();
}

class _EditMeetingScreenState extends State<EditMeetingScreen> {
  String? selectedTimeline;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  final TextEditingController detailsController = TextEditingController();

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  Future<void> pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => selectedTime = picked);
  }

  Future<void> _launchPhone(String phoneNumber) async {
    var cleaned = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    if (cleaned.startsWith('0')) {
      cleaned = '92${cleaned.substring(1)}'; // Add Pakistan country code
    }
    final Uri phoneUri = Uri(scheme: 'tel', path: cleaned);

    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('❌ Could not launch phone dialer for $cleaned');
    }
  }



  Future<void> _launchWhatsApp(String phoneNumber) async {
    var cleaned = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleaned.startsWith('0')) {
      cleaned = '92${cleaned.substring(1)}';
    } else if (!cleaned.startsWith('92')) {
      cleaned = '92$cleaned';
    }

    final Uri whatsappUri = Uri.parse("https://wa.me/$cleaned");

    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('❌ Could not open WhatsApp for $cleaned');
    }
  }



  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NoDateMeetingProvider>(context, listen: false);
    final m = widget.meeting;

    final personName = (m.person?.persons.isNotEmpty ?? false)
        ? m.person!.persons.first.fullName ?? "Unknown"
        : "Unknown";

    final phoneNumber = (m.person?.persons.isNotEmpty ?? false)
        ? m.person!.persons.first.phoneNumber ?? ""
        : "";

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Center(child: const Text("Edit Meeting",style: TextStyle(color: Colors.white),)),
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            infoTile("🏢 Company", m.companyName ?? "Unknown"),
            infoTile("👤 Person", personName),
            infoTile("📦 Product", m.product?.name ?? "N/A"),
            infoTile("🧑‍💼 Staff", m.person?.assignedStaff?.username ?? "Unassigned"),

            const SizedBox(height: 16),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.call, color: Colors.green),
                  onPressed: ()=>
          _launchPhone(phoneNumber),
                ),
                IconButton(
                  icon: Image.asset("assets/images/whatsapp.jpeg",
                      width: 30, height: 30),
                  onPressed: () =>
                    _launchWhatsApp(phoneNumber),
                ),
              ],
            ),

            const Divider(height: 30, thickness: 1),

            const Text("Meeting Type",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            buildRadio("Follow Up"),
            buildRadio("Not Interested"),
            buildRadio("Already Installed"),
            buildRadio("Phone Responded"),

            if (selectedTimeline == "Follow Up") ...[
              const SizedBox(height: 12),
              Text("Next Follow-up Date", style: labelStyle()),
              ElevatedButton(
                onPressed: pickDate,
                child: Text(selectedDate == null
                    ? "Select Date"
                    : DateFormat('yyyy-MM-dd').format(selectedDate!)),
              ),
              const SizedBox(height: 10),
              Text("Next Follow-up Time", style: labelStyle()),
              ElevatedButton(
                onPressed: pickTime,
                child: Text(selectedTime == null
                    ? "Select Time"
                    : selectedTime!.format(context)),
              ),
              const SizedBox(height: 10),
              Text("Visit Details", style: labelStyle()),
              TextField(
                controller: detailsController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: "Enter details...",
                  border: OutlineInputBorder(),
                ),
              ),
            ],

            const SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text("Save Changes"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  if (selectedTimeline == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Please select a meeting type")),
                    );
                    return;
                  }

                  await provider.updateMeeting(
                    id: m.id!,
                    timeline: selectedTimeline!,
                    companyName: m.companyName ?? '',
                    personId: m.person?.id ?? '',
                    productId: m.product?.id ?? '',
                    staffId: m.person?.assignedStaff?.id ?? '',
                    nextDate: selectedDate != null
                        ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                        : null,
                    nextTime: selectedTime != null ? selectedTime!.format(context) : null,
                    details: detailsController.text,
                    designation: "Manager",
                    detailsOption: "Visit Done",
                    referenceProvidedBy: "Customer",
                    contactMethod: "Phone",
                  );


                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("✅ Meeting updated")),
                    );
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRadio(String label) {
    return RadioListTile<String>(
      value: label,
      groupValue: selectedTimeline,
      title: Text(label),
      onChanged: (value) => setState(() => selectedTimeline = value),
    );
  }

  Widget infoTile(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: labelStyle()),
          Flexible(
              child: Text(value,
                  style: const TextStyle(fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }

  TextStyle labelStyle() =>
      const TextStyle(fontWeight: FontWeight.bold, fontSize: 15);
}
