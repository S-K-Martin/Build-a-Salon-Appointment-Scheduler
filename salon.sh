#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ Sample Salon Appointment Scheduler ~~~~~\n"

SERVICE_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")
  
  echo -e "\nPlease select a service from the list:"
  echo "$SERVICES" | while read SERVICE_ID BAR NAME
  do
    echo "$SERVICE_ID) $NAME"
  done

  read SERVICE_ID_SELECTED

  # check to make sure salon service is valid number.
  #if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
  #then
    #SERVICE_MENU "That is not a valid service number."
  #fi

  case $SERVICE_ID_SELECTED in
    1) CUSTOMER_INFO ;;
    2) CUSTOMER_INFO ;;
    3) CUSTOMER_INFO ;;
    4) CUSTOMER_INFO ;;
    *) SERVICE_MENU "I could not find that service."
  esac
}

CUSTOMER_INFO() {
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
  SERVICE_NAME_FORMATTED=$(echo $SERVICE_NAME | sed 's/ |/"/')
  
  echo -e "\nWhat is your phone number?"
  read CUSTOMER_PHONE

  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  
  # if customer does not exist
  if [[ -z $CUSTOMER_NAME ]]

  # get new customer name
  then
    echo -e "\nI don't have a record for that number.  What's your name?"
    read CUSTOMER_NAME

    # add to customers table
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")

  fi

  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")

  CUSTOMER_NAME_FORMATTED=$(echo $CUSTOMER_NAME | sed 's/ |/"/')
  
  # move this so it comes after customer phone number and name
  echo -e "\nWhat time would you like to schedule your $SERVICE_NAME_FORMATTED, $CUSTOMER_NAME_FORMATTED?"
  read SERVICE_TIME
  
  NEW_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

  echo -e "\nI have put you down for a $SERVICE_NAME_FORMATTED at $SERVICE_TIME, $CUSTOMER_NAME_FORMATTED."
  echo -e "\nThank you for booking with Sample Salon.\n"

}

SERVICE_MENU
