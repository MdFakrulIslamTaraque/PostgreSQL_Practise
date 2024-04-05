# import configuration.connect_db
import configuration.connect_db as configuration
import pandas as pd
from psycopg2 import Error
import numpy as np

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
                    cursor = self.source_connection.cursor()
                    try:
                            cursor.execute(f"SELECT * FROM {table_name}")
                            self.view_data_description(cursor)
                            data = cursor.fetchall()
                            columns = [desc[0] for desc in cursor.description]
                            df = pd.DataFrame(data, columns=columns)
                            df.to_csv(f'{table_name}.csv', index=False)
                            print(f'{table_name}.csv has been created')
                            self.close_source_connection()
                            self.close_cursor(cursor)
                    except Error as e:
                            print(f"Error: {e}")
                except Error as e:
                        print(f"Error: {e}")
                finally:
                        self.close_cursor(cursor)
                        self.close_source_connection()
        
        # read all the values from a source table and insert them to another target table ( already created in the database), before that: 
        # convert the data types to match the target table
        # replace the NaN values with None
        # convert the extracted data to a pandas dataframe(nupy array)
        # join the column names and data types to create a string
        # run the insert query to insert the data into the database table ( which is already creted in the database)
        # using extras module to insert the data into the database table
        # commit the changes, close the cursor and connection
        # print the message that the data has been inserted

        def insert_data(self, source_table, target_table):
                try:
                    source_cursor = self.source_connection.cursor()
                    target_cursor = self.target_connection.cursor()
                    try:
                            source_cursor.execute(f"SELECT * FROM {source_table}")
                            self.view_data_description(source_cursor)
                            data = source_cursor.fetchall()
                            columns = [desc[0] for desc in source_cursor.description]
                            df = pd.DataFrame(data, columns=columns)
                        #     df = df.where(pd.notnull(df), None)
                        #     data = df.to_numpy()
                        #     column_names = ', '.join(columns)
                        #     column_values = ', '.join(['%s' for _ in range(len(columns))])

                            df = df.convert_dtypes() # acctual data types 
                            df.replace({np.nan: None}, inplace = True)  # replace null value
                            column_values = [tuple(x) for x in df.to_numpy()]  # extract data
                            column_names = ",".join([col[0] for col in source_cursor.description])  # columns
                            
                    except Error as e:
                                print(f"Error: {e}")

                    try:
                            insert_query = f"INSERT INTO {target_table} ({column_names}) VALUES ({column_values})"
                            target_cursor.executemany(insert_query, data)
                            self.target_connection.commit()
                            print(f"Data inserted into {target_table}")


                            self.close_source_connection()
                            self.close_target_connection()

                            self.close_cursor(source_cursor)
                            self.close_cursor(target_cursor)
                
                    except Error as e:
                            print(f"Error: {e}")

                except Error as e:
                        print(f"Error: {e}")
                finally:
                        self.close_cursor(source_cursor)
                        self.close_cursor(target_cursor)
                        self.close_source_connection()
                        self.close_target_connection()


# create an instance of the fetcher_and_exporter class
# worker1 = fetcher_and_exporter()
# worker1.fetch_export('actor')

worker2 = fetcher_and_exporter()
# worker2.fetch_export('country')
worker2.insert_data('country', 'country_v2')