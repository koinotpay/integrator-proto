# integrator-proto — schema-only repo for the koinotpay v2 ↔ vendor-integrator
# boundary. No code is generated here; consumers (gateway, integrator-humo,
# integrator-alif, …) own their own codegen so that adding a non-Go consumer
# (Python, TS) doesn't require touching this repo.
#
# CI on this repo runs `make lint` on every PR and `make breaking` against the
# main branch. Both require buf.

.PHONY: lint breaking format

lint:
	buf lint

# Compares HEAD's proto against origin/main; CI must run this on every PR.
# A failure means the change is wire-incompatible — bump the package version
# (e.g. aggregator/v2) instead of editing v1 in place.
breaking:
	buf breaking --against '.git#branch=main'

format:
	buf format -w
