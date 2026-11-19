import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dashboard.dart';

class TransactionDetailScreen extends StatefulWidget {
  final int transactionId; // stores the id of the selected transaction

  const TransactionDetailScreen({
    super.key,
    required this.transactionId,
  });

  @override
  State<TransactionDetailScreen> createState() => _TransactionDetailScreenState();
} //Stateful widget end

class _TransactionDetailScreenState extends State<TransactionDetailScreen> {

  // controls the zooming and movement of the receipt image
  final TransformationController _imageController = TransformationController();

  IconData _getCategoryIcon(String category) {
    IconData catIcon = Icons.receipt_long; // default category icon

    if (category == 'Events') catIcon = Icons.receipt_long;
    if (category == 'Supplies') catIcon = Icons.inventory_2_rounded;
    if (category == 'Transportation') catIcon = Icons.directions_bus_rounded;
    if (category == 'Food') catIcon = Icons.fastfood_rounded;
    if (category == 'Membership Fee') catIcon = Icons.payments_rounded;
    if (category == 'Donation') catIcon = Icons.handshake_rounded;
    if (category == 'Event Profit') catIcon = Icons.attach_money_rounded;
    if (category == 'Others') catIcon = Icons.more_horiz_rounded;

    return catIcon; // returns the icon that matches the category
  }

  void _zoomIn() { // increases the current image zoom level by 1.25
    _imageController.value =
    _imageController.value.clone()..scaleByDouble(1.25, 1.25, 1.0, 1.0);
  }

  void _zoomOut() { // decreases the current image zoom level by 0.8
    _imageController.value =
    _imageController.value.clone()..scaleByDouble(0.8, 0.8, 1.0, 1.0);
  }

  void _resetZoom() { // resets the image to its original size and position
    _imageController.value = Matrix4.identity();
  }

