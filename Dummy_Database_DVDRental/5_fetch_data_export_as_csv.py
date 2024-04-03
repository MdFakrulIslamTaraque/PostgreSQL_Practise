import pandas as pd
import psycopg2
from psycopg2 import Error
import config

try:
    connection = psycopg2.connect(
        host= config.host,
        port=config.port,
        database=config.database,
        user=config.user,
        password=config.password
    )
    cursor = connection.cursor()
    
    try:
        # Execute your SQL query here
        # sql_query = "SELECT * FROM actor"
        sql_query = "SELECT * FROM country"
        cursor.execute(sql_query)
    
        # Fetch all rows from the result set
        rows = cursor.fetchall()
        print(f"Data fetched: {cursor.rowcount} rows")
        print(f"Description: {cursor.description}")
    except (Exception, Error) as error:
        print("Error while fetching data from PostgreSQL:", error)
    
    # Convert the result set to a Pandas DataFrame
    df = pd.DataFrame(rows, columns=[col.name for col in cursor.description])

    # df.to_csv('actor.csv', index=False)
    df.to_csv('country.csv', index=False)
    print("Data exported as CSV successfully")
    
    # Close the cursor and connection
    cursor.close()
    connection.close()
    
except (Exception, Error) as error:
    print("Error while connecting to PostgreSQL:", error)
finally:
    # Close the connection even if an error occurs
    if connection:
        connection.close()
