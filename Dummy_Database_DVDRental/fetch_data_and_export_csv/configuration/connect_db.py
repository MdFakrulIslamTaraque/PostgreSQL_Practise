import env_var
import psycopg2
import pandas as pd
from psycopg2 import Error


# create a class to connect to the database with all other methods

class fetcher_and_exporter:
        def __init__(self):
                self.connection = psycopg2.connect(
                        host= env_var.host,
                        port=env_var.port,
                        database=env_var.database,
                        user=env_var.user,
                        password=env_var.password
                )

        
        #close the connection
        def close_connection(self):
                self.connection.close()
        
        #close the cursor
        def close_cursor(self, cursor):
                cursor.close()

        #export the data as csv
        def export_csv(self, table_name, cursor, rows):
                 # Convert the result set to a Pandas DataFrame
                df = pd.DataFrame(rows, columns=[col.name for col in cursor.description])

                # df.to_csv('actor.csv', index=False)
                df.to_csv(f'{table_name}.csv', index=False)
                print("Data exported as CSV successfully")

        #execute the query
        def execute_query(self, table_name):
                return f"SELECT * FROM {table_name}"
        
        # view the data fetched and description
        def view_data_description(self, cursor):
                print(f"Data fetched: {cursor.rowcount} rows")
                print(f"Description: {cursor.description}")

        # execute the query and export the data as csv
        def execute(self, table_name):
                # Execute your SQL query here
                sql_query = self.execute_query(table_name)
                
                try:
                        # Connect to the PostgreSQL database
                        connection = self.connection

                        # Create a new cursor
                        cursor = connection.cursor()

                        # Execute the SQL query
                        cursor.execute(sql_query)

                        self.view_data_description(cursor)

                        # Fetch all rows from the result set
                        rows = cursor.fetchall()

                        self.export_csv(table_name, cursor, rows)
                        
                        # Close the cursor and connection
                        self.close_cursor(cursor)

                        # close the connection
                        self.close_connection()
                
                except (Exception, Error) as error:
                        print("Error while fetching data from PostgreSQL:", error)
                finally:
                        # Close the connection even if an error occurs
                        if connection:
                                self.close_connection()

# Create an instance of the Connection class
worker1 = fetcher_and_exporter()
worker1.execute('actor')