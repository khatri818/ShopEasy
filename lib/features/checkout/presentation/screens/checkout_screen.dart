import 'package:flutter/material.dart';
import 'package:shopeasy/features/payment/presentation/screens/payment_screen.dart';

class CheckoutPage extends StatefulWidget {
  final double totalAmount;

  const CheckoutPage({Key? key, required this.totalAmount}) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  bool _isDeliverySelected = false;
  String _selectedPaymentMethod = '';

  void _toggleDeliverySelected() {
    setState(() {
      _isDeliverySelected = !_isDeliverySelected;
    });
  }

  void _togglePaymentSelected(String paymentMethod) {
    setState(() {
      _selectedPaymentMethod = paymentMethod;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16), // Add this line for space
            Text(
              'Total Amount: \$${widget.totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16), // Add this line for space
            const Text(
              'DELIVERY ADDRESS',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 32),
            GestureDetector(
              onTap: _toggleDeliverySelected,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: _isDeliverySelected ? Colors.blue : Colors.grey,
                    width: 2.0,
                  ),
                  color: _isDeliverySelected ? Colors.blue : Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '456 Elm Street, Springfield, USA',
                      style: TextStyle(
                        fontSize: 16,
                        color: _isDeliverySelected ? Colors.white : Colors.black,
                      ),
                    ),
                    if (_isDeliverySelected)
                      const Icon(
                        Icons.check_circle,
                        color: Colors.white,
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'PAYMENT METHODS',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16.0),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: Colors.grey,
                  width: 2.0,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PaymentMethodTile(
                    icon: Icons.payment,
                    title: 'RazorPay',
                    isSelected: _selectedPaymentMethod == 'PayPal',
                    onTap: () => _togglePaymentSelected('PayPal'),
                  ),
                  PaymentMethodTile(
                    icon: Icons.account_balance_wallet,
                    title: 'Wallet/UPI',
                    isSelected: _selectedPaymentMethod == 'Wallet/UPI',
                    onTap: () => _togglePaymentSelected('Wallet/UPI'),
                  ),
                  PaymentMethodTile(
                    icon: Icons.account_balance,
                    title: 'Net Banking',
                    isSelected: _selectedPaymentMethod == 'Net Banking',
                    onTap: () => _togglePaymentSelected('Net Banking'),
                  ),
                  PaymentMethodTile(
                    icon: Icons.credit_card,
                    title: 'Credit/Debit Card',
                    isSelected: _selectedPaymentMethod == 'Credit/Debit Card',
                    onTap: () => _togglePaymentSelected('Credit/Debit Card'),
                  ),
                ],
              ),
            ),
            const Spacer(),

            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: \$${widget.totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentPage(totalAmount: widget.totalAmount),
                      ),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  child: const Text(
                    'Proceed to Payment',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}

class PaymentMethodTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentMethodTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, size: 40, color: isSelected ? Colors.white : Colors.blue),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
          if (isSelected)
            const Icon(
              Icons.check_circle,
              color: Colors.white,
            ),
        ],
      ),
      tileColor: isSelected ? Colors.blue : Colors.transparent,
    );
  }
}
