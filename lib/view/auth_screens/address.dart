import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:primewayskills_app/view/auth_screens/kyc.dart';

class EditAddressPage extends StatefulWidget {
  // final String name;
  final String phoneNumber;
  const EditAddressPage({super.key, required this.phoneNumber});

  @override
  State<EditAddressPage> createState() => _EditAddressPageState();
}

class _EditAddressPageState extends State<EditAddressPage> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController houseNoController = TextEditingController();
  TextEditingController villageController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController landMarkController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();

  Future<void> updateAddress() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.phoneNumber)
        .update({
      'address':
          "${houseNoController.text}, ${villageController.text}, ${areaController.text}, ${landMarkController.text}, ${pincodeController.text}, ${cityController.text}, ${stateController.text}",
      'name': fullNameController.text,
      'phone_number': phoneNumberController.text
    });
  }

  @override
  void initState() {
    setState(() {
      // fullNameController.text = widget.name;
      phoneNumberController.text = widget.phoneNumber;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Address",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              const Text(
                "Your full address for offline",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Text(
                "communication",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: const [
                  Text(
                    "Label",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "(optional)",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 1,
                    )
                  ],
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'for ex: home',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Full Name",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 1,
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: fullNameController,
                    decoration: const InputDecoration(
                      labelText: 'enter full name',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Mobile Number",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 1,
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: phoneNumberController,
                    decoration: const InputDecoration(
                      labelText: 'ex:85XXXXXX61',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Adress line 1",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 1,
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: houseNoController,
                    decoration: const InputDecoration(
                      labelText: 'house no, flat no, building no',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Address line 2",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 1,
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: areaController,
                    decoration: const InputDecoration(
                      labelText: 'area, city, village, sector',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: const [
                  Text(
                    "Landmark",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "(optional)",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 1,
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: landMarkController,
                    decoration: const InputDecoration(
                      labelText: 'near by area',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Pincode",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 1,
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: pincodeController,
                    decoration: const InputDecoration(
                      labelText: 'postal pin code',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "city",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 1,
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: cityController,
                    decoration: const InputDecoration(
                      labelText: 'enter city',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "State",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 1,
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: stateController,
                    decoration: const InputDecoration(
                      labelText: 'enter State',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              MaterialButton(
                elevation: 0,
                color: Colors.blue,
                hoverColor: Colors.white,
                padding: const EdgeInsets.all(10),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    updateAddress();
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EkycPage(
                        phoneNumber: widget.phoneNumber,
                      ),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "skip for now",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
