# import configuration.connect_db
import configuration.connect_db as configuration
import pandas as pd
from psycopg2 import Error

# class to fetch data and export to csv inherits from the connect_db class
class fetcher_and_exporter(configuration.Credential):
        
        # inherit the __init__ method from the connect_db class
        def __init__(self):
                super().__init__()

         # view the data fetched and description
        def view_data_description(self, cursor):
                print(f"Data fetched: {cursor.rowcount} rows")
                print(f"Description: {cursor.description}")
        
        def fetch_export(self, table_name):
                try:
                    cursor = self.connection.cursor()
                    try:
                            cursor.execute(f"SELECT * FROM {table_name}")
                            self.view_data_description(cursor)
                            data = cursor.fetchall()
                            columns = [desc[0] for desc in cursor.description]
                            df = pd.DataFrame(data, columns=columns)
                            df.to_csv(f'{table_name}.csv', index=False)
                            print(f'{table_name}.csv has been created')
                            self.close_connection()
                            self.close_cursor(cursor)
                    except Error as e:
                            print(f"Error: {e}")
                except Error as e:
                        print(f"Error: {e}")
                finally:
                        self.close_cursor(cursor)
                        self.close_connection()

# create an instance of the fetcher_and_exporter class
worker1 = fetcher_and_exporter()
worker1.fetch_export('actor')

worker2 = fetcher_and_exporter()
worker2.fetch_export('country')