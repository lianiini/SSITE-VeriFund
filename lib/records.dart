
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dashboard.dart';
import 'showrecords.dart';

class TransactionRecordsScreen extends StatefulWidget {
  const TransactionRecordsScreen({super.key});

  @override
  State<TransactionRecordsScreen> createState() =>
      _TransactionRecordsScreenState();
}

class _TransactionRecordsScreenState extends State<TransactionRecordsScreen> {

  String _selectedFilter = 'All';

  String _searchQuery = '';

  // keeps the search text field stable while the screen rebuilds
  final TextEditingController _searchController = TextEditingController();

  // stores the supabase stream so it is not recreated on every rebuild
  late final Stream<List<Map<String, dynamic>>> _transactionStream;

  @override
  void initState() {
    super.initState();

    // initializes the transaction stream only once
    _transactionStream = Supabase.instance.client
        .from('transactions')
        .stream(primaryKey: ['id'])
        .order('id', ascending: false);
  }

  @override
  void dispose() {
    // releases the search controller when the screen is closed
    _searchController.dispose();
    super.dispose();
  }

  String _getDateHeader(String dateStr) {
    final date = DateTime.tryParse(dateStr);
    if (date == null) return dateStr;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final yesterday = today.subtract(const Duration(days: 1));

    final txDate = DateTime(date.year, date.month, date.day);

    if (txDate == today) {
      return 'Today';
    } else if (txDate == yesterday) {
      return 'Yesterday';
    } else {
      const months = [
        '',
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December'
      ];

      return '${months[date.month]} ${date.day}';
    }
  }

  IconData _getCategoryIcon(String category) {
    IconData catIcon = Icons.receipt_long;

    if (category == 'Events') catIcon = Icons.receipt_long;
    if (category == 'Supplies') catIcon = Icons.inventory_2_rounded;
    if (category == 'Transportation') catIcon = Icons.directions_bus_rounded;
    if (category == 'Food') catIcon = Icons.fastfood_rounded;
    if (category == 'Membership Fee') catIcon = Icons.payments_rounded;
    if (category == 'Donation') catIcon = Icons.handshake_rounded;
    if (category == 'Event Profit') catIcon = Icons.attach_money_rounded;
    if (category == 'Others') catIcon = Icons.more_horiz_rounded;

    return catIcon;
  }

  // checks whether any transaction information matches the search query
  bool _matchesSearch(dynamic tx) {

    final search = _searchQuery.trim().toLowerCase();

    if (search.isEmpty) return true;

    // retrieves the transaction information and converts it into lowercase
    final title = (tx['title'] ?? '').toString().toLowerCase();
    final category = (tx['category'] ?? '').toString().toLowerCase();
    final type = (tx['type'] ?? '').toString().toLowerCase();

    final amount = (tx['amount'] ?? '').toString().toLowerCase();
    final transactionDate =
    (tx['transaction_date'] ?? '').toString().toLowerCase();
    final creationDate = (tx['created_at'] ?? '').toString().toLowerCase();

    final receiptNumber =
    (tx['receipt_number'] ?? '').toString().toLowerCase();
    final transactionId = (tx['id'] ?? '').toString().toLowerCase();

    // creates a readable transaction type for searching
    final displayType = type == 'balance' ? 'income' : type;

    // converts the amount into a formatted value for easier searching
    final parsedAmount = double.tryParse(amount);
    final formattedAmount = parsedAmount != null
        ? parsedAmount.toStringAsFixed(2)
        : amount;

    // retrieves the formatted date heading for searching
    final dateHeader = _getDateHeader(
      (tx['transaction_date'] ?? '').toString(),
    ).toLowerCase();

    // checks whether at least one transaction field matches the search input
    return title.contains(search) ||
        category.contains(search) ||
        type.contains(search) ||
        displayType.contains(search) ||
        amount.contains(search) ||
        formattedAmount.contains(search) ||
        transactionDate.contains(search) ||
        creationDate.contains(search) ||
        dateHeader.contains(search) ||
        receiptNumber.contains(search) ||
        transactionId.contains(search);
  }

  // updates the search query without recreating the supabase stream
  void _updateSearch(String value) {
    setState(() {
      _searchQuery = value;
    });
  }

