# Vehicle Monitoring System application

## 1. Broadcasting to Supabase server
   ### Real-time broadcast script to a supabase
   This python script demonstrates a vehicle data logging system that integrates with Supabase for data storage. It simulates CAN messages using a DBC file, generates an `.asc` file for logging, and inserts the parsed data into a Supabase database.

---

### Features

1. **DBC File Integration**: Loads a `.dbc` file to encode simulated CAN signals into messages.
   ##### CAN DBC file (CAN Database) syntax:
      ```DBC
      BO_ 2024 OBD2: 8 Vector__XXX
     SG_ S01PID0D_VehicleSpeed m1 : 63|8@0+ (1,0) [0|255] "km/h" Vector__XXX
     ```
      - **BO_** : indicates message start (message syntax).
      - **2024** : CAN ID.
      - **OBD2** : Message name.
      - **8** : Length of message in data bytes.
      - **Vector__XXX** : Sender name.
      - **SG_** : Signal syntax.
      - **S01PID0D_VehicleSpeed** : Signal name.
      - **m1** : Multiplexer name, where multiplexer (m1) allows multiple signals to be sent using the same message ID but differentiated based on their multiplexer value.
      - **63** : Start bit of the corresponding signal.
      - **8** : Length of signal in bits.
      - **@0** : Means little endian byte ordering, where least significant bit is stored first.
      - **(1,0)** : (Scale, Offset).
      - **[0|255]** : Signal minimum and maximum values.
      - **km/h** : Measuring unit.
      - **Vector__XXX** : Receiver name.
3. **CAN Message Simulation**:
   - Generates vehicle telemetry data (e.g., Speed, Coolant temperature, Fuel level, Tires pressure, Battery State of Charge (SOH) ).
   - Encodes these signals into CAN messages.
4. **ASC File Logging**:
   - Logs generated CAN messages into an `.asc` file in a structured format.
5. **Parsing CAN Logs**:
   - Extracts and parses the last line of the `.asc` file into structured data.
   - Converts data_frame and can_message_id into a binary format suitable for database storage in supabase.
6. **Supabase Integration**:
   - Inserts parsed telemetry data into a Supabase database table.

---

## Requirements

- **Python Libraries**:
  - `supabase`, `cantools`, `binascii`, `base64`, `os`, `time`, `datetime`, `random`
- **Environment Variables**:
  - `URL`: Supabase project URL.
  - `KEY`: Supabase project anon key.
- **Files**:
  - `Custom_dbc2.dbc`: The DBC file containing CAN message definitions.

---

## Usage

1. **Setup Environment**:
   - Set `URL` and `KEY` environment variables for Supabase credentials.
2. **Run the Script**:
   - The script will:
     - Simulate CAN messages.
     - Log them into `vehicle_speed_log.asc`.
     - Parse the last logged message in the .asc file and store it in the Supabase database.
3. **Database Table**:
   - Ensure the Supabase table `car_logs_2` has the following schema:
     ```sql
     CREATE TABLE car_logs_2 (
         message_number TEXT,
         timestamp DOUBLE PRECISION,
         can_message_id BYTEA,
         data_frame BYTEA,
         signal_type TEXT
     );
     ```
---

## Output

- **ASC File**:
  - Example of logged data:
    ```
    1   1700000000.123456   1   123ABC   Tx -   8   01 02 03 04 05 06 07 08
    ```
- **Database Record**:
  - Example of inserted data:
    ```json
    {
        "message_number": "1",
        "timestamp": 1700000000.123456,
        "can_message_id": "Base64_encoded_binary_data",
        "data_frame": "Base64_encoded_binary_data",
        "signal_type": "Tx"
    }
    ```

---

## Notes

- **Error Handling**:
  - Logs errors in encoding CAN messages or parsing invalid lines.
- **Extensibility**:
  - Can be extended to handle real-time CAN data streams or other DBC definitions.

Enjoy seamless telemetry data logging and cloud integration! 🚗✨

---

## 2. Flutter application:

### Isolates

https://pub.dev/packages/serious_python

