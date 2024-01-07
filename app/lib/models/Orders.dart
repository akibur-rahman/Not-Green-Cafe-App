class Order {
  final String orderId;
  final String customerName;
  final String itemName;
  final int quantity;
  final double totalPrice;
  final String status;

  Order({
    required this.orderId,
    required this.customerName,
    required this.itemName,
    required this.quantity,
    required this.totalPrice,
    required this.status,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['order_id'] ?? '',
      customerName: json['customer_name'] ?? '',
      itemName: json['item_name'] ?? '',
      quantity: json['quantity'] ?? 0,
      totalPrice: json['total_price'] ?? 0.0,
      status: json['status'] ?? '',
    );
  }
}
