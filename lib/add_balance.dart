import 'package:flutter/material.dart';
import 'dashboard.dart';

class AddBalanceScreen extends StatelessWidget {
  const AddBalanceScreen({super.key});

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
                        'ADD BALANCE',
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
                        // PAYMENT INFORMATION
                        _sectionTitle('Payment Information'),
                        const SizedBox(height: 10),

                        _card(
                          Column(
                            children: [
                              _textField(
                                label: 'Amount',
                                hint: 'Enter membership fee',
                                prefix: '₱ ',
                              ),
                              const SizedBox(height: 16),
                              _textField(
                                label: 'Student / Member Name',
                                hint: 'Enter student or member name',
                              ),
                              const SizedBox(height: 16),
                              _textField(
                                label: 'Student / Member ID',
                                hint: 'Enter student or member ID',
                              ),
                              const SizedBox(height: 16),
                              _dropdown(
                                label: 'Payment Type',
                                hint: 'Select Payment Type',
                                items: const [
                                  '<Membership Fee>',
                                  '<Registration Fee>',
                                  '<Other Payment>',
                                ],
                              ),
                              const SizedBox(height: 16),
                              _dropdown(
                                label: 'Payment Method',
                                hint: 'Select Payment Method',
                                items: const [
                                  '<Cash>',
                                  '<GCash>',
                                  '<Bank Transfer>',
                                  '<Other>',
                                ],
                              ),
                              const SizedBox(height: 16),
                              _textField(
                                label: 'Date of Payment',
                                hint: 'Select date',
                                suffixIcon: Icons.calendar_today_outlined,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ==========================
                        // BALANCE PREVIEW
                        // ==========================
                        _sectionTitle('Balance Preview'),
                        const SizedBox(height: 10),

                        _card(
                          Column(
                            children: [
                              _balanceRow('Remaining Funds', '₱ <Balance>'),
                              const SizedBox(height: 12),
                              _balanceRow('Payment Amount', '+ ₱ <Payment>'),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: Divider(
                                  color: mediumBlue,
                                  thickness: 1.5,
                                ),
                              ),
                              _balanceRow(
                                'New Remaining Funds',
                                '₱ <Balance>',
                                bold: true,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ==========================
                        // ADDITIONAL INFORMATION
                        // ==========================
                        _sectionTitle('Additional Information'),
                        const SizedBox(height: 10),

                        _card(
                          _textField(
                            label: 'Notes',
                            hint: 'Additional information about this payment',
                            maxLines: 4,
                          ),
                        ),

                        const SizedBox(height: 30),

                        // ==========================
                        // SUBMIT BUTTON
                        // ==========================
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
                              // TODO: Add payment to balance
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
                              'Add Balance',
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
    required List<String> items,
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
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(
                item,
                style: const TextStyle(
                  fontFamily: 'Space',
                  color: darkBlue,
                ),
              ),
            );
          }).toList(),
          onChanged: (value) {},
        ),
      ],
    );
  }

  static Widget _balanceRow(
      String label,
      String value, {
        bool bold = false,
      }) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Space',
            fontSize: 13,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
            color: darkBlue,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontFamily: bold ? 'Pixelify' : 'Space',
            fontSize: bold ? 15 : 13,
            fontWeight: bold ? FontWeight.bold : FontWeight.w600,
            color: darkBlue,
          ),
        ),
      ],
    );
  }
}