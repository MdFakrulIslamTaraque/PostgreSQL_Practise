import psycopg2
from psycopg2 import Error
import os
import json

# load the environment variables from config.json file (host, port, database, user, and password)
config_file = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'config.json')

# check if the file exists and after that load the environment variables
with open(config_file, 'r') as file:
        env_var = json.load(file)


# create a class to connect to the database with all other methods
class Credential:
        def __init__(self):
                try:
                        # Connect to the PostgreSQL database
                        self.connection = psycopg2.connect(
                                host=env_var['host'],
                                port=env_var['port'],
                                database=env_var['database'],
                                user=env_var['user'],
                                password=env_var['password']
                        )
                        print("Connected to the database successfully")
                except (Exception, Error) as error:
                        print("Error while connecting to PostgreSQL", error)
        
        #close the connection
        def close_connection(self):
                self.connection.close()
                print("Connection closed successfully")
        
        #close the cursor
        def close_cursor(self, cursor):
                cursor.close()
                print("Cursor closed successfully")