from google.cloud import bigquery
import logging
import os

PROJECT_ID = os.getenv('GCP_PROJECT')
BQ = bigquery.Client()
DB = 'covid'

def storage_to_bq(event, context):
    """Triggered by a change to a Cloud Storage bucket.
    Args:
         event (dict): Event payload.
         context (google.cloud.functions.Context): Metadata for the event.
    """
    file = event
    bucket = event['bucket']
    file_name = event['name']

    if file_name == 'caso.csv' or file_name == 'obito_cartorio.csv':
        tabela = file_name.split('.')[0]
        conf=bigquery.LoadJobConfig(
            skip_leading_rows=1
        )
        
        job = BQ.load_table_from_uri(f'gs://{bucket}/{file_name}', f'{PROJECT_ID}.{DB}.{tabela}', job_config=conf)

        job.result()