import 'package:flutter/material.dart';
import 'package:offline_pos/controllers/item_screen_controller.dart';
import 'package:offline_pos/data_source/local/pref_keys.dart';
import 'package:offline_pos/data_source/local/user_preference.dart';
import 'package:offline_pos/database_conn/dbsync.dart' as customerDataList;
import 'package:offline_pos/database_conn/get_customer.dart';
import 'package:offline_pos/database_conn/insert_customer.dart';
import 'package:offline_pos/models/customer_list_model.dart';
import 'package:offline_pos/pages/customer_list.dart';
import 'package:offline_pos/pages/items_cart.dart';
import 'package:offline_pos/widgets_components/log_error_to_file.dart';

class CustomerCreateForm extends StatefulWidget {
  final void Function(Map<String, dynamic> data) onSubmit;
  final TempCustomerData? customer;
  final bool? isEdit;
  const CustomerCreateForm({
    super.key,
    required this.onSubmit,
    this.customer,
    this.isEdit = false,
  });

  @override
  State<CustomerCreateForm> createState() => _CustomerCreateFormState();
}

class _CustomerCreateFormState extends State<CustomerCreateForm> {
  final _formKey = GlobalKey<FormState>();

  // final nameController = TextEditingController();
  final customerNameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final genderController = TextEditingController();
  final nationalIdController = TextEditingController();
  final address1Controller = TextEditingController();
  final address2Controller = TextEditingController();
  final cityController = TextEditingController();
  final countryController = TextEditingController();
  final loyaltyPointsController = TextEditingController();
  final loyaltyPointsAmountController = TextEditingController();

  @override
  void didUpdateWidget(covariant CustomerCreateForm oldWidget) {
    super.didUpdateWidget(oldWidget);
   
    if (widget.customer != oldWidget.customer && widget.customer != null) {
      customerNameController.text = widget.customer!.customerName ?? "";
      emailController.text = widget.customer!.emailId ?? "";
      mobileController.text = widget.customer!.mobileNo ?? "";
      genderController.text = widget.customer!.gender ?? "";
      nationalIdController.text = widget.customer!.nationalId ?? "";
      address1Controller.text = widget.customer!.addressLine1 ?? "";
      address2Controller.text = widget.customer!.addressLine2 ?? "";
      cityController.text = widget.customer!.city ?? "";
      countryController.text = widget.customer!.country ?? "";
      loyaltyPointsController.text =
          widget.customer!.loyaltyPoints?.toString() ?? "";
      loyaltyPointsAmountController.text =
          widget.customer!.loyaltyPointsAmount?.toString() ?? "";
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.customer != null) {
      customerNameController.text = widget.customer!.customerName ?? "";
      emailController.text = widget.customer!.emailId ?? "";
      mobileController.text = widget.customer!.mobileNo ?? "";
      genderController.text = widget.customer!.gender ?? "";
      nationalIdController.text = widget.customer!.nationalId ?? "";
      address1Controller.text = widget.customer!.addressLine1 ?? "";
      address2Controller.text = widget.customer!.addressLine2 ?? "";
      cityController.text = widget.customer!.city ?? "";
      countryController.text = widget.customer!.country ?? "";
      loyaltyPointsController.text =
          widget.customer!.loyaltyPoints?.toString() ?? "";
      loyaltyPointsAmountController.text =
          widget.customer!.loyaltyPointsAmount?.toString() ?? "";
    }
    countryController.text = UserPreference.getString(PrefKeys.country) ?? "";
  }

