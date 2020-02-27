class Product {
  int product_id;
  String product_name;
  double cost_price;
  double selling_price;
  String description;
  double stock;
  String category;
  int status;

  Product({product_id, product_name, cost_price, selling_price, description, stock, category, status}) {
    this.product_id = product_id;
    this.product_name = product_name;
    this.cost_price = cost_price.toDouble();
    this.selling_price = selling_price.toDouble();
    this.description = description;
    this.stock = stock.toDouble();
    this.category = category;
    this.status = status;
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      product_id: json['product_id'],
      product_name : json['product_name'],
      cost_price: json['cost_price'],
      selling_price: json['selling_price'],
      description: json['description'],
      stock: json['stock'],
      category: json['category'],
      status: json['status']
    );
  }
}