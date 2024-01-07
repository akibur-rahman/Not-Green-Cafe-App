import 'package:flutter/material.dart';

class OrdersListTile extends StatelessWidget {
  const OrdersListTile({
    Key? key,
    required this.order,
  }) : super(key: key);

  final Map<String, dynamic> order;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        'Order ID: ${order['orderId']}',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        'Order status: ${order['orderStatus']}',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: Text(
        'Total: \$${order['total']}',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
