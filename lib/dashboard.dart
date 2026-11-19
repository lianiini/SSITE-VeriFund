import 'package:flutter/material.dart';
import 'package:ssiteverifund/profiles.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'records.dart';

// color values used throughout the dashboard
const Color red = Color(0xFFC72C3B);
const Color beige = Color.fromARGB(255, 245, 238, 221);
const Color paleBlue = Color.fromARGB(255, 196, 216, 230);
const Color lightBlue = Color.fromARGB(255, 166, 199, 230);
const Color mediumBlue = Color.fromARGB(255, 142, 177, 209);
const Color dimBlue = Color.fromARGB(255, 58, 81, 127);
const Color darkBlue = Color.fromARGB(255, 28, 43, 72);

// formats numbers with commas and 2 decimal places (e.g., 12500.5 -> 12,500.50)
String formatPesoNumber(double amount) {
  final parts = amount.toStringAsFixed(2).split('.');
  final formattedInt = parts[0].replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
  );
  return '$formattedInt.${parts[1]}';
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> { // connects the dashboard to the supabase database
  final _supabase = Supabase.instance.client;

  // stores the calculated dashboard values
  double _remainingFunds = 0.0;
  double _totalFunds = 0.0;

  Map<String, double> _categoryTotals = { // stores the total expenses for each category
    'Event': 0.0,
    'Supplies': 0.0,
    'Transportation': 0.0,
    'Food': 0.0,
    'Others': 0.0,
  };

  List _recentTransactions = []; // stores the latest transactions retrieved from supabase

  bool _isLoading = true; // tracks whether dashboard data is still being loaded

  @override
  void initState() {
    super.initState();
    _loadDashboardData(); // loads dashboard information when the screen opens
  }

  Future<void> _loadDashboardData() async {
    try { // retrieves transactions that have not been deleted
      final txResponse = await _supabase
          .from('transactions')
          .select()
          .filter('deleted_at', 'is', null)
          .order('transaction_date', ascending: false); // arranges them by transaction date, with the newest first

      // converts the database response into a list of maps
      List allTx = List.from(txResponse);

      // variables used to calculate the total funds and expenses
      double totalInflow = 0.0;
      double totalExpenses = 0.0;

      Map<String, double> catTotals = { // initializes the expense totals for each category
        'Events': 0.0,
        'Supplies': 0.0,
        'Transportation': 0.0,
        'Food': 0.0,
        'Others': 0.0,
      };

      for (var tx in allTx) { // checks each transaction retrieved from the database
        final amount = (tx['amount'] as num).toDouble(); // converts the transaction amount into a double
        final category = tx['category'] ?? '';

        if (catTotals.containsKey(category)) { // adds the amount to the corresponding expense category
          catTotals[category] = catTotals[category]! + amount;
          totalExpenses += amount;
        } else { // treats transactions outside the expense categories as income
          totalInflow += amount; // examples include membership fees, profits, and initial funds
        }
      }

      double calculatedRemaining = totalInflow - totalExpenses; // calculates the remaining balance by subtracting expenses from income

      if (mounted) { // updates the dashboard only if the screen is still active
        setState(() {
          _totalFunds = totalInflow;
          _remainingFunds = calculatedRemaining;
          _categoryTotals = catTotals;
          _recentTransactions = allTx;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) { // stops the loading indicator if an error occurs
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [ // decorative circles placed around the dashboard background
          Positioned(
            top: -10,
            left: -30,
            child: Container(
              width: 110,
              height: 110,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: paleBlue),
            ),
          ),
          Positioned(
            top: 200,
            right: -30,
            child: Container(
              width: 96,
              height: 96,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: mediumBlue),
            ),
          ),
          Positioned(
            top: 280,
            right: -10,
            child: Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: paleBlue),
            ),
          ),
          Positioned(
            top: 420,
            left: -20,
            child: Container(
              width: 69,
              height: 69,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: mediumBlue),
            ),
          ),
          Positioned(
            top: 387,
            left: -10,
            child: Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: paleBlue),
            ),
          ),
          Positioned(
            bottom: 125,
            right: 10,
            child: Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: paleBlue),
            ),
          ),

          SafeArea( // displays a loading indicator while retrieving dashboard data
            child: _isLoading
                ? const Center(
                child: CircularProgressIndicator(color: darkBlue))
                : RefreshIndicator( // reloads dashboard information when the user pulls down
              onRefresh: _loadDashboardData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HeaderBar(),
                    const SizedBox(height: 20),

                    RemainingFundsCard( // displays the remaining funds
                        remainingFunds: _remainingFunds),
                    const SizedBox(height: 24),

                    PieChartSection(categoryTotals: _categoryTotals), // displays the expense breakdown using a pie chart
                    const SizedBox(height: 24),

                    IntrinsicHeight( // displays the total accumulated income
                      child: Row(
                        children: [
                          Expanded(
                            flex: 7,
                            child: TotalFundsCard(
                                totalFunds: _totalFunds),
                          ),
                          const SizedBox(width: 15),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    LatestTransactionsSection( // displays the most recent transactions
                        transactions: _recentTransactions),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavBar( // displays the bottom navigation and highlights the home tab
        selectedIndex: 0,
        onRefreshNeeded: _loadDashboardData,
      ),
    );
  }
}

class HeaderBar extends StatelessWidget { // displays the application name and organization logos
  const HeaderBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'VeriFund',
          style: TextStyle(
            fontFamily: 'Press',
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: darkBlue,
          ),
        ),
        Row(
          children: [
            _buildCircleIcon(Image.asset('lib/assets/MCC.png',
                width: 28, height: 28, fit: BoxFit.cover)),
            const SizedBox(width: 5),
            _buildCircleIcon(Image.asset('lib/assets/ICS.png',
                width: 28, height: 28, fit: BoxFit.cover)),
            const SizedBox(width: 5),
            _buildCircleIcon(Image.asset('lib/assets/SSITE.png',
                width: 28, height: 28, fit: BoxFit.cover)),
          ],
        ),
      ],
    );
  }

  Widget _buildCircleIcon(Image image) { // places each organization logo inside a fixed-sized container
    return SizedBox(width: 35, height: 35, child: image);
  }
}

