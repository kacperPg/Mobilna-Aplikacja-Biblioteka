import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:prosta_aplikcja/models/booked_model_advanced.dart';
import 'package:prosta_aplikcja/screens/admin/bookedAdmin/edit_order_screen.dart';
import 'package:prosta_aplikcja/widgets/subtitles_text.dart';
import 'package:prosta_aplikcja/widgets/titles_text.dart';
import 'package:intl/intl.dart';

class OrdersWidgetFree extends StatefulWidget {
  const OrdersWidgetFree({super.key, required this.ordersModelAdvanced});
  final BookedModelAdvanced ordersModelAdvanced;

  @override
  State<OrdersWidgetFree> createState() => _OrdersWidgetFreeState();
}

class _OrdersWidgetFreeState extends State<OrdersWidgetFree> {
  bool isLoading = false;

  String formatTimestamp(Timestamp timestamp) {
    return DateFormat('yyyy-MM-dd HH:mm').format(timestamp.toDate());
  }

   String getDaysLeftToReturn(DateTime orderDate) {
    final expectDate = orderDate.add(Duration(days: 20));
    final currentDate = DateTime.now();
    final difference = expectDate.difference(currentDate).inDays;
    return difference.toString();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bookedDate = widget.ordersModelAdvanced.bookedDate;

    String daysLeft = '';
    Color textColor = Colors.black;

    if (bookedDate != null) {
      final difference = getDaysLeftToReturn(bookedDate.toDate());

      int daysRemaining = int.parse(difference);

       if (daysRemaining < 0) {
        daysLeft = '$difference dni';
        textColor = Colors.red;
      } else {
        daysLeft = '$difference dni';
        textColor = Colors.white;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: FancyShimmerImage(
              height: size.width * 0.25,
              width: size.width * 0.25,
              imageUrl: widget.ordersModelAdvanced.imageUrl,
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: TitlesTextWidget(
                          label: widget.ordersModelAdvanced.productTitle,
                          maxLines: 2,
                          fontSize: 15,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SubtitileTextWidget(
                    label: "Ilość :${widget.ordersModelAdvanced.quantity}",
                    fontSize: 15,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                   SubtitileTextWidget(
                    label: "Data wypożyczenia :${formatTimestamp(widget.ordersModelAdvanced.bookedDate)}",
                    fontSize: 15,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  if (widget.ordersModelAdvanced.returnDate != null)
                    SubtitileTextWidget(
                      label: "Data zwrotu :${formatTimestamp(widget.ordersModelAdvanced.returnDate!)}",
                      fontSize: 15,
                    )
                  else
                    const SizedBox.shrink(),
                  const SizedBox(
                    height: 5,
                  ),
                  if (widget.ordersModelAdvanced.status != null)
                    SubtitileTextWidget(
                      label: "Status :${widget.ordersModelAdvanced.status}",
                      fontSize: 15,
                    )
                  else
                    const SizedBox.shrink(),
                  const SizedBox(
                    height: 5,
                  ),
                  if (daysLeft.isNotEmpty &&
                      widget.ordersModelAdvanced.status != 'Zwrócona')
                    SubtitileTextWidget(
                      label: "Ile do zwrotu: $daysLeft",
                      fontSize: 15,
                      color: textColor,
                    ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
