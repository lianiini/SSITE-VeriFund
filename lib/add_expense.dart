import 'package:flutter/material.dart';
import 'dashboard.dart';

// COLORS
const Color darkText = Color(0xFF303030);
const Color greyText = Color(0xFF777777);

class AddExpenseScreen extends StatelessWidget {
  const AddExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: beige,
      body: Stack(
        children: [
          // Background decorative circles matching dashboard
          Positioned(
            top: -10,
            left: -30,
            child: Container(
              width: 110,
              height: 110,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: paleBlue,
              ),
            ),
          ),
          Positioned(
            top: 200,
            right: -30,
            child: Container(
              width: 96,
              height: 96,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: mediumBlue,
              ),
            ),
          ),
          Positioned(
            top: 280,
            right: -10,
            child: Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: paleBlue,
              ),
            ),
          ),
          Positioned(
            top: 420,
            left: -20,
            child: Container(
              width: 69,
              height: 69,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: mediumBlue,
              ),
            ),
          ),
          Positioned(
            top: 387,
            left: -10,
            child: Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: paleBlue,
              ),
            ),
          ),
          Positioned(
            bottom: 125,
            right: 10,
            child: Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: paleBlue,
              ),
            ),
          ),

          // Main screen content
          SafeArea(
            child: Column(
              children: [
                // ==========================
                // TOP BAR
                // ==========================
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
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
                            Icons.arrow_back,
                            color: darkBlue,
                            size: 22,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Text(
                        'ADD EXPENSE',
                        style: TextStyle(
                          fontFamily: 'Pixelify',
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: darkBlue,
                        ),
                      ),
                    ],
                  ),
                ),

                // ==========================
                // FORM
                // ==========================
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // EXPENSE INFORMATION
                        _sectionTitle('Expense Information'),
                        const SizedBox(height: 10),

                        _card(
                          Column(
                            children: [
                              _textField(
                                label: 'Amount',
                                hint: 'Enter amount',
                                prefix: '₱ ',
                              ),
                              const SizedBox(height: 16),
                              _textField(
                                label: 'Description',
                                hint: 'Describe what was purchased',
                                maxLines: 3,
                              ),
                              const SizedBox(height: 16),
                              _dropdown(
                                label: 'Expense Category',
                                hint: 'Select Category',
                              ),
                              const SizedBox(height: 16),
                              _textField(
                                label: 'Date of Expense',
                                hint: 'Select date',
                                suffixIcon: Icons.calendar_today_outlined,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // RECEIPT INFORMATION
                        _sectionTitle('Receipt Information'),
                        const SizedBox(height: 10),

                        _card(
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _textField(
                                label: 'Receipt / Transaction Number',
                                hint: 'Enter receipt or transaction number',
                              ),
                              const SizedBox(height: 20),
                              _label('Receipt Photo'),
                              const SizedBox(height: 8),

                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: paleBlue,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 2.0,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 58,
                                      height: 58,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 2.0,
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.receipt_long_outlined,
                                        size: 30,
                                        color: darkBlue,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    const Text(
                                      'Add receipt photo',
                                      style: TextStyle(
                                        fontFamily: 'Space',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: darkBlue,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      'Take a photo or select from gallery',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Space',
                                        fontSize: 11,
                                        color: darkBlue.withOpacity(0.7),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        _photoButton(
                                          Icons.camera_alt_outlined,
                                          'Camera',
                                        ),
                                        const SizedBox(width: 12),
                                        _photoButton(
                                          Icons.photo_library_outlined,
                                          'Gallery',
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // OCR SECTION
                        _sectionTitle('Receipt OCR'),
                        const SizedBox(height: 10),

                        _card(
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 42,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      color: paleBlue,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 2.0,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.document_scanner_outlined,
                                      color: darkBlue,
                                      size: 22,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Automatic Receipt Reading',
                                          style: TextStyle(
                                            fontFamily: 'Space',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: darkBlue,
                                          ),
                                        ),
                                        SizedBox(height: 3),
                                        Text(
                                          'OCR will read information from your receipt',
                                          style: TextStyle(
                                            fontFamily: 'Space',
                                            fontSize: 11,
                                            color: greyText,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),
                              _ocrResult('Merchant', 'Merchant Name'),
                              _ocrResult('Receipt Number', 'Receipt Number'),
                              _ocrResult('Date', 'Receipt Date'),
                              _ocrResult('Total', 'Total Amount'),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: paleBlue.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 1.5,
                                  ),
                                ),
                                child: const Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      size: 18,
                                      color: darkBlue,
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Review the information extracted by OCR before submitting the expense.',
                                        style: TextStyle(
                                          fontFamily: 'Space',
                                          fontSize: 11,
                                          color: darkBlue,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ADDITIONAL INFORMATION
                        _sectionTitle('Additional Information'),
                        const SizedBox(height: 10),

                        _card(
                          _textField(
                            label: 'Notes',
                            hint: 'Additional information about this expense',
                            maxLines: 4,
                          ),
                        ),

                        const SizedBox(height: 30),

                        // SUBMIT BUTTON
                        Container(
                          width: double.infinity,
                          height: 54,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.black,
                              width: 3.0,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black,
                                offset: Offset(5, 6),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              // TODO: Save expense
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: darkBlue,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13),
                              ),
                            ),
                            child: const Text(
                              'Submit Expense',
                              style: TextStyle(
                                fontFamily: 'Space',
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================
  // REUSABLE WIDGETS
  // ==========================

  static Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Pixelify',
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: darkBlue,
      ),
    );
  }

  static Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Space',
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: darkBlue,
      ),
    );
  }

  static Widget _card(Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: lightBlue,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.black,
          width: 3.0,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            offset: Offset(6, 7),
          ),
        ],
      ),
      child: child,
    );
  }

  static Widget _textField({
    required String label,
    required String hint,
    String? prefix,
    IconData? suffixIcon,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(label),
        const SizedBox(height: 7),
        TextField(
          maxLines: maxLines,
          style: const TextStyle(
            fontFamily: 'Space',
            fontSize: 13,
            color: darkBlue,
          ),
          decoration: InputDecoration(
            hintText: hint,
            prefixText: prefix,
            prefixStyle: const TextStyle(
              fontFamily: 'Space',
              color: darkBlue,
              fontWeight: FontWeight.w700,
            ),
            hintStyle: TextStyle(
              fontFamily: 'Space',
              color: darkBlue.withOpacity(0.5),
              fontSize: 12,
            ),
            suffixIcon: suffixIcon != null
                ? Icon(
              suffixIcon,
              color: darkBlue,
              size: 20,
            )
                : null,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.black,
                width: 2.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.black,
                width: 2.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: darkBlue,
                width: 2.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 13,
            ),
          ),
        ),
      ],
    );
  }

  static Widget _dropdown({
    required String label,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(label),
        const SizedBox(height: 7),
        DropdownButtonFormField<String>(
          dropdownColor: Colors.white,
          style: const TextStyle(
            fontFamily: 'Space',
            fontSize: 13,
            color: darkBlue,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontFamily: 'Space',
              color: darkBlue.withOpacity(0.5),
              fontSize: 12,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.black,
                width: 2.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.black,
                width: 2.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: darkBlue,
                width: 2.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 13,
            ),
          ),
          items: const [
            DropdownMenuItem(
              value: '<Category 1>',
              child: Text(
                '<Category 1>',
                style: TextStyle(fontFamily: 'Space', color: darkBlue),
              ),
            ),
            DropdownMenuItem(
              value: '<Category 2>',
              child: Text(
                '<Category 2>',
                style: TextStyle(fontFamily: 'Space', color: darkBlue),
              ),
            ),
            DropdownMenuItem(
              value: '<Category 3>',
              child: Text(
                '<Category 3>',
                style: TextStyle(fontFamily: 'Space', color: darkBlue),
              ),
            ),
            DropdownMenuItem(
              value: '<Category 4>',
              child: Text(
                '<Category 4>',
                style: TextStyle(fontFamily: 'Space', color: darkBlue),
              ),
            ),
          ],
          onChanged: (value) {},
        ),
      ],
    );
  }

  static Widget _photoButton(
      IconData icon,
      String label,
      ) {
    return GestureDetector(
      onTap: () {
        // TODO: Open camera/gallery
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.black,
            width: 2.0,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: darkBlue,
            ),
            const SizedBox(width: 6),
            Text(
              label,
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
    );
  }

  static Widget _ocrResult(
      String label,
      String value,
      ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 11,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.black,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Space',
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: darkBlue,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Space',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: darkBlue.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}