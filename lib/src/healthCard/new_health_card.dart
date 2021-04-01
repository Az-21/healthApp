// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  * Imports
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';

// Pub Dev Imports
import 'package:awesome_card/awesome_card.dart';
import 'package:flutter/services.dart';
import 'package:pattern_formatter/pattern_formatter.dart';
import 'package:getwidget/getwidget.dart';
import 'package:get/get.dart';

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  * Formfield UI
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
class NewHealthCard extends StatelessWidget {
  const NewHealthCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: Text('Create Health Card'),
      ),
      body: HealthCardCreateForm(),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  * Stateful Health Form
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
class HealthCardCreateForm extends StatefulWidget {
  HealthCardCreateForm({Key key}) : super(key: key);

  @override
  _HealthCardCreateFormState createState() => _HealthCardCreateFormState();
}

class _HealthCardCreateFormState extends State<HealthCardCreateForm> {
  String aadharNumber = 'xxxx xxxx xxxx';
  String cardHolderName = '';
  String bloodGroup = '';
  String healthCondition = '';
  String healthInfo = ''; // = '$bloodGroup | $healthCondition'
  String cvv = '';
  bool showBack = false;

  FocusNode _focusNode; // for card animation

  bool isFirebaseSuccess = false; // for firebase integration

  // Controllers to reset text on submit
  TextEditingController formAadhar = TextEditingController();
  TextEditingController formBloodGroup = TextEditingController();
  TextEditingController formHealthCondition = TextEditingController();
  TextEditingController formName = TextEditingController();
  TextEditingController formSecurityKey = TextEditingController();

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _focusNode.hasFocus ? showBack = true : showBack = false;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          CreditCard(
            cardNumber: aadharNumber,
            cardExpiry: healthInfo,
            cardHolderName: cardHolderName,
            cvv: cvv,
            cardType: CardType.other,
            bankName: 'Universal Health Card',
            showBackSide: showBack,
            frontBackground: CardBackgrounds.black,
            backBackground: CardBackgrounds.white,
            showShadow: true,
            textExpDate: 'Holder Info',
            textName: 'Name',
            textExpiry: 'Health Info',
          ),
          SizedBox(
            height: 15,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              /// Security Key / CVV
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextFormField(
                  controller: formSecurityKey,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    counterText: '',
                    labelText: 'Security Key',
                    hintText: 'Set a four digit security key',
                  ),
                  maxLength: 4,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (formSecuurityKey) {
                    setState(() {
                      cvv = formSecuurityKey;
                    });
                  },
                  focusNode: _focusNode,
                ),
              ),

              /// Name
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextFormField(
                  controller: formName,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    counterText: '',
                    hintText: 'First Last',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (formName) {
                    setState(() {
                      cardHolderName = formName;
                    });
                  },
                ),
              ),

              /// Aadhar ID
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextFormField(
                  controller: formAadhar,
                  maxLength: 14, // input formatter will add 12 + 2 = 14
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    counterText: '',
                    labelText: 'Aadhar UID',
                    hintText: '12 Digit AADHAR Card Number',
                  ),
                  inputFormatters: [
                    CreditCardFormatter(),
                  ],
                  onChanged: (formAadhar) {
                    setState(() {
                      aadharNumber = formAadhar;
                    });
                  },
                ),
              ),

              /// Blood Group
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextFormField(
                  controller: formBloodGroup,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    counterText: '',
                    labelText: 'Blood Group',
                    hintText: 'AB+',
                  ),
                  maxLength: 3,
                  onChanged: (formBloodGroup) {
                    setState(() {
                      bloodGroup = formBloodGroup;
                      healthInfo = '$bloodGroup | $healthCondition';
                    });
                  },
                ),
              ),

              /// Health Condition
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextFormField(
                  controller: formHealthCondition,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    counterText: '',
                    labelText: 'Health Condition',
                    hintText: 'Allergic to X',
                  ),
                  maxLength: 20,
                  onChanged: (formHealthCondition) {
                    setState(() {
                      healthCondition = formHealthCondition;
                      healthInfo = '$bloodGroup | $healthCondition';
                    });
                  },
                ),
              ),

              /// Submit Button
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: GFButton(
                  text: "Create New Health Card",
                  size: GFSize.LARGE,
                  elevation: 5,
                  color: Colors.green,
                  splashColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  icon: Icon(
                    Icons.post_add_outlined,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    // TODO: firebase push here
                    isFirebaseSuccess = true;
                    if (isFirebaseSuccess) {
                      Get.snackbar(
                        'Success',
                        'Your health card has been created',
                        icon: Icon(Icons.cloud_done_sharp),
                        backgroundColor: Colors.greenAccent,
                      );
                    } else {
                      Get.snackbar(
                        'Failed',
                        'Failed to create health card. Please check your internet connection.',
                        icon: Icon(Icons.signal_wifi_off_sharp),
                        backgroundColor: Colors.redAccent,
                      );
                    }
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}