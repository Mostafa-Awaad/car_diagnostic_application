# Vehicle Telemetry Data Logger and Supabase Integration

## Overview
This script demonstrates a vehicle telemetry data logging system that integrates with Supabase for data storage. It simulates CAN messages using a DBC file, generates an `.asc` file for logging, and inserts the parsed telemetry data into a Supabase database.

---

## Features

1. **DBC File Integration**: Loads a `.dbc` file to encode simulated CAN signals into messages.
2. **CAN Message Simulation**:
   - Generates vehicle telemetry data (e.g., speed, coolant temperature, fuel level).
   - Encodes these signals into CAN messages.
3. **ASC File Logging**:
   - Logs generated CAN messages into an `.asc` file in a structured format.
4. **Parsing CAN Logs**:
   - Extracts and parses the last line of the `.asc` file into structured data.
   - Converts data into a binary format suitable for database storage.
5. **Supabase Integration**:
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
     - Parse the last logged message and store it in the Supabase database.
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

## Workflow

1. **CAN Message Simulation**:
   - Simulated telemetry data is encoded using a DBC message definition.
2. **ASC Logging**:
   - Messages are appended to an `.asc` log file with a unique timestamp.
3. **Log Parsing**:
   - The last line of the log file is parsed for message data.
   - Data is converted to binary and Base64 for storage.
4. **Data Insertion**:
   - Parsed data is inserted into the Supabase database.

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

## Isolates

https://pub.dev/packages/serious_python

