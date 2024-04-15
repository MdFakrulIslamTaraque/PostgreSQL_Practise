import pytest
from configuration import connect_db
from configuration.connect_db import Credential

@pytest.fixture
def credential():
    return connect_db.Credential()

def test_postgres_connection(credential):
    assert credential.postgres_connection('dvdrental', 'postgres', 'postgres', '127.0.0.1', '5432') is True

    # Test with wrong credentials
    assert credential.postgres_connection('dvdrenta', 'postgres', 'postgres', '127.0.0.1', '5432') is False
    assert credential.postgres_connection('dvdrental', 'postgres', 'postgre', '127.0.0.1', '5432') is False
    assert credential.postgres_connection('dvdrental', 'postgres', 'postgres', '127.0.0.1', '5431') is False
