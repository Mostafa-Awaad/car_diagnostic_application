![Blue Gradient Header Banner](https://github.com/user-attachments/assets/d6241aa9-5266-4bad-b83d-3ed6447bc53d)

---
[![Language](https://img.shields.io/badge/Programming-Dart-3776AB?logo=dart&logoColor=blue)](https://www.dart.org)
[![Flutter](https://img.shields.io/badge/Frontend-Flutter-02569B?logo=flutter&logoColor=blue)](https://flutter.dev)
[![Python](https://img.shields.io/badge/Backend-Python-3776AB?logo=python&logoColor=white)](https://www.python.org)
[![Supabase](https://img.shields.io/badge/Database-Supabase-3ECF8E?logo=supabase&logoColor=3ECF8E)](https://supabase.io)
[![PostgreSQL](https://img.shields.io/badge/Database-PostgreSQL-4169E1?logo=postgresql&logoColor=white)](https://postgresql.org)
[![CAN DBC](https://img.shields.io/badge/Database-CAN_DBC-lightgrey?logo=database&logoColor=blue)](https://www.w3schools.com/sql/)




# 🔎 Vehicle Monitoring System application
## Table of Contents
- [About](#-about)
- [Features](#-features)
- [Workflow](#-workflow)
- [Technology Stack](#-technology-stack)
- [Usage](#-usage)
- [Output](#-output)

### 🚘 About
The **Car Monitoring System Application** is a real-time vehicle diagnostics and monitoring solution designed using **Flutter** for the user interface and **Python** for backend data processing. It provides an interactive and visually appealing dashboard that streams various car signals in real-time using dynamic gauges for each signal.

---
### ✨ Features
- **Flutter Application**:
  
  - Displays real-time vehicle signals on an intuitive dashboard.
  - Uses custom gauges to visualize key metrics such as:
    - **Vehicle Speed**
    - **Fuel Level**
    - **Engine Coolant Temperature**
    - **Car Tire Pressure**
    - **Battery Health**
  - Real-time data streaming for a seamless user experience.
   #### a) 🏢 Architecture:
   - For achieving modularity, the architecture is divided into:
     - A general model for any vehicle data signal (speed, engine coolant temperature, fuel level, etc...).
     - Two dart files for dealing with all sorts of signals such as (fetching most recent row in supabase - handling new row - subscribing to real-time updates) and (extracting the signal from a specific index in the data frame) which is represented in (`signal_handler.dart`& `signal_processor.dart`) respectively.
     - each screen in the app has its own dart file.
     - Folder for widgets, where each widget extracts a specific car signal by utilizing functions in signal_handler and signal processor.
     - Folder for gauges, where each signal has its own gauge, which is responsible for how the signal will be represented.
   #### b)🧵🧵 Isolates:
    - Streaming multiple car signals is handled using isolates, which is multi-threading in other programming languages.
    - An isolate has a unique characteristic: it runs within its own chunk of memory, processing events independently. Unlike threads in other programming languages, isolates 
      do not share memory, ensuring better isolation and thread safety.
    - This ensures smooth running of the application without crashing.
   
- **Backend Python Script**:
  - Processes a **DBC (Database CAN)** file to decode CAN messages.
    ##### CAN DBC file (CAN Database) syntax:
      ```DBC
      BO_ 2024 OBD2: 8 Vector__XXX
     SG_ S01PID0D_VehicleSpeed m1 : 63|8@0+ (1,0) [0|255] "km/h" Vector__XXX
     ```
     | **Field**                      | **Description**                                                                                                    |
      |--------------------------------|--------------------------------------------------------------------------------------------------------------------|
      | **BO_**                        | Indicates message start (message syntax).                                                                          |
      | **2024**                       | CAN ID.                                                                                                            |
      | **OBD2**                       | Message name.                                                                                                      |
      | **8**                          | Length of message in data bytes.                                                                                   |
      | **Vector__XXX**                | Sender name.                                                                                                       |
      | **SG_**                        | Signal syntax.                                                                                                     |
      | **S01PID0D_VehicleSpeed**      | Signal name.                                                                                                       |
      | **m1**                         | Multiplexer name, where multiplexer (m1) allows multiple signals to be sent using the same message ID but differentiated based on their multiplexer value. |
      | **63**                         | Start bit of the corresponding signal.                                                                             |
      | **8**                          | Length of signal in bits.                                                                                          |
      | **@0**                         | Little-endian byte ordering, where the least significant bit is stored first.                                      |
      | **(1,0)**                      | (Scale, Offset).                                                                                                   |
      | **[0,255]**                    | Signal minimum and maximum values.                                                                                 |
      | **km/h**                       | Measuring unit.                                                                                                    |
      | **Vector__XXX**                | Receiver name.                                                                                                     |

  - Converts the DBC data into an **ASC (ASCII log)** file containing continuously generated rows of data.
  - Automatically uploads the parsed data from the ASC file to a **Supabase database table** in real-time.

- **Supabase Integration**:
  - Acts as the central data repository for storing vehicle signal information.
  - Provides real-time updates to the Flutter app by streaming the **latest row** from the database.

---
### 🔗 Workflow
1. **Data Processing**:
   - A Python script decodes vehicle data using a **DBC file** and generates an **ASC file** with continuous vehicle signal data.

2. **Data Storage**:
   - The Python script uploads each new line of the ASC file to a **Supabase table**, ensuring a real-time flow of data.
   - Snippet from the .asc file
     ![image](https://github.com/user-attachments/assets/570afd29-4497-4fed-aa04-e9dafaec141b)

3. **Real-Time Display**:
   - The Flutter application fetches the **latest row** from the Supabase table.
   - Displays the corresponding signals dynamically using **gauges** for an engaging and informative user.
       <p align="center">
        <img src="https://github.com/user-attachments/assets/768ee458-14fb-4734-9338-cf50d5ddccd3" alt="Screenshot_1737551439" style="width: 20%; margin-right: 30px;" />
        <img src="https://github.com/user-attachments/assets/43de7fc9-f745-4768-a78e-b4fe5f7b17ed" alt="Screenshot_1737551445" style="width: 20%; margin-right: 30px;" />
        <img src="https://github.com/user-attachments/assets/4a46c86e-8a56-47dc-ac7a-a78c50a12e5a" alt="Screenshot_1737551452" style="width: 20%; margin-right: 30px;" />
        <img src="https://github.com/user-attachments/assets/f200e4ad-23a7-42b1-9bb2-7e0ffe189e0e" alt="Screenshot_1737551457" style="width: 20%;" />
       </p>




---

### 🛠 Technology Stack
- **Frontend**: Flutter (Dart)
- **Backend**: Python
  - **Python Libraries**:
      ```
      - supabase,
      - cantools
      - binascii
      - base64
      - os
      - time
      - datetime
      - random
       ```
- **Database**: Supabase (PostgreSQL-based)
  - **Environment Variables**:
     - `URL`: Supabase project URL.
     - `KEY`: Supabase project anon key.
- **Data Format**: DBC to ASC file conversion
  - **Files**:
     - `Custom_dbc2.dbc`: The DBC file containing CAN message definitions.
- **Communication**: Real-time database updates and streaming.

---

### 📱 Usage

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

### 📁 Output

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
- Supabase data representation
   ![image](https://github.com/user-attachments/assets/e3c09b44-6f26-4c6e-b76d-9f217e1f8218)
   ![image](https://github.com/user-attachments/assets/201cdf6f-09da-44c1-a6a5-12fe4ef13b50)


---

### ⚠ Notes

- **Error Handling**:
  - Logs errors in encoding CAN messages or parsing invalid lines.
- **Extensibility**:
  - Can be extended to handle real-time CAN data streams or other DBC definitions.

---
