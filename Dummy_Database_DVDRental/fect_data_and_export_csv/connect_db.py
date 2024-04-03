import conf.env_var as env_var
import psycopg2
connection = psycopg2.connect(
        host= env_var.host,
        port=env_var.port,
        database=env_var.database,
        user=env_var.user,
        password=env_var.password
)