  @override
  void dispose() {
    _imageController.dispose(); // releases the image controller when the screen closes
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: beige,

      body: Stack(
        children: [ //decorative circles placed around the screen
          Positioned(
            top: -10,
            left: -30,
            child: _circle(110, paleBlue),
          ),
          Positioned(
            top: 200,
            right: -30,
            child: _circle(96, mediumBlue),
          ),
          Positioned(
            top: 280,
            right: -10,
            child: _circle(38, paleBlue),
          ),
          Positioned(
            top: 420,
            left: -20,
            child: _circle(69, mediumBlue),
          ),
          Positioned(
            top: 387,
            left: -10,
            child: _circle(38, paleBlue),
          ),
          Positioned(
            bottom: 125,
            right: 10,
            child: _circle(30, paleBlue),
          ),

          SafeArea(
            child: Column(
              children: [

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [

                      GestureDetector( // returns to the previous screen when the back button is tapped
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.black,
                              width: 2.5,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black,
                                offset: Offset(3, 3),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.arrow_back_rounded,
                            color: darkBlue,
                            size: 22,
                          ),
                        ),
                      ),

                      const SizedBox(width: 14),

                      const Text(
                        'TRANSACTION DETAILS',
                        style: TextStyle(
                          fontFamily: 'Pixelify',
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: darkBlue,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: FutureBuilder( // connects to supabase and retrieves the selected transaction
                    future: Supabase.instance.client
                        .from('transactions') // selects the transactions table
                        .select() // retrieves the table data
                        .eq('id', widget.transactionId) // finds the record with the matching transaction id
                        .single(), // returns only one matching record

                    builder: (context, snapshot) { // rebuilds the screen depending on the database request status

                      if (snapshot.connectionState ==
                          ConnectionState.waiting) { // displays a loading indicator while fetching the record
                        return const Center(
                          child: CircularProgressIndicator(
                            color: darkBlue,
                          ),
                        );
                      }

                      if (snapshot.hasError || !snapshot.hasData) { // displays a message if the transaction cannot be retrieved
                        return const Center(
                          child: Text(
                            'Transaction not found.',
                            style: TextStyle(
                              fontFamily: 'Space',
                              color: darkBlue,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        );
                      }

                      final tx = snapshot.data!; // stores the retrieved transaction data

                      final isExpense = tx['type'] == 'expense'; // checks if the record is an expense
                      final isBalance = tx['type'] == 'balance'; // checks if the record is a balance

                      final title = tx['title'] ?? 'Untitled'; // retrieves the transaction title
                      final category = tx['category'] ?? 'General'; // retrieves the transaction category

                      final amount = double.tryParse(
                        tx['amount'].toString(), // converts the database amount into a string
                      ) ?? 0.0; // converts it into a double or uses 0.0 if conversion fails

                      final receiptNumber = tx['receipt_number'] ?? '';

                      final txDate = tx['transaction_date'] ?? ''; // retrieves the transaction date
                      final createdAt = tx['created_at'] ?? ''; // retrieves the record creation date

                      final receiptPhoto = tx['receipt_photo']; // retrieves the saved receipt photo path

                      // checks if a receipt photo path exists in the database
                      final hasReceipt = receiptPhoto != null && receiptPhoto.toString().isNotEmpty;

                      return SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 30,),

                        child: Column(
                          children: [

                            ConstrainedBox( // displays the verifund receipt slip for every transaction
                              constraints: const BoxConstraints( // the receipt slip uses information retrieved from supabase
                                maxWidth: 390,
                              ),
                              child: PhysicalShape(
                                clipper: ReceiptClipper(), // applies the perforated receipt bottom design
                                color: Colors.white,
                                elevation: 12,

                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 42,),
                                  color: Colors.white,

                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [

                                      const DashedDivider(),

                                      const SizedBox(height: 12),

                                      Row(
                                        children: [
                                          Icon( // displays an icon based on the transaction category
                                            _getCategoryIcon(
                                              category.toString(),
                                            ),
                                            color: darkBlue,
                                            size: 65,
                                          ),

                                          const SizedBox(width: 14),

                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [

                                                const Text(
                                                  'VeriFund',
                                                  style: TextStyle(
                                                    fontFamily: 'Pixelify',
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.w700,
                                                    color: darkBlue,
                                                  ),
                                                ),

                                                const Text(
                                                  'Receipt',
                                                  style: TextStyle(
                                                    fontFamily: 'Pixelify',
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.w700,
                                                    color: darkBlue,
                                                  ),
                                                ),

                                                Text( // displays the transaction id as the record number
                                                  'Record No. ${widget.transactionId}',
                                                  style: const TextStyle(
                                                    fontFamily: 'Space',
                                                    fontSize: 11,
                                                    color: darkBlue,
                                                  ),
                                                ),

                                                Text( // displays the transaction id as the record number
                                                  'No. $receiptNumber',
                                                  style: const TextStyle(
                                                    fontFamily: 'Space',
                                                    fontSize: 11,
                                                    color: darkBlue,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 12),
                                      const DashedDivider(),
                                      const SizedBox(height: 18),

                                      _buildReceiptRow( // displays the transaction type retrieved from the database
                                        'Type:',
                                        tx['type'].toString().toLowerCase(),
                                      ),

                                      const SizedBox(height: 14),

                                      _buildReceiptRow(  // displays the transaction title
                                        'Title:',
                                        title.toString(),
                                      ),

                                      const SizedBox(height: 14),

                                      _buildReceiptRow( // displays the transaction category
                                        'Category:',
                                        category.toString(),
                                      ),

                                      const SizedBox(height: 18),
                                      const DashedDivider(),
                                      const SizedBox(height: 18),

                                      _buildReceiptRow( // displays a minus sign for expenses and a plus sign for balances
                                        'Total:',
                                        '${isExpense ? '- ' : '+ '}₱${amount.toStringAsFixed(2)}',
                                        isAmount: true,
                                        amountColor:
                                        isExpense ? red : darkBlue, // changes the amount color based on transaction type
                                      ),

                                      const SizedBox(height: 18),
                                      const DashedDivider(),
                                      const SizedBox(height: 18),

                                      Center(
                                        child: Column(
                                          children: [

                                            const Text(
                                              'Transaction Date:',
                                              style: TextStyle(
                                                fontFamily: 'Space',
                                                fontSize: 12,
                                                color: darkBlue,
                                              ),
                                            ),

                                            const SizedBox(height: 4),

                                            Text( // displays the date when the transaction occurred
                                              txDate.toString(),
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontFamily: 'Space',
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                                color: darkBlue,
                                              ),
                                            ),

                                            const SizedBox(height: 12),

                                            const Text(
                                              'Creation Date:',
                                              style: TextStyle(
                                                fontFamily: 'Space',
                                                fontSize: 12,
                                                color: darkBlue,
                                              ),
                                            ),

                                            const SizedBox(height: 4),

                                            Text( // displays when the transaction record was created
                                              createdAt.toString(),
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontFamily: 'Space',
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                                color: darkBlue,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            if (!isBalance) ...[ // displays the original receipt viewer only for expense transactions

                              const SizedBox(height: 35),

                              ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 750,
                                ),

                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(14),

                                  decoration: BoxDecoration(
                                    color: lightBlue,
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 3,
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black,
                                        offset: Offset(5, 5),
                                      ),
                                    ],
                                  ),

                                  child: Column(
                                    children: [

                                      Container( // displays the original receipt viewer header
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 18,
                                          vertical: 14,
                                        ),
                                        decoration: BoxDecoration(
                                          color: darkBlue,
                                          borderRadius:
                                          BorderRadius.circular(40),
                                          border: Border.all(
                                            color: Colors.black,
                                            width: 2.5,
                                          ),
                                        ),

                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [

                                            const Flexible(
                                              child: Text(
                                                'ORIGINAL RECEIPT',
                                                style: TextStyle(
                                                  fontFamily: 'Pixelify',
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700,
                                                  color: beige,
                                                ),
                                              ),
                                            ),

                                            const SizedBox(width: 8),

                                            const Text(
                                              '01 / 01',
                                              style: TextStyle(
                                                fontFamily: 'Space',
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                                color: beige,
                                              ),
                                            ),

                                          ],
                                        ),
                                      ),

                                      const SizedBox(height: 14),

                                      Container( // container that holds the original receipt photo or placeholder message
                                        height: 380,
                                        width: double.infinity,

                                        decoration: BoxDecoration(
                                          color: const Color(0xFF1E1E1E),
                                          borderRadius:
                                          BorderRadius.circular(20),
                                          border: Border.all(
                                            color: Colors.black,
                                            width: 2.5,
                                          ),
                                        ),

                                        child: ClipRRect(
                                          borderRadius:
                                          BorderRadius.circular(17),

                                          child: hasReceipt // checks if a receipt photo path exists before loading the image
                                              ? InteractiveViewer(
                                            transformationController:
                                            _imageController, // connects the image to the zoom controller
                                            minScale: 0.8, // sets the minimum zoom level
                                            maxScale: 5.0, // sets the maximum zoom level

                                            child: Image.network( // loads the image from the laravel storage server using its saved database path
                                              'http://10.0.2.2:8000/storage/${receiptPhoto.toString()}',

                                              width: double.infinity,
                                              height: double.infinity,
                                              fit: BoxFit.contain, // displays the entire image without cropping

                                              loadingBuilder: ( // displays a loading indicator while the photo is being downloaded
                                                  context,
                                                  child,
                                                  progress,
                                                  ) {
                                                if (progress == null) {
                                                  return child; // displays the image once loading is complete
                                                }

                                                return const Center(
                                                  child:
                                                  CircularProgressIndicator(
                                                    color: Colors.white,
                                                  ),
                                                );
                                              },

                                              errorBuilder: (  // displays a loading indicator while the photo is being downloaded
                                                  context,
                                                  error,
                                                  stackTrace,
                                                  ) {
                                                return _imageMessage(
                                                  'Receipt image failed to load',
                                                );
                                              },
                                            ),
                                          )
                                              : _imageMessage(
                                            'No receipt photo attached', // displays a message if no photo path exists
                                          ),
                                        ),
                                      ),

                                      const SizedBox(height: 16),

                                      Row( // image zoom buttons
                                        children: [

                                          _viewerButton(
                                            Icons.remove_rounded,
                                            _zoomOut, // decreases image size
                                          ),

                                          const SizedBox(width: 8),

                                          _viewerButton(
                                            Icons.add_rounded,
                                            _zoomIn, // increases image size
                                          ),

                                          const SizedBox(width: 8),

                                          _viewerButton(
                                            Icons.refresh_rounded,
                                            _resetZoom, // restores original image size
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],

                            const SizedBox(height: 20),

                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      bottomNavigationBar: const BottomNavBar( // displays the bottom navigation bar with the records tab selected
        selectedIndex: 1,
      ),
    );
  }

  Widget _circle(double size, Color color) { // creates the decorative background circles
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }

  Widget _buildReceiptRow( // creates a row containing a receipt label and its corresponding value
      String label,
      String value, {
        bool isAmount = false,
        Color? amountColor,
      }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        Text(
          label,
          style: TextStyle(
            fontFamily: 'Space',
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: darkBlue.withValues(alpha: 0.85),
          ),
        ),

        const SizedBox(width: 12),

        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontFamily: 'Space',
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: amountColor ?? darkBlue, // uses the provided color or the default dark blue
            ),
          ),
        ),

      ],
    );
  }

  Widget _imageMessage(String message) { // displays a message inside the receipt image viewer
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Space',
            fontSize: 12,
            color: Colors.white.withValues(alpha: 0.65),
          ),
        ),
      ),
    );
  }

  Widget _viewerButton(  // creates the buttons used to control the receipt image
      IconData icon,
      VoidCallback onPressed,
      ) {
    return GestureDetector(
      onTap: onPressed, // runs the assigned zoom function when tapped
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: darkBlue,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.black,
            width: 2.5,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              offset: Offset(3, 3),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: beige,
          size: 23,
        ),
      ),
    );
  }
}

class DashedDivider extends StatelessWidget { // custom widget that creates a dashed horizontal divider
  const DashedDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 4,
      width: double.infinity,
      child: CustomPaint(
        painter: DashedDividerPainter(), // uses the custom painter to draw the dashes
      ),
    );
  }
}

class DashedDividerPainter extends CustomPainter { // draws the individual dashes used by the receipt divider
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = darkBlue // sets the dash color
      ..strokeWidth = 2 // sets the dash thickness
      ..style = PaintingStyle.stroke;

    const dashWidth = 5.0; // width of each dash
    const dashSpace = 3.0; // space between each dash

    double startX = 0;

    while (startX < size.width) { // repeatedly draws dashes until the entire width is covered
      final endX = (startX + dashWidth)
          .clamp(0.0, size.width)
          .toDouble();

      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(endX, size.height / 2),
        paint,
      );

      startX += dashWidth + dashSpace; // moves to the next dash position
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false; // prevents unnecessary repainting
  }
}

class ReceiptClipper extends CustomClipper<Path> { // custom clipper that creates the perforated bottom of the receipt
  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(0, 0); // starts at the top-left corner
    path.lineTo(size.width, 0); // draws the top edge
    path.lineTo(size.width, size.height - 14); // moves to the bottom-right area

    double x = size.width;

    const notchWidth = 18.0; // controls the width of each receipt notch

    while (x > 0) { // creates repeated curved notches along the bottom edge
      final nextX = (x - notchWidth)
          .clamp(0.0, size.width)
          .toDouble();

      path.quadraticBezierTo(
        (x + nextX) / 2,
        size.height - 29, // controls the depth of each notch
        nextX,
        size.height - 14,
      );

      x = nextX; // moves to the next notch
    }

    path.lineTo(0, 0); // connects the path back to the starting point
    path.close(); // closes the shape

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false; // keeps the existing shape unless clipping needs to change
  }
}
