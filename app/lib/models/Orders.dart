class Order {
  final String orderId;
  final String customerId;
  final String itemId;
  final int quantity;
  final double totalPrice;
  final String status;

  Order({
    required this.orderId,
    required this.customerId,
    required this.itemId,
    required this.quantity,
    required this.totalPrice,
    required this.status,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['order_id'] ?? '',
      customerId: json['customer_id'] ?? '',
      itemId: json['item_id'] ?? '',
      quantity: json['quantity'] ?? 0,
      totalPrice: json['total_price'] ?? 0.0,
      status: json['status'] ?? '',
    );
  }
}