  // clears the search field and resets the displayed transactions
  void _clearSearch() {
    _searchController.clear();

    setState(() {
      _searchQuery = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: beige,

      body: Stack(
        children: [

          // decorative circles matching the dashboard background
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

          SafeArea(
            child: Column(
              children: [

                // displays the back button and screen title
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

                // retrieves and displays transaction records from supabase
                Expanded(
                  child: StreamBuilder<List<Map<String, dynamic>>>(
                    stream: _transactionStream,

                    builder: (context, snapshot) {

                      // displays a loading indicator while retrieving records
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(color: darkBlue),
                        );
                      }

                      // displays an error message if the database request fails
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Error loading records',
                            style: TextStyle(
                              fontFamily: 'Space',
                              color: red,
                            ),
                          ),
                        );
                      }

                      final rawTransactions = snapshot.data ?? [];

                      // filters records based on deletion status, search, and selected tab
                      final filteredTransactions = rawTransactions.where((tx) {

                        // hides records that have been soft-deleted
                        if (tx['deleted_at'] != null) return false;

                        // checks whether the transaction information matches the search input
                        final matchesSearch = _matchesSearch(tx);

                        final type = tx['type'] ?? 'expense';

                        // displays only income transactions when the income filter is selected
                        if (_selectedFilter == 'Income') {
                          return matchesSearch && type == 'balance';
                        }

                        // displays only expense transactions when the expenses filter is selected
                        else if (_selectedFilter == 'Expenses') {
                          return matchesSearch && type == 'expense';
                        }

                        // displays all matching transactions
                        return matchesSearch;

                      }).toList();

                      // groups the filtered transactions according to their dates
                      final Map<String, List> groupedTransactions = {};

                      for (var tx in filteredTransactions) {

                        final dateStr = tx['transaction_date'] ?? '';

                        final header = _getDateHeader(dateStr);

                        groupedTransactions.putIfAbsent(
                          header,
                              () => [],
                        ).add(tx);
                      }

                      return SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [

                            // search bar for finding transactions using their information
                            Container(
                              height: 48,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                              ),

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

                                  const Icon(
                                    Icons.search_rounded,
                                    color: darkBlue,
                                    size: 22,
                                  ),

                                  const SizedBox(width: 10),

                                  Expanded(
                                    child: TextField(
                                      // keeps the same controller during rebuilds
                                      controller: _searchController,

                                      // updates the search query whenever the user types
                                      onChanged: _updateSearch,

                                      style: const TextStyle(
                                        fontFamily: 'Space',
                                        fontSize: 12,
                                        color: darkBlue,
                                      ),

                                      decoration: InputDecoration(
                                        hintText: 'Search transactions...',

                                        hintStyle: TextStyle(
                                          fontFamily: 'Space',
                                          fontSize: 12,
                                          color: darkBlue.withValues(
                                            alpha: 0.5,
                                          ),
                                        ),

                                        border: InputBorder.none,
                                        isDense: true,
                                      ),
                                    ),
                                  ),

                                  // displays a clear button when the search bar contains text
                                  if (_searchQuery.isNotEmpty)
                                    GestureDetector(
                                      onTap: _clearSearch,

                                      child: const Icon(
                                        Icons.close_rounded,
                                        color: darkBlue,
                                        size: 20,
                                      ),
                                    ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 24),

                            // filter buttons for displaying all, income, or expenses
                            Row(
                              children: [

                                _buildFilterButton(
                                  'All',
                                  _selectedFilter == 'All',
                                ),

                                const SizedBox(width: 8),

                                _buildFilterButton(
                                  'Income',
                                  _selectedFilter == 'Income',
                                ),

                                const SizedBox(width: 8),

                                _buildFilterButton(
                                  'Expenses',
                                  _selectedFilter == 'Expenses',
                                ),
                              ],
                            ),

                            const SizedBox(height: 28),

                            // displays a message if no transactions match the filters
                            filteredTransactions.isEmpty
                                ? Padding(
                              padding: const EdgeInsets.only(top: 40),

                              child: Center(
                                child: Text(
                                  'No transactions found.',
                                  style: TextStyle(
                                    fontFamily: 'Space',
                                    fontSize: 14,
                                    color: darkBlue.withValues(
                                      alpha: 0.6,
                                    ),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            )

                                : Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,

                              children: groupedTransactions.entries.map(
                                    (entry) {

                                  // retrieves the date heading and its transactions
                                  final header = entry.key;
                                  final txs = entry.value;

                                  return Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,

                                    children: [

                                      // displays the date heading above its transactions
                                      _buildDateHeaderWidget(header),

                                      const SizedBox(height: 10),

                                      // creates a transaction row for each record in the group
                                      ...txs.map((tx) {

                                        // retrieves the transaction information
                                        final int txId = tx['id'] ?? 0;

                                        final isExpense =
                                            tx['type'] == 'expense';

                                        final title =
                                            tx['title'] ?? 'Untitled';

                                        final category =
                                            tx['category'] ?? 'General';

                                        final date =
                                            tx['transaction_date'] ?? '';

                                        // converts the transaction amount into a double
                                        final amount = double.tryParse(
                                          tx['amount'].toString(),
                                        ) ?? 0.0;

                                        // passes the transaction details to the transaction row widget
                                        return _buildTransaction(
                                          id: txId,
                                          icon: _getCategoryIcon(
                                            category,
                                          ),
                                          iconColor:
                                          isExpense ? red : darkBlue,
                                          title: title,
                                          category: category,
                                          date: date,

                                          amount:
                                          '${isExpense ? '- ' : '+ '}₱${amount.toStringAsFixed(2)}',

                                          isExpense: isExpense,
                                        );
                                      }),

                                      const SizedBox(height: 24),
                                    ],
                                  );
                                },
                              ).toList(),
                            ),
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

      // highlights the records tab in the bottom navigation bar
      bottomNavigationBar: const BottomNavBar(
        selectedIndex: 1,
      ),
    );
  }

  // displays the date heading above a group of transactions
  Widget _buildDateHeaderWidget(String date) {
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

  // creates a filter button and highlights it when selected
  Widget _buildFilterButton(String text, bool selected) {
    return GestureDetector(

      // updates the selected filter when the button is tapped
      onTap: () => setState(() => _selectedFilter = text),

      child: Container(
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
      ),
    );
  }

  // creates an individual transaction row
  Widget _buildTransaction({
    required int id,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String category,
    required String date,
    required String amount,
    required bool isExpense,
  }) {

    return GestureDetector(

      // opens the transaction detail screen when a record is tapped
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                TransactionDetailScreen(transactionId: id),
          ),
        );
      },

      child: Container(
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

            // displays the icon assigned to the transaction category
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
                color: darkBlue,
                size: 22,
              ),
            ),

            const SizedBox(width: 12),

            // displays the transaction title, category, and date
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
                    DateTime.tryParse(date) != null
                        ? '${DateTime.parse(date).month}/${DateTime.parse(date).day}/${DateTime.parse(date).year}'
                        : date,
                    style: TextStyle(
                      fontFamily: 'Space',
                      fontSize: 9,
                      color: darkBlue.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // displays the transaction amount with its corresponding color
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
      ),
    );
  }
}
