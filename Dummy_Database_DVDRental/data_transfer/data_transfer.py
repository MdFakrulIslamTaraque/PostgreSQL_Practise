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
                            return True
                    except Error as e:
                            print(f"Error: {e}")
                            return False
                except Error as e:
                        print(f"Error: {e}")
                        return False
                finally:
                        self.close_cursor(cursor)
                        self.close_source_connection()

        def insert_data(self, source_table, target_table):
                try:
                    source_cursor = self.source_connection.cursor()
                    target_cursor = self.target_connection.cursor()
                    try:
                        source_cursor.execute(f"SELECT * FROM {source_table}")
                        self.view_data_description(source_cursor)
                        data = source_cursor.fetchall()
                            
                    except Error as e:
                                print(f"Error: {e}")
                                return False

                    try:
                        # Build the INSERT query dynamically with placeholders
                                column_names = [col.name for col in source_cursor.description]
                                placeholder_list = ', '.join(['%s' for _ in column_names])
                                insert_query = f"INSERT INTO {target_table} ({', '.join(column_names)}) VALUES ({placeholder_list})"
                                print(insert_query)

                                for row in data:
                                        try:
                                        # Execute the insert query with parameterization (prevents SQL injection)
                                                target_cursor.execute(insert_query, row)
                                        except (Exception, Error) as error:
                                                print("Error inserting data:", error)

                                # Commit changes to the other database
                                self.target_connection.commit()
                                return True

                
                    except Error as e:
                            print(f"Error: {e}")
                            return False

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
# worker2.insert_data('actor', 'actor_v2')