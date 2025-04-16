import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:prosta_aplikcja/models/booked_model_advanced.dart';
import 'package:prosta_aplikcja/screens/admin/bookedAdmin/booked_screen.dart';

class EditOrderScreen extends StatefulWidget {
  final BookedModelAdvanced order;

  const EditOrderScreen({Key? key, required this.order}) : super(key: key);

  @override
  State<EditOrderScreen> createState() => _EditOrderScreenState();
}

class _EditOrderScreenState extends State<EditOrderScreen> {
  final _statusController = TextEditingController();
  final _returnDateController = TextEditingController();
  String _selectedStatus = "Wypożyczona";

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.order.status ?? "Wypożyczona";
    _returnDateController.text = widget.order.returnDate != null
        ? widget.order.returnDate!.toDate().toString().split(' ')[0]
        : '';
  }

  @override
  void dispose() {
    _statusController.dispose();
    _returnDateController.dispose();
    super.dispose();
  }

  void _saveOrder() async {
    try {
      await FirebaseFirestore.instance
          .collection("ordersAdvanced")
          .doc(widget.order.orderId)
          .update({
        'status': _selectedStatus,
        'returnDate': _returnDateController.text.isNotEmpty
            ? DateTime.parse(_returnDateController.text)
            : null,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Zamówienie edytowane!')),
      );
      Navigator.pushNamed(
        context,
        BookedScreenFree.routeName,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nie udało się edytować: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edytuj zamówienie'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
             DropdownButtonFormField<String>(
              value: _selectedStatus,
              decoration: const InputDecoration(labelText: 'Status'),
              items: const [
                DropdownMenuItem(
                  value: "Wypożyczona",
                  child: Text("Wypożyczona"),
                ),
                DropdownMenuItem(
                  value: "Zwrócona",
                  child: Text("Zwrócona"),
                ),
              ],
              onChanged: (String? newValue) {
                setState(() {
                  _selectedStatus = newValue!;
                });
              },
            ),
            const SizedBox(height: 20),
             TextField(
              controller: _returnDateController,
              decoration: const InputDecoration(labelText: 'Data zwrotu'),
              keyboardType: TextInputType.datetime,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  setState(() {
                    _returnDateController.text =
                    pickedDate.toString().split(' ')[0];
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveOrder,
              child: const Text('Zmiany zapisano'),
            ),
          ],
        ),
      ),
    );
  }
}
