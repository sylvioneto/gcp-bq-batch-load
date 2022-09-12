resource "google_storage_bucket" "upload_bucket" {
  name                        = "${var.project_id}-upload"
  location                    = var.region
  uniform_bucket_level_access = true
  force_destroy               = true
}

resource "google_storage_bucket" "archive_bucket" {
  name                        = "${var.project_id}-archive"
  location                    = var.region
  uniform_bucket_level_access = true
  force_destroy               = true
}
