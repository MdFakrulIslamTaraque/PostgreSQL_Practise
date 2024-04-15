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
                        # Connect to the PostgreSQL source database
                        self.source_connection = psycopg2.connect(
                                host=env_var['host'],
                                port=env_var['port'],
                                database=env_var['source_database'],
                                user=env_var['user'],
                                password=env_var['password']
                        )
                        print("Connected to the source database successfully")

                        # connect to the PostgreSQL target database
                        self.target_connection = psycopg2.connect(
                                host=env_var['host'],
                                port=env_var['port'],
                                database=env_var['target_database'],
                                user=env_var['user'],
                                password=env_var['password']
                        )

                except (Exception, Error) as error:
                        print("Error while connecting to PostgreSQL", error)
        
        #load the environment variables
        def load_env_var(self):
                return env_var

        #close the  source connection
        def close_source_connection(self):
                self.source_connection.close()
                print("Connection closed successfully")
        
        #close the target connection
        def close_target_connection(self):
                self.target_connection.close()
                print("Connection closed successfully")
        
        #close the cursor
        def close_cursor(self, cursor):
                cursor.close()
                print("Cursor closed successfully")