  @override
  void dispose() {
    // nameController.dispose();
    customerNameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    genderController.dispose();
    nationalIdController.dispose();
    address1Controller.dispose();
    address2Controller.dispose();
    cityController.dispose();
    countryController.dispose();
    loyaltyPointsController.dispose();
    loyaltyPointsAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final CartItemScreenController model = CartItemScreenController(context);
    return Dialog(
      backgroundColor: Colors.white,
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: ListView(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    "Create Customer",
                                    style: TextStyle(
                                      color: Color(0xFF006A35),
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),

                                SizedBox(
                                  width: 120,
                                  height: 40,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF2B3691),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      textStyle: const TextStyle(
                                        fontSize: 14,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    onPressed: () async {
                                      try{
                                        if (widget.isEdit == true) {
                                        await updateCustomerStatus(
                                          TempCustomerData(
                                            name: widget.customer!.name,
                                            customerName:
                                                customerNameController.text,
                                            emailId: emailController.text,
                                            mobileNo: mobileController.text,
                                            gender: genderController.text,
                                            nationalId:
                                                nationalIdController.text,
                                            addressLine1:
                                                address1Controller.text,
                                            addressLine2:
                                                address2Controller.text,
                                            city: cityController.text,
                                            country: countryController.text,
                                          ),

                                          context,
                                        );
                                        Navigator.pop(context);
                                      } else if (widget.isEdit == false) {
                                        if (_formKey.currentState!.validate()) {
                                          final data = {
                                            'customer_name':
                                                customerNameController.text,
                                            'email_id': emailController.text,
                                            'mobile_no': mobileController.text,
                                            'gender': genderController.text,
                                            'national_id':
                                                nationalIdController.text,
                                            'address_line1':
                                                address1Controller.text,
                                            'address_line2':
                                                address2Controller.text,
                                            'city': cityController.text,
                                            'country': countryController.text,
                                            'loyalty_points':
                                                double.tryParse(
                                                  loyaltyPointsController.text,
                                                ) ??
                                                0,
                                            'loyalty_points_amount':
                                                double.tryParse(
                                                  loyaltyPointsAmountController
                                                      .text,
                                                ) ??
                                                0,
                                          };
                                          widget.onSubmit(data);

                                          final lastSequence =
                                              await fetchLastCustomerSequence();
                                          final newSequence =
                                              lastSequence != null
                                                  ? (int.tryParse(
                                                            lastSequence,
                                                          ) ??
                                                          0) +
                                                      1
                                                  : 1;
                                          await insertTableCustomer(
                                            d: [
                                              TempCustomerData(
                                                name:
                                                    "CM - ${UserPreference.getString(PrefKeys.branchID)} - $newSequence",
                                                posxID: "CM - ${UserPreference.getString(PrefKeys.branchID)} - $newSequence",
                                                customerName:
                                                    customerNameController.text,
                                                emailId: emailController.text,
                                                mobileNo: mobileController.text,
                                                gender: genderController.text,
                                                nationalId:
                                                    nationalIdController.text,
                                                addressLine1:
                                                    address1Controller.text,
                                                addressLine2:
                                                    address2Controller.text,
                                                city: cityController.text,
                                                country: countryController.text,
                                                syncStatus: "Created",
                                                loyaltyPoints: 0,
                                                loyaltyPointsAmount: 0,
                                                  defaultPriceList: "",
                                              ),
                                            ],
                                          );
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              settings: const RouteSettings(
                                                name: 'CustomerListPage',
                                              ),
                                              builder:
                                                  (context) =>
                                                      CustomerListPage(),
                                            ),
                                          );
                                        }
                                      }
                                      print("Customer Created/Edited Successfully");
                                      }
                                      catch(e){
                                        print("$e");
                                      }
                                      
                                    },
                                    child: const Text("Save & Close"),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                SizedBox(
                                  width: 160,
                                  height: 40,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF2B3691),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      textStyle: const TextStyle(
                                        fontSize: 14,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    onPressed: () async {
                                      try {
                                        if (widget.isEdit == true) {
                                          model.customerListController.text =
                                              customerNameController.text;
                                          await updateCustomerStatus(
                                            TempCustomerData(
                                              name: widget.customer!.name,
                                              customerName:
                                                  customerNameController.text,
                                              emailId: emailController.text,
                                              mobileNo: mobileController.text,
                                              gender: genderController.text,
                                              nationalId:
                                                  nationalIdController.text,
                                              addressLine1:
                                                  address1Controller.text,
                                              addressLine2:
                                                  address2Controller.text,
                                              city: cityController.text,
                                              country: countryController.text,
                                            ),
                                            context,
                                          );
                                          model.notifyListeners();
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              settings: const RouteSettings(
                                                name: 'CartItemScreen',
                                              ),
                                              builder:
                                                  (context) => CartItemScreen(
                                                    runInit: false,
                                                    customer:
                                                        customerNameController
                                                            .text,
                                                  ),
                                            ),
                                          );
                                        } else {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            final data = {
                                              'customer_name':
                                                  customerNameController.text,
                                              'email_id': emailController.text,
                                              'mobile_no':
                                                  mobileController.text,
                                              'gender': genderController.text,
                                              'national_id':
                                                  nationalIdController.text,
                                              'address_line1':
                                                  address1Controller.text,
                                              'address_line2':
                                                  address2Controller.text,
                                              'city': cityController.text,
                                              'country': countryController.text,
                                              'loyalty_points':
                                                  double.tryParse(
                                                    loyaltyPointsController
                                                        .text,
                                                  ) ??
                                                  0,
                                              'loyalty_points_amount':
                                                  double.tryParse(
                                                    loyaltyPointsAmountController
                                                        .text,
                                                  ) ??
                                                  0,
                                            };
                                            widget.onSubmit(data);
                                            final lastSequence =
                                                await fetchLastCustomerSequence();
                                            final newSequence =
                                                lastSequence != null
                                                    ? (int.tryParse(
                                                              lastSequence,
                                                            ) ??
                                                            0) +
                                                        1
                                                    : 1;
                                            model.customerListController.text =
                                                customerNameController.text;
                                            await insertTableCustomer(
                                              d: [
                                                TempCustomerData(
                                                  name:
                                                      "CM - ${UserPreference.getString(PrefKeys.branchID)} - $newSequence",
                                                       posxID: "CM - ${UserPreference.getString(PrefKeys.branchID)} - $newSequence",
                                                  customerName:
                                                      customerNameController
                                                          .text,
                                                  emailId: emailController.text,
                                                  mobileNo:
                                                      mobileController.text,
                                                  gender: genderController.text,
                                                  nationalId:
                                                      nationalIdController.text,
                                                  addressLine1:
                                                      address1Controller.text,
                                                  addressLine2:
                                                      address2Controller.text,
                                                  city: cityController.text,
                                                  country:
                                                      countryController.text,
                                                  syncStatus: "Created",
                                                  loyaltyPoints: 0,
                                                  loyaltyPointsAmount: 0,
                                                  defaultPriceList: "",
                                                ),
                                              ],
                                            );

                                            customerDataList.customerDataList =
                                                await fetchFromCustomer();
                                            model.notifyListeners();
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                settings: const RouteSettings(
                                                  name: 'CartItemScreen',
                                                ),
                                                builder:
                                                    (context) => CartItemScreen(
                                                      runInit: false,
                                                      customer:
                                                          customerNameController
                                                              .text,
                                                    ),
                                              ),
                                            );
                                          }
                                        }
                                      } catch (e) {
                                        logErrorToFile("$e");
                                      }
                                    },
                                    child: const Text("Save & Create Invoice"),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                SizedBox(
                                  width: 120,
                                  height: 40,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF036D1A),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 5,
                                      ),
                                      textStyle: const TextStyle(
                                        fontSize: 14,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onPressed: () async {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          settings: const RouteSettings(
                                            name: 'CustomerListPage',
                                          ),
                                          builder:
                                              (context) => CustomerListPage(),
                                        ),
                                      );
                                    },
                                    child: const Text("Cancel"),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 36),
                            // Row 1: Name, Customer Name, Email
                            Row(
                              children: [
                                // Expanded(child: _buildTextField(nameController, "Name")),
                                Expanded(
                                  child: _buildTextField(
                                    customerNameController,
                                    "Customer Name",
                                    validate: true,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildTextField(
                                    mobileController,
                                    "Mobile No",
                                    validate: true,
                                  ),
                                ),

                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildTextField(
                                    emailController,
                                    "Email",
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 26),
                            // Row 2: Gender, National ID, Mobile No
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                    nationalIdController,
                                    "National ID",
                                  ),
                                ),

                                const SizedBox(width: 16),
                                Expanded(child: genderField(genderController)),

                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildTextField(
                                    address1Controller,
                                    "Address Line 1",
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 26),
                            // Row 3: City, Address Line 1, Address Line 2
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                    address2Controller,
                                    "Address Line 2",
                                    validate: false,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildTextField(
                                    cityController,
                                    "City",
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildTextField(
                                    countryController,
                                    "Country",
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 26),
                            // Row 4: Country, Loyalty Points, Loyalty Points Amount
                            // Row(
                            //   children: [

                            //     const SizedBox(width: 16),
                            //     Expanded(child: _buildTextField(loyaltyPointsController, "Loyalty Points", keyboardType: TextInputType.number, readOnly: true)),
                            //     const SizedBox(width: 16),
                            //     Expanded(child: _buildTextField(loyaltyPointsAmountController, "Loyalty Points Amount", keyboardType: TextInputType.number, readOnly: true)),
                            //   ],
                            // ),
                            const SizedBox(height: 24),
                            Row(children: [const SizedBox(width: 16)]),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    bool readOnly = false,
    bool validate = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Color(0xFF006A35)),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF006A35)),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF006A35), width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          fillColor: Colors.white,
          filled: true,
        ),
        validator: (value) {
          if (validate) {
            if (value == null || value.isEmpty) {
              return "Please enter $label";
            }
          }
          return null;
        },
      ),
    );
  }
}

Widget genderField(genderController) {
  return SizedBox(
    height: 60,
    width: 2,
    child: DropdownButtonFormField<String>(
      value: genderController.text.isNotEmpty ? genderController.text : null,
      decoration: InputDecoration(
        labelText: "Gender",
        labelStyle: TextStyle(color: Color(0xFF006A35), fontSize: 12),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF006A35)),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF006A35), width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        fillColor: Colors.white,
        filled: true,
      ),
      items: [
        DropdownMenuItem(value: 'Female', child: Text('Female')),
        DropdownMenuItem(value: 'Male', child: Text('Male')),
        DropdownMenuItem(value: '', child: Text('')),
      ],
      onChanged: (value) {
        genderController.text = value ?? '';
      },
      validator: (value) {
        // Optional: require selection
        // if (value == null || value.isEmpty) return "Please select Gender";
        return null;
      },
    ),
  );
}
