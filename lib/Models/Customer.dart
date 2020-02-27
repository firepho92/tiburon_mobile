class Customer {
  var customer_id;
  var owner;
  var customer_name;
  var phone;
  var street;
  var number;
  var postal_code;
  var district;
  var county;
  var state;
  var email;
  var RFC;
  var business_name;
  var latitude;
  var longitude;
  var type;
  var notes;
  var created;
  var updated;
  var qr;
  var status;


  Customer({customer_id, owner, customer_name, phone, street, number, postal_code, district, county, state, email, RFC, business_name, latitude, longitude, type, notes, created, updated, qr, status}) {
    this.customer_id = customer_id;
    this.owner = owner;
    this.customer_name = customer_name;
    this.phone = phone;
    this.street = street;
    this.number = number;
    this.postal_code = postal_code;
    this.district = district;
    this.county = county;
    this.state = state;
    this.email = email;
    this.RFC = RFC;
    this.business_name = business_name;
    this.latitude = latitude;
    this.longitude = longitude;
    this.type = type;
    this.notes = notes;
    this.created = created;
    this.updated = updated;
    this.qr = qr;
    this.status = status;
  }

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      customer_id: json['customer_id'],
      owner: json['owner'],
      customer_name: json['customer_name'],
      phone: json['phone'],
      street: json['street'],
      number: json['number'],
      postal_code: json['postal_code'],
      district: json['district'],
      county: json['county'],
      state: json['state'],
      email: json['email'],
      RFC: json['RFC'],
      business_name: json['business_name'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      type: json['type'],
      notes: json['notes'],
      created: json['created'],
      updated: json['updated'],
      qr: json['qr'],
      status: json['status'],
    );
  }

  Customer.fromCustomer(Customer customer) {
    this.customer_id = customer.customer_id;
    this.owner = customer.owner;
    this.customer_name = customer.customer_name;
    this.phone = customer.phone;
    this.street = customer.street;
    this.number = customer.number;
    this.postal_code = customer.postal_code;
    this.district = customer.district;
    this.county = customer.county;
    this.state = customer.state;
    this.email = customer.email;
    this.RFC = customer.RFC;
    this.business_name = customer.business_name;
    this.latitude = customer.latitude;
    this.longitude = customer.longitude;
    this.type = customer.type;
    this.notes = customer.notes;
    this.created = customer.created;
    this.updated = customer.updated;
    this.qr = customer.qr;
    this.status = customer.status;
  }
}