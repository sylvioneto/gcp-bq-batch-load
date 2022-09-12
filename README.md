# GCP BQ batch load

## Description

This example demonstrates how to batch load csv files upload to GCS directly to BigQuery and archive them for long-term purposes.

### Use case
Upload the data into the upload bucket following the pattern:
`gs://your-upload-bucket/dataset-name/table-name/file.csv`

The function will extract the parameters from the object path and then load the file into the table.


Resources created:
- BigQuery data sets and tables
- GCS buckets
- Cloud Functions

## Deploy

1. Create a new project and select it
2. Open Cloud Shell and ensure the env var below is set, otherwise set it with `gcloud config set project` command
```
echo $GOOGLE_CLOUD_PROJECT
```

3. Create a bucket to store your project's Terraform state
```
gsutil mb gs://$GOOGLE_CLOUD_PROJECT-tf-state
```

4. Enable the necessary APIs
```

gcloud services enable compute.googleapis.com \
    container.googleapis.com \
    containerregistry.googleapis.com\
    bigquery.googleapis.com \
    storage.googleapis.com \
    cloudfunctions.googleapis.com \
    eventarc.googleapis.com \
    run.googleapis.com

```

5. Give permissions to Cloud Build for creating the resources
```
PROJECT_NUMBER=$(gcloud projects describe $GOOGLE_CLOUD_PROJECT --format='value(projectNumber)')
gcloud projects add-iam-policy-binding $GOOGLE_CLOUD_PROJECT --member=serviceAccount:$PROJECT_NUMBER@cloudbuild.gserviceaccount.com --role=roles/editor
gcloud projects add-iam-policy-binding $GOOGLE_CLOUD_PROJECT --member=serviceAccount:$PROJECT_NUMBER@cloudbuild.gserviceaccount.com --role=roles/iam.securityAdmin
gcloud projects add-iam-policy-binding $GOOGLE_CLOUD_PROJECT --member=serviceAccount:$PROJECT_NUMBER-compute@developer.gserviceaccount.com --role=roles/editor
```

6. Clone this repo
```
git clone https://github.com/sylvioneto/gcp-bq-batch-load.git
cd ./gcp-bq-batch-load
```

7. Execute Terraform using Cloud Build
```
gcloud builds submit . --config cloudbuild.yaml
```

## Testing
Upload the sample data csv to your upload bucket, for example.
```
gsutil cp sample_data/order_events_001.csv gs://your-upload-bucket/ecommerce/order_events/
```
Then, go to BigQuery and check if the data has been loaded.
In case of problems, check Cloud Functions log.



## Destroy
1. Execute Terraform using Cloud Build
```
gcloud builds submit . --config cloudbuild_destroy.yaml
```

