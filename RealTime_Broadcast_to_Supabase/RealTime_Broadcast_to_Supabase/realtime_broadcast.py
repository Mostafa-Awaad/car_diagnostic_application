import supabase
from supabase import create_client
import os
import time
import datetime
from datetime import datetime
import random
import cantools
import binascii  # for hex to binary conversion
import base64
import dotenv
from dotenv import load_dotenv

# Function from the python-dotenv library used to load environment variables from a .env file into the environment. These variables can then be accessed using os.environ
load_dotenv()
# Retrieving the value of environment variables of the supabase
supabase_url = os.environ.get("URL")
supabase_anon_key = os.environ.get("KEY")

# Creating a Supabase client
supabase = create_client(supabase_url, supabase_anon_key)

# Load the DBC file
dbc = cantools.database.load_file('Custom_dbc2.dbc')

# Get the message by name
message = dbc.get_message_by_name('OBD2')
no_of_rows = 10000

# Function to parse the data of the last line in asc file 
def parse_last_line_asc_file (file_path):
    with open(file_path, 'r') as file:
        last_line = file.readlines()[-1]

    log_data = []

    # Splitting the current last line into a list of parts
    parts = last_line.split()

    # Skip invalid lines
    if len(parts) < 10:
        print("Invalid line ")
    else:
        message_number = parts[0]
        timestamp = float(parts[1])
        can_message_id = parts[3].strip()  # Strip any spaces
        
        # Ensure the can_message_id has even length by padding with a leading 0 if necessary
        if len(can_message_id) % 2 != 0:
            can_message_id = '0' + can_message_id

        signal_type = parts[4]
        data_frame = parts[7:]  # Data bytes
        
        # Convert can_message_id and data_frame to binary for BYTEA
        try:
            can_message_id_bin = binascii.unhexlify(can_message_id)  # Convert hex to binary
        except binascii.Error:
            print(f"Error converting CAN message ID: {can_message_id}")
            

        # Join data_frame bytes and remove any unwanted spaces, then convert to binary
        data_frame_cleaned = ''.join(byte.strip() for byte in data_frame)
        try:
            data_frame_bin = binascii.unhexlify(data_frame_cleaned)
        except binascii.Error:
            print(f"Error converting data frame: {data_frame_cleaned}")
            

        log_data.append({
            'message_number': message_number,
            'timestamp'     : timestamp,
            'can_message_id': base64.b64encode(can_message_id_bin).decode('utf-8'),
            'data_frame'    : base64.b64encode(data_frame_bin).decode('utf-8'),
            'signal_type'   : signal_type
        })
    
    return log_data

# Function to inserting last line data into the supabase
def insert_into_supabase (log_data):
    for log_entry in log_data:
        response = (
            supabase.table("car_logs_2")
            .insert({"message_number"  : log_entry['message_number'],
                     "timestamp"       : log_entry['timestamp'],
                     "can_message_id"  : log_entry['can_message_id'],
                     "data_frame"      : log_entry['data_frame'],
                     "signal_type"     : "Tx" }).execute()
        )


# Generate CAN messages and save to .asc file
with open('vehicle_speed_log.asc', 'w') as log_file:
    # Initiating writing in asc file
    log_file.write("date {}\n".format(datetime.now().strftime('%a %b %d %H:%M:%S.%f %Y')))
    log_file.write("Begin Triggerblock\n")

for i in range(0, no_of_rows):
    # Generate CAN messages and save to .asc file
    with open('vehicle_speed_log.asc', 'a') as log_file:
        # Simulating the different signals in the dbc file
        speed = random.randint(0, 255)
        coolant_temp = random.randint(-40, 215)
        soh_per = random.randint(0, 100)
        soc_per = random.randint(0, 100)
        fuel_level = random.randint(0, 100)
        new_distance = random.randint(0, 65535)
        engine_load = random.randint(0, 100)
        timestamp = datetime.now().timestamp() + i * 0.1

        # Ensure the signal name is correct
        try:
            encoded_message = message.encode({  'S01PID0D_VehicleSpeed'     : speed,
                                                'S01PID05_EngineCoolantTemp': coolant_temp,
                                                'S01PID4D_BatterySOH'       : soh_per, 
                                                'S01PID4E_BatterySOC'       : soc_per,
                                                'S01PID2F_FuelTankLevel'    : fuel_level,
                                                'S01PID21_DistanceMILOn'    : new_distance,
                                                'S01PID04_CalcEngineLoad'   : engine_load})
            
            log_file.writelines(f"{i+1}\t {timestamp}\t1\t {message.frame_id:X}\t Tx -\t {len(encoded_message)}\t {'\t'.join(f'{b:02X}' for b in encoded_message)}\n")
        except cantools.database.errors.EncodeError as e:
            print(f"Error encoding message at index {i}: {e}")  # Handle encoding errors
        
    #delay for 2 seconds
    time.sleep(2)
    new_last_line = parse_last_line_asc_file('vehicle_speed_log.asc')
    insert_into_supabase(new_last_line)

# Ending writing in the asc file
log_file.write("End TriggerBlock\n")
print("ASC file created: log_file.asc")
        



