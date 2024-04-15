# import os
# import psycopg2
# from data_transfer import Credential
# import pytest

# # Define test data
# test_data = [
#     (1, 'Test Movie 1', 3),
#     (2, 'Test Movie 2', 4),
#     (3, 'Test Movie 3', 5)
# ]

# # Define test fixture for test data transfer
# @pytest.fixture
# def credential():
#     return Credential()

# def test_fetch_export(credential):
#     # Create a temporary table with test data
#     with credential.source_connection.cursor() as cursor:
#         cursor.execute("CREATE TEMP TABLE test_movies(movie_id INT, title VARCHAR(255), rating INT)")
#         for data in test_data:
#             cursor.execute("INSERT INTO test_movies VALUES (%s, %s, %s)", data)

#     # Test fetching and exporting data
#     credential.fetch_export('test_movies')
    
#     # Check if the CSV file is created
#     assert os.path.exists('test_movies.csv')

# def test_insert_data(credential):
#     # Create a temporary table with test data
#     with credential.source_connection.cursor() as cursor:
#         cursor.execute("CREATE TEMP TABLE test_movies(movie_id INT, title VARCHAR(255), rating INT)")
#         for data in test_data:
#             cursor.execute("INSERT INTO test_movies VALUES (%s, %s, %s)", data)

#     # Test fetching and inserting data
#     credential.insert_data('test_movies', 'target_table')

#     # Check if data is inserted into the target table
#     with credential.target_connection.cursor() as cursor:
#         cursor.execute("SELECT COUNT(*) FROM target_table")
#         count = cursor.fetchone()[0]
#         assert count == len(test_data)

import pytest
from data_transfer import fetcher_and_exporter

@pytest.fixture
def worker():
    return fetcher_and_exporter()

def test_fetch_export(worker):
    assert worker is not None
    # Test case 1: Check if fetch_export method returns True when given a valid table name
    assert worker.fetch_export('actor') is True
    # Test case 2: Check if fetch_export method returns False when given an invalid table name
    assert worker.fetch_export('invalid_table') is False

def test_insert_data(worker):
    assert worker is not None
    # Test case 1: Check if insert_data method returns True when given valid source and target table names
    assert worker.insert_data('actor', 'actor_v2') is True
    # Test case 2: Check if insert_data method returns False when given an invalid source table name
    assert worker.insert_data('invalid_source_table', 'target_table') is False
