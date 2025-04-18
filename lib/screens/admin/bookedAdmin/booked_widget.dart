import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prosta_aplikcja/models/booked_model_advanced.dart';
import 'package:prosta_aplikcja/screens/admin/bookedAdmin/edit_order_screen.dart';
import 'package:prosta_aplikcja/widgets/subtitles_text.dart';
import 'package:prosta_aplikcja/widgets/titles_text.dart';

class BookedWidgetFree extends StatefulWidget {
  const BookedWidgetFree({super.key, required this.bookedModelAdvanced});

  final BookedModelAdvanced bookedModelAdvanced;

  @override
  State<BookedWidgetFree> createState() => _BookedWidgetFreeState();
}

String formatTimestamp(Timestamp timestamp) {
  return DateFormat('yyyy-MM-dd HH:mm').format(timestamp.toDate());
}

class _BookedWidgetFreeState extends State<BookedWidgetFree> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: FancyShimmerImage(
              height: size.width * 0.25,
              width: size.width * 0.25,
              imageUrl: widget.bookedModelAdvanced.imageUrl,
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
                          label: widget.bookedModelAdvanced.productTitle,
                          maxLines: 2,
                          fontSize: 15,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => EditOrderScreen(
                                  order: widget.bookedModelAdvanced),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.red,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SubtitileTextWidget(
                    label: "Ilość:${widget.bookedModelAdvanced.quantity}",
                    fontSize: 15,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SubtitileTextWidget(
                    label: "Użytkownik: ${widget.bookedModelAdvanced.userName}",
                    fontSize: 15,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  // Format and display the bookedDate
                  SubtitileTextWidget(
                    label:
                        "Data wypożyczenia :${formatTimestamp(widget.bookedModelAdvanced.bookedDate)}",
                    fontSize: 15,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  if (widget.bookedModelAdvanced.returnDate != null)
                    SubtitileTextWidget(
                      label:
                          "Data zwrotu :${formatTimestamp(widget.bookedModelAdvanced.returnDate!)}",
                      fontSize: 15,
                    )
                  else
                    const SizedBox.shrink(),
                  const SizedBox(
                    height: 5,
                  ),
                  if (widget.bookedModelAdvanced.status != null)
                    SubtitileTextWidget(
                      label: "Status :${widget.bookedModelAdvanced.status}",
                      fontSize: 15,
                    )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
