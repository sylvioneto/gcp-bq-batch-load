resource "google_storage_bucket" "gcf_source_bucket" {
  name                        = "${var.project_id}-gcf-source-bucket"
  location                    = var.region
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_object" "gcf_source_code" {
  name   = "function-source.zip"
  bucket = google_storage_bucket.gcf_source_bucket.name
  source = "/workspace/function-source.zip"
}

resource "google_cloudfunctions2_function" "function" {
  name        = "gcs-to-bq-trigger"
  location    = var.region
  description = "Load data from GCS to BQ"

  build_config {
    runtime     = "python310"
    entry_point = "trigger_gcs" # Set the entry point in the code

    source {
      storage_source {
        bucket = google_storage_bucket.gcf_source_bucket.name
        object = google_storage_bucket_object.gcf_source_code.name
      }
    }
  }

  service_config {
    max_instance_count = 3
    min_instance_count = 0
    available_memory   = "256M"
    timeout_seconds    = 60
    environment_variables = {
      DW_PROJECT_ID      = var.project_id
      GCS_ARCHIVE_BUCKET = google_storage_bucket.archive_bucket.name
    }
  }

  event_trigger {
    trigger_region = var.region
    event_type     = "google.cloud.storage.object.v1.finalized"
    retry_policy   = "RETRY_POLICY_RETRY"
    event_filters {
      attribute = "bucket"
      value     = google_storage_bucket.upload_bucket.name
    }
  }
}