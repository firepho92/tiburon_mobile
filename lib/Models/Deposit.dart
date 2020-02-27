class Deposit {
  int deposit_id;
  String deposit_date;
  int payment_type;
  int sale_type;
  int customer;
  var ammount;

  Deposit({
    this.deposit_id,
    this.deposit_date,
    this.payment_type,
    this.sale_type,
    this.customer,
    this.ammount,
  });

  factory Deposit.fromJson(Map<String, dynamic> json) {
    return Deposit(
      deposit_id: json['deposit_id'],
      deposit_date: json['deposit_date'],
      payment_type: json['payment_type'],
      sale_type: json['sale_type'],
      customer: json['customer'],
      ammount: json['ammount'],
    );
  }

  Map<String, dynamic> getAsMap() {
    return {
      'deposit_date': this.deposit_date,
      'payment_type': this.payment_type,
      'sale_type': this.sale_type,
      'customer': this.customer,
      'ammount': this.ammount
    };
  }
}