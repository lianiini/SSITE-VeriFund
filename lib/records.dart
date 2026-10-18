import 'package:flutter/material.dart';
import 'dashboard.dart';

class TransactionRecordsScreen extends StatelessWidget {
  const TransactionRecordsScreen({super.key});

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

          // Main screen content wrapped in SafeArea
          SafeArea(
            child: Column(
              children: [
                // ==========================
                // TOP BAR / APP BAR
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
                            Icons.arrow_back_rounded,
                            color: darkBlue,
                            size: 22,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Text(
                        'TRANSACTION RECORDS',
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

                // ==========================
                // RECORDS CONTENT
                // ==========================
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Search bar
                        Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.black,
                              width: 2.5,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black,
                                offset: Offset(4, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 14),
                              const Icon(
                                Icons.search_rounded,
                                color: darkBlue,
                                size: 22,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Search transactions...',
                                style: TextStyle(
                                  fontFamily: 'Space',
                                  fontSize: 12,
                                  color: darkBlue.withOpacity(0.5),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Filter buttons
                        Row(
                          children: [
                            _buildFilterButton('All', true),
                            const SizedBox(width: 8),
                            _buildFilterButton('Income', false),
                            const SizedBox(width: 8),
                            _buildFilterButton('Expenses', false),
                          ],
                        ),

                        const SizedBox(height: 28),

                        // Date group - Today
                        _buildDateHeader('Today'),
                        const SizedBox(height: 10),

                        _buildTransaction(
                          icon: Icons.shopping_bag_rounded,
                          iconColor: red,
                          title: 'IT Days Supplies',
                          category: 'Event Expenses',
                          date: 'Today, 2:35 PM',
                          amount: '- ₱2,500.00',
                          isExpense: true,
                        ),

                        _buildTransaction(
                          icon: Icons.account_balance_wallet_rounded,
                          iconColor: darkBlue,
                          title: 'Membership Collection',
                          category: 'Membership Fees',
                          date: 'Today, 10:15 AM',
                          amount: '+ ₱5,000.00',
                          isExpense: false,
                        ),

                        const SizedBox(height: 24),

                        // Date group - Yesterday
                        _buildDateHeader('Yesterday'),
                        const SizedBox(height: 10),

                        _buildTransaction(
                          icon: Icons.local_drink_rounded,
                          iconColor: red,
                          title: 'Free Ice Cream Activity',
                          category: 'Student Activities',
                          date: 'Yesterday, 1:20 PM',
                          amount: '- ₱1,200.00',
                          isExpense: true,
                        ),

                        _buildTransaction(
                          icon: Icons.print_rounded,
                          iconColor: red,
                          title: 'Printing Services',
                          category: 'Office Supplies',
                          date: 'Yesterday, 9:42 AM',
                          amount: '- ₱450.00',
                          isExpense: true,
                        ),

                        const SizedBox(height: 24),

                        // Date group - Earlier
                        _buildDateHeader('September 18'),
                        const SizedBox(height: 10),

                        _buildTransaction(
                          icon: Icons.monetization_on_rounded,
                          iconColor: darkBlue,
                          title: 'Organization Fund',
                          category: 'Fund Allocation',
                          date: 'September 18, 3:10 PM',
                          amount: '+ ₱10,000.00',
                          isExpense: false,
                        ),

                        _buildTransaction(
                          icon: Icons.inventory_2_rounded,
                          iconColor: red,
                          title: 'Event Materials',
                          category: 'Event Expenses',
                          date: 'September 18, 11:05 AM',
                          amount: '- ₱3,250.00',
                          isExpense: true,
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
      bottomNavigationBar: const BottomNavBar(
        selectedIndex: 1,
      ),
    );
  }

  // Date heading
  Widget _buildDateHeader(String date) {
    return Text(
      date,
      style: const TextStyle(
        fontFamily: 'Pixelify',
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: darkBlue,
      ),
    );
  }

  // Filter button
  Widget _buildFilterButton(String text, bool selected) {
    return Container(
      decoration: BoxDecoration(
        color: selected ? darkBlue : lightBlue,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.black,
          width: 2.0,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            offset: Offset(3, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Space',
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: selected ? Colors.white : darkBlue,
        ),
      ),
    );
  }

  // Transaction row
  Widget _buildTransaction({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String category,
    required String date,
    required String amount,
    required bool isExpense,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 13,
      ),
      decoration: BoxDecoration(
        color: lightBlue,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.black,
          width: 2.5,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            offset: Offset(4, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Transaction icon container
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.black,
                width: 2.0,
              ),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 22,
            ),
          ),

          const SizedBox(width: 12),

          // Transaction details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Space',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: darkBlue,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  category,
                  style: TextStyle(
                    fontFamily: 'Space',
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: mediumBlue,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  date,
                  style: TextStyle(
                    fontFamily: 'Space',
                    fontSize: 9,
                    color: darkBlue.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Amount text
          Text(
            amount,
            style: TextStyle(
              fontFamily: 'Space',
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isExpense ? red : darkBlue,
            ),
          ),
        ],
      ),
    );
  }
}