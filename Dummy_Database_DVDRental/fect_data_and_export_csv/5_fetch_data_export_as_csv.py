import pandas as pd
from psycopg2 import Error
import connect_db


def execute_query(table_name):

    # Execute your SQL query here
    sql_query = f"SELECT * FROM {table_name}"
    
    try:
        # Connect to the PostgreSQL database
        connection = connect_db.connection

        # Create a new cursor
        cursor = connection.cursor()

        # Execute the SQL query
        cursor.execute(sql_query)

        print(f"Data fetched: {cursor.rowcount} rows")
        print(f"Description: {cursor.description}")

         # Fetch all rows from the result set
        rows = cursor.fetchall()

         # Convert the result set to a Pandas DataFrame
        df = pd.DataFrame(rows, columns=[col.name for col in cursor.description])

        # df.to_csv('actor.csv', index=False)
        df.to_csv(f'{table_name}.csv', index=False)
        print("Data exported as CSV successfully")

        
        # Close the cursor and connection
        cursor.close()
        connection.close()
    
    except (Exception, Error) as error:
        print("Error while fetching data from PostgreSQL:", error)
    finally:
        # Close the connection even if an error occurs
        if connection:
            connection.close()


# execute_query('actor')
execute_query('country')