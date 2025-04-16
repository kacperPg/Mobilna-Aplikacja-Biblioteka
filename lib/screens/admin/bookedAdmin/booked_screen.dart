import 'package:flutter/material.dart';
import 'package:prosta_aplikcja/models/booked_model_advanced.dart';
import 'package:prosta_aplikcja/providers/booked_provider.dart';
import 'package:prosta_aplikcja/screens/admin/bookedAdmin/booked_widget.dart';
import 'package:prosta_aplikcja/widgets/titles_text.dart';
import 'package:provider/provider.dart';

class BookedScreenFree extends StatefulWidget {
  static const routeName = '/BookedScreen';

  const BookedScreenFree({super.key});

  @override
  State<BookedScreenFree> createState() => _BookedScreenFreeState();
}

class _BookedScreenFreeState extends State<BookedScreenFree> {
  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<BookedProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: TitlesTextWidget(
          label: 'Wypożyczenia',
        ),
      ),
      body: FutureBuilder<List<BookedModelAdvanced>>(
        future: ordersProvider.fetchAllOrders(context), // Fetch all orders here
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: SelectableText(snapshot.error.toString()),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Nie ma wypożyczeń'),
            );
          }

          return ListView.separated(
            itemCount: snapshot.data!.length,
            itemBuilder: (ctx, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                child: BookedWidgetFree(
                  bookedModelAdvanced: snapshot.data![index],
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Divider();
            },
          );
        },
      ),
    );
  }
}
