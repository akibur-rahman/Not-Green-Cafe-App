import 'dart:convert';
import 'package:app/models/Orders.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  List<Order> orders = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    final apiUrl = 'http://10.0.2.2:5000/orders';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);

        setState(() {
          orders = responseData.map((order) {
            return Order(
              orderId: order['order_id'],
              customerId: order['customer_id'],
              itemId: order['item_id'],
              quantity: order['quantity'],
              totalPrice:
                  double.tryParse(order['total_price'].toString()) ?? 0.0,
              status: order['status'],
            );
          }).toList();
        });
      } else {
        // Handle API error
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      // Handle network or decoding errors
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        centerTitle: true,
        backgroundColor: Colors.green[300],
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 3,
              child: ListTile(
                title: Text('Order ID: ${orders[index].orderId}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Customer ID: ${orders[index].customerId}'),
                    Text('Item ID: ${orders[index].itemId}'),
                    Text('Quantity: ${orders[index].quantity}'),
                    Text(
                        'Total Price: ${orders[index].totalPrice.toStringAsFixed(2)}'),
                    Text('Status: ${orders[index].status}'),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
