resource "google_bigquery_dataset" "ecommerce" {
  dataset_id  = "ecommerce"
  description = "Store ecommerce data"
  location    = var.region
  labels      = local.resource_labels
}

resource "google_bigquery_table" "order_events" {
  dataset_id          = google_bigquery_dataset.ecommerce.dataset_id
  table_id            = "order_events"
  description         = "Store order events"
  deletion_protection = false

  time_partitioning {
    type  = "DAY"
    field = "action_time"
  }

  labels = local.resource_labels

  schema = <<EOF
[
  {
    "name": "order_id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "customer_email",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "action",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "action_time",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  }
]
EOF

}
