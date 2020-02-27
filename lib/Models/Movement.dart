class Movement {
  int sale_id;
  String sale_date;
  int customer;
  int person;
  int product;
  var ammount;
  var selling_price;
  var cost_price;
  int IVA;
  int cash;
  int movementType;
  int sale_type;
  String description;

  Movement({
    this.sale_id,
    this.sale_date,
    this.customer,
    this.person,
    this.product,
    this.ammount,
    this.selling_price,
    this.cost_price,
    this.IVA,
    this.cash,
    this.movementType,
    this.sale_type,
    this.description
  });

  factory Movement.fromJson(Map<String, dynamic> json) {
    return Movement(
      sale_id: json['sale_id'],
      sale_date: json['sale_date'],
      customer: json['customer'],
      person: json['person'],
      product: json['product'],
      ammount: json['ammount'],
      selling_price: json['selling_price'],
      cost_price: json['cost_price'],
      IVA: json['IVA'],
      cash: json['cash'],
      movementType: json['movementType'],
      sale_type: json['sale_type'],
      description: json['description'],
    );
  }
}