class RemainingFundsCard extends StatelessWidget { // displays the current remaining balance
  final double remainingFunds;
  const RemainingFundsCard({super.key, required this.remainingFunds});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
      decoration: BoxDecoration(
        color: lightBlue,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black, width: 3.0),
        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(6, 7))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Remaining Funds:',
            style: TextStyle(
                fontFamily: 'Space',
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: darkBlue),
          ),
          const SizedBox(height: 8),

          Text( // formats the remaining balance with commas and two decimal places
            '₱ ${formatPesoNumber(remainingFunds)}',
            style: const TextStyle(
                fontFamily: 'Pixelify',
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: darkBlue),
          ),
        ],
      ),
    );
  }
}

class PieChartSection extends StatelessWidget { // displays the expense breakdown through a pie chart and category legend
  final Map<String, double> categoryTotals;
  const PieChartSection({super.key, required this.categoryTotals});

  @override
  Widget build(BuildContext context) {  // retrieves the total amount for each expense category
    final double events = categoryTotals['Events'] ?? 0.0;
    final double supplies = categoryTotals['Supplies'] ?? 0.0;
    final double transpo = categoryTotals['Transportation'] ?? 0.0;
    final double food = categoryTotals['Food'] ?? 0.0;
    final double others = categoryTotals['Others'] ?? 0.0;

    final double totalExpenses = events + supplies + transpo + food + others; // calculates the combined expenses of all categories

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 190,
          height: 190,
          child: Stack(
            alignment: Alignment.center,
            children: [ // creates the black circle behind the pie chart as a shadow
              Container(
                width: 180,
                height: 180,
                margin: const EdgeInsets.only(left: 7, top: 7),
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
              ),

              Container( // creates the black outer boundary of the pie chart
                width: 178,
                height: 178,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                  border: Border.all(color: Colors.black, width: 3),
                ),
              ),

              SizedBox( // displays the pie chart with a separate slice for each category
                width: 150,
                height: 150,
                child: PieChart(
                  PieChartData(
                    startDegreeOffset: -90.0,
                    sectionsSpace: 0.0,
                    centerSpaceRadius: 47,

                    sections: totalExpenses == 0 // displays an empty white circle when there are no expenses
                        ? [
                      PieChartSectionData(
                        color: Colors.white,
                        value: 100,
                        title: '',
                        radius: 38,
                      ),
                    ]
                        : [ // only displays a slice when its category has expenses
                      if (events > 0)
                        PieChartSectionData(
                          color: darkBlue,
                          value: events,
                          title: '',
                          radius: 38,
                        ),
                      if (supplies > 0)
                        PieChartSectionData(
                          color: dimBlue,
                          value: supplies,
                          title: '',
                          radius: 38,
                        ),
                      if (transpo > 0)
                        PieChartSectionData(
                          color: mediumBlue,
                          value: transpo,
                          title: '',
                          radius: 38,
                        ),
                      if (food > 0)
                        PieChartSectionData(
                          color: lightBlue,
                          value: food,
                          title: '',
                          radius: 38,
                        ),
                      if (others > 0)
                        PieChartSectionData(
                          color: paleBlue,
                          value: others,
                          title: '',
                          radius: 38,
                        ),
                    ],
                  ),
                ),
              ),

              Container( // creates the center hole and displays the chart label
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: beige,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 3.0),
                ),
                child: Center(
                  child: Text(
                    totalExpenses == 0 ? 'NO EXP' : 'EXPENSES',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Space',
                      color: darkBlue,
                      fontWeight: FontWeight.w800,
                      fontSize: 9,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 25),

        Expanded( // displays the category names and their corresponding expense totals
          child: Column(
            children: [
              _buildLegendRow(
                  darkBlue, 'Events', '₱ ${formatPesoNumber(events)}'),
              const SizedBox(height: 8),
              _buildLegendRow(
                  dimBlue, 'Supplies', '₱ ${formatPesoNumber(supplies)}'),
              const SizedBox(height: 8),
              _buildLegendRow(
                  mediumBlue, 'Transport', '₱ ${formatPesoNumber(transpo)}'),
              const SizedBox(height: 8),
              _buildLegendRow(
                  lightBlue, 'Food', '₱ ${formatPesoNumber(food)}'),
              const SizedBox(height: 8),
              _buildLegendRow(
                  paleBlue, 'Others', '₱ ${formatPesoNumber(others)}'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLegendRow(Color color, String title, String subtitle) {
    return Row( // creates one legend row containing a color indicator, category, and amount
      children: [
        Container(
          width: 10,
          height: 30,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.black, width: 1.5),
          ),
        ),
        const SizedBox(width: 8),
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
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: darkBlue),
              ),
              const SizedBox(height: 1),
              Text(
                subtitle,
                style: TextStyle(
                    fontFamily: 'Space',
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: darkBlue.withValues(alpha: 0.7)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class TotalFundsCard extends StatelessWidget { // displays the total accumulated funds added to the system
  final double totalFunds;
  const TotalFundsCard({super.key, required this.totalFunds});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: paleBlue,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black, width: 3.0),
        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(6, 7))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total Funds:',
            style: TextStyle(
                fontFamily: 'Space',
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: darkBlue),
          ),
          const SizedBox(height: 8),

          Text( // displays the total income with commas and two decimal places
            '₱ ${formatPesoNumber(totalFunds)}',
            style: const TextStyle(
                fontFamily: 'Pixelify',
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: darkBlue),
          ),
          const SizedBox(height: 4),
          const Text(
            'Total Accumulated Inflows',
            style: TextStyle(
                fontFamily: 'Space',
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: darkBlue),
          ),
        ],
      ),
    );
  }
}

class LatestTransactionsSection extends StatelessWidget { // displays the latest transactions retrieved from the database
  final List transactions;
  const LatestTransactionsSection({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Transactions',
          style: TextStyle(
              fontFamily: 'Pixelify',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: darkBlue),
        ),
        const SizedBox(height: 5),

        transactions.isEmpty // displays a message when no transactions are available
            ? const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text('No transactions recorded yet.',
              style: TextStyle(
                  fontFamily: 'Space', fontSize: 12, color: darkBlue)),
        )
            : SingleChildScrollView( // allows the user to scroll horizontally through transaction cards
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: transactions.asMap().entries.map((entry) {
              final tx = entry.value;

              final title = tx['title']; // retrieves the transaction details
              final category = tx['category'];
              final amount = (tx['amount'] as num).toDouble();
              final type = (tx['type']);

              IconData catIcon = Icons.receipt_long; // assigns an icon based on the transaction category
              if (category == 'Events') catIcon = Icons.receipt_long;
              if (category == 'Supplies') catIcon = Icons.inventory_2_rounded;
              if (category == 'Transportation') catIcon = Icons.directions_bus_rounded;
              if (category == 'Food') catIcon = Icons.fastfood_rounded;
              if (category == 'Membership Fee') catIcon = Icons.payments_rounded;
              if (category == 'Donation') catIcon = Icons.handshake_rounded;
              if (category == 'Event Profit') catIcon = Icons.attach_money_rounded;
              if (category == 'Others') catIcon = Icons.more_horiz_rounded;

              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: _TransactionCard( // passes the transaction details to the individual card
                  line1: title,
                  line2: category,
                  line3: '₱${formatPesoNumber(amount)}',
                  type: type,
                  icon: catIcon,
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),

        Container( // adds a divider below the recent transactions
          height: 4,
          decoration: BoxDecoration(
              color: Colors.grey, borderRadius: BorderRadius.circular(2)),
        ),
      ],
    );
  }
}


class _TransactionCard extends StatelessWidget { // creates an individual card for each transaction
  final String line1;
  final String line2;
  final String line3;
  final String type;
  final IconData icon;

