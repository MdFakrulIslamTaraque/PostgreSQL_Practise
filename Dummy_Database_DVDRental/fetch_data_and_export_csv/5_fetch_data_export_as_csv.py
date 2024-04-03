import fetch_data_and_export_csv.configuration.connect_db as config

# Create an instance of the Connection class
worker1 = config.fetcher_and_exporter()
worker1.view_data_description(worker1.execute('actor'))