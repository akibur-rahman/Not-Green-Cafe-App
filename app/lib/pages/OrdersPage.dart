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
          // Filter out orders with status 'Delivered'
          orders = responseData
              .where((order) => order['status'] != 'Delivered')
              .map((order) {
            return Order(
              orderId: order['order_id'],
              customerName: order['customer_name'],
              itemName: order['item_name'],
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

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    final apiUrl = 'http://10.0.2.2:5000/update_order_status';

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'order_id': orderId, 'new_status': newStatus}),
      );

      if (response.statusCode == 200) {
        // Order status updated successfully, refresh orders
        fetchOrders();
      } else {
        // Handle API error
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      // Handle network or decoding errors
      print('Error: $e');
    }
  }

  String getStatusButtonText(String status) {
    switch (status) {
      case 'Processing':
        return 'Confirm Order';
      case 'Confirmed':
        return 'Deliver Order';
      default:
        return 'Unknown Action';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        centerTitle: true,
        backgroundColor: Colors.green[300],
        actions: [
          IconButton(
            onPressed: () {
              fetchOrders();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
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
                    Text('Customer Name: ${orders[index].customerName}'),
                    Text('Item Name: ${orders[index].itemName}'),
                    Text('Quantity: ${orders[index].quantity}'),
                    Text(
                        'Total Price: ${orders[index].totalPrice.toStringAsFixed(2)}'),
                    Text('Status: ${orders[index].status}'),
                    ElevatedButton(
                      onPressed: () {
                        // Update order status based on the current status
                        String newStatus =
                            (orders[index].status == 'Processing')
                                ? 'Confirmed'
                                : 'Delivered';
                        updateOrderStatus(orders[index].orderId, newStatus);
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            // Set button color based on the order status
                            if (orders[index].status == 'Processing') {
                              return Colors.red; // Set to red for Processing
                            } else if (orders[index].status == 'Confirmed') {
                              return Colors.green; // Set to green for Confirmed
                            } else {
                              return Colors
                                  .blue; // Set a default color for other statuses
                            }
                          },
                        ),
                        //set textcolor based on the button color
                        foregroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            // Set button color based on the order status
                            if (orders[index].status == 'Processing') {
                              return Colors
                                  .white; // Set to white for Processing
                            } else if (orders[index].status == 'Confirmed') {
                              return Colors.white; // Set to white for Confirmed
                            } else {
                              return Colors
                                  .white; // Set a default color for other statuses
                            }
                          },
                        ),
                      ),
                      child: Text(getStatusButtonText(orders[index].status)),
                    ),
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
