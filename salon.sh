#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

MAIN_MENU() {
  SERVICES=$($PSQL "SELECT * FROM services")
  echo -e "\nPlease pick a service:\n"
  echo "$SERVICES" | while read SERVICE_ID BAR SERVICE_NAME; do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done

  read SERVICE_ID_SELECTED
  
  SERVICE_FOUND=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
  
  if [[ -z $SERVICE_FOUND ]]
    then
    MAIN_MENU

    else
    echo -e "\nWhat's your phone number?\n"
    read CUSTOMER_PHONE
    CUSTOMER_FOUND=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    
    if [[ -z $CUSTOMER_FOUND ]]
    then
     # something
     echo -e "\nWhat is your name?\n"
     read CUSTOMER_NAME
     INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
     CUSTOMER_FOUND=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")

     else
     CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    fi

    echo -e "\nWhat time would you like your $SERVICE_FOUND, $CUSTOMER_NAME?"
    read SERVICE_TIME
    INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_FOUND, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
    echo "I have put you down for a $SERVICE_FOUND at $SERVICE_TIME, $CUSTOMER_NAME."

  fi
}

MAIN_MENU
