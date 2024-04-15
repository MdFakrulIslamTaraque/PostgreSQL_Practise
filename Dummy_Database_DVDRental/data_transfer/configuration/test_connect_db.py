import pytest
from connect_db import Credential

class TestDatabaseConnection:
    @pytest.fixture
    def credential(self):
        return Credential()

    def test_postgres_connection(self, credential):
        assert credential.postgres_connection('dvdrental', 'postgres', 'postgres', '127.0.0.1', '5432') is True

    def test_postgres_connection_wrong_credentials(self, credential):
        assert credential.postgres_connection('dvdrenta', 'postgres', 'postgres', '127.0.0.1', '5432') is False
        assert credential.postgres_connection('dvdrental', 'postgres', 'postgre', '127.0.0.1', '5432') is False
        assert credential.postgres_connection('dvdrental', 'postgres', 'postgres', '127.0.0.1', '5431') is False
