storage "file" {
 path    = "/vault/data"
}

listener "tcp" {
 address     = "0.0.0.0:8200"
 tls_disable = 1
}

api_addr = "http://127.0.0.1:8200"

max_lease_ttl = "24h"
default_lease_ttl = "24h"
max_versions=2
ui = true
log_level = "Trace"