  const _TransactionCard({
    required this.line1,
    required this.line2,
    required this.line3,
    required this.type,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final bool isExpense = type == 'expense'; // checks whether the transaction is an expense or an income

    return Container(
      width: 150,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: lightBlue,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black, width: 3.0),
        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(3, 4))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text( // displays the transaction title
                  line1,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontFamily: 'Space',
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: darkBlue),
                ),

                Text( // displays the transaction category
                  line2,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontFamily: 'Space',
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                      color: darkBlue.withValues(alpha: 0.7)),
                ),
                const SizedBox(height: 4),

                Text( // adds a minus sign for expenses and a plus sign for income
                  '${isExpense ? '-' : '+'} $line3',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Space',
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: isExpense ? red : darkBlue,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),

          Container( // displays the icon assigned to the transaction category
            width: 34,
            height: 37,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.black, width: 1.5),
            ),
            child: Icon(icon, size: 18, color: darkBlue),
          ),
        ],
      ),
    );
  }
}

class BottomNavBar extends StatelessWidget { // creates the bottom navigation bar for moving between app screens
  final int selectedIndex;
  final VoidCallback? onRefreshNeeded;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    this.onRefreshNeeded,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: darkBlue,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(35), topRight: Radius.circular(35)),
          border: Border.all(color: Colors.black, width: 4.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _NavItem( // navigates to the dashboard
              icon: Icons.home_rounded,
              label: 'Home',
              selected: selectedIndex == 0,
              onTap: () {
                if (selectedIndex != 0) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DashboardScreen()),
                  );
                }
              },
            ),

            _NavItem( // opens the transaction records screen
              icon: Icons.receipt_long_rounded,
              label: 'Records',
              selected: selectedIndex == 1,
              onTap: () async {
                if (selectedIndex != 1) {
                  await Navigator.push( // waits until the records screen is closed
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TransactionRecordsScreen()),
                  );

                  if (onRefreshNeeded != null) onRefreshNeeded!(); // refreshes the dashboard after returning from records
                }
              },
            ),

            _NavItem( // opens list of officers approved to edit on the system
              icon: Icons.person_rounded,
              label: 'Officers',
              selected: selectedIndex == 2,
              onTap: () async {
                if (selectedIndex != 2) {
                  await Navigator.push( // waits until the records screen is closed
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfileScreen()),
                  );

                  if (onRefreshNeeded != null) onRefreshNeeded!(); // refreshes the dashboard after returning from records
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget { // creates an individual item inside the bottom navigation bar
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector( // performs the navigation action when the item is tapped
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [ // changes the icon color depending on the selected tab
          Icon(icon,
              color: selected ? lightBlue : Colors.white70, size: 22),
          const SizedBox(height: 2),

          Text( // highlights the label of the currently selected tab
            label,
            style: TextStyle(
              fontFamily: 'Space',
              fontSize: 10,
              color: selected ? lightBlue : Colors.white70,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}