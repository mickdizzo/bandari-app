import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class PaymentDetailsScreen extends StatefulWidget {
  const PaymentDetailsScreen({super.key});

  @override
  State<PaymentDetailsScreen> createState() => _PaymentDetailsScreenState();
}

class _PaymentDetailsScreenState extends State<PaymentDetailsScreen> {
  String? _courseType;
  bool _isLoading = true;

  double _totalFees = 2800000.0; // Should come from API in real app
  double _totalPaid = 0.0;
  double _balanceDue = 0.0;
  String _lastPaymentDate = '';
  String _paymentStatus = 'Not Paid';

  List<Map<String, dynamic>> _transactions = [];

  final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'en_US', // safe fallback
    symbol: 'TZS ',
    decimalDigits: 0,
  );

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    _courseType = prefs.getString('course_type') ?? 'long';

    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));

    final List<Map<String, dynamic>> mockTransactions = [
      {
        'date': '2025-12-15',
        'amount': 800000,
        'method': 'Mobile Money (M-Pesa)',
        'reference': 'MPESA-20251215-789456',
        'status': 'Completed',
      },
      {
        'date': '2025-09-10',
        'amount': 1000000,
        'method': 'Bank Transfer (NMB)',
        'reference': 'NMB-TRF-0925-456123',
        'status': 'Completed',
      },
      {
        'date': '2025-01-20',
        'amount': 500000,
        'method': 'Cash at College Accounts',
        'reference': 'CASH-2025-001',
        'status': 'Pending Verification',
      },
    ];

    // Calculate everything from transactions (more realistic)
    double paid = 0.0;
    String latestDate = '';

    for (var tx in mockTransactions) {
      final amount = (tx['amount'] as num).toDouble();
      if (tx['status'] == 'Completed') {
        paid += amount;
        if (tx['date'].compareTo(latestDate) > 0) {
          latestDate = tx['date'];
        }
      }
    }

    setState(() {
      _transactions = mockTransactions;
      _totalPaid = paid;
      _balanceDue = _totalFees - _totalPaid;
      _lastPaymentDate = latestDate;
      _paymentStatus = _balanceDue <= 0
          ? 'Fully Paid'
          : (_balanceDue < _totalFees ? 'Partial' : 'Not Paid');
      _isLoading = false;
    });

    // TODO: Real API version would look like:
    // final response = await http.get(...);
    // final data = jsonDecode(response.body);
    // _totalFees = data['total_fees']?.toDouble() ?? 0.0;
    // _transactions = List<Map<String, dynamic>>.from(data['transactions']);
    // then recalculate paid, balance, latest date...
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'pending':
      case 'pending verification':
        return Colors.orange;
      case 'overdue':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_courseType != 'long') {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Payments"),
          backgroundColor: const Color(0xFF003087),
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: Text(
              "Payment details are currently available only for Long-Course students.\nShort-Course payments are handled differently.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment Details"),
        backgroundColor: const Color(0xFF003087),
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Summary Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Text(
                        "Fee Summary",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF003087),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildSummaryItem("Total Fees", _currencyFormat.format(_totalFees), Colors.blue),
                          _buildSummaryItem("Paid", _currencyFormat.format(_totalPaid), Colors.green),
                          _buildSummaryItem(
                            "Balance",
                            _currencyFormat.format(_balanceDue),
                            _balanceDue > 0 ? Colors.red : Colors.green,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Chip(
                        label: Text(
                          _paymentStatus,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        backgroundColor: _getStatusColor(_paymentStatus),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      ),
                      if (_lastPaymentDate.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Text(
                          "Last Payment: $_lastPaymentDate",
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Transaction History
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "Payment History",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF003087),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              if (_transactions.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Text(
                      "No payment records found.",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _transactions.length,
                  itemBuilder: (context, index) {
                    final tx = _transactions[index];
                    final statusColor = _getStatusColor(tx['status']);

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: statusColor.withOpacity(0.2),
                          child: Icon(
                            tx['status'] == 'Completed' ? Icons.check_circle : Icons.hourglass_bottom,
                            color: statusColor,
                          ),
                        ),
                        title: Text(
                          _currencyFormat.format((tx['amount'] as num).toDouble()),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(tx['date']),
                            Text(tx['method']),
                            Text(
                              "Ref: ${tx['reference']}",
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                        trailing: Chip(
                          label: Text(
                            tx['status'],
                            style: const TextStyle(fontSize: 12, color: Colors.white),
                          ),
                          backgroundColor: statusColor,
                        ),
                      ),
                    );
                  },
                ),

              const SizedBox(height: 32),

              // Action buttons
              if (_balanceDue > 0)
                ElevatedButton.icon(
                  icon: const Icon(Icons.payment),
                  label: const Text("Make a Payment"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Payment options coming soon!")),
                    );
                  },
                ),

              const SizedBox(height: 16),

              OutlinedButton.icon(
                icon: const Icon(Icons.receipt_long),
                label: const Text("Download Receipt / Statement"),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Statement download coming soon!")),
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
        ),
      ],
    );
  }
}