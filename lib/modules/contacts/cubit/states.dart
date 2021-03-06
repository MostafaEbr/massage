
abstract class ContactStates {}

class ContactInitialState extends ContactStates {}

class ContactSuccessState extends ContactStates {}

class ContactErrorState extends ContactStates {
  String error = " Error " ;
  ContactErrorState(this.error);
}
