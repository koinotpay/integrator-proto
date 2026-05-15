# integrator-proto

Schema for the contract between **koinotpay** (the gateway) and
**vendor integrators** (Humo, Alif, Korti Milli, …). One repo per integrator
microservice; one shared schema repo for all of them.

This repo is **schema-only**: no language stubs are committed. Each consumer
generates its own — that way a future Python or TypeScript integrator doesn't
have to touch this repo.

## Layout

```
proto/
  integrator/v1/integrator.proto    # service contract (IntegratorService)
buf.yaml                            # module + lint + breaking-check policy
Makefile                            # lint / breaking / format
```

## Versioning

Wire-incompatible changes (removing a field, changing a tag, changing a
type, renaming an enum value) require a new package version (e.g.
`integrator/v2`) — never edit `integrator/v1` in place. CI enforces this
with `buf breaking` against `main`.

## Consume from a Go service

Add this repo as a git submodule, then generate stubs locally:

```bash
git submodule add https://github.com/koinotpay/integrator-proto third_party/integrator-proto
```

In your service, add a `buf.gen.yaml` and a `make gen` target that points at
`third_party/integrator-proto/proto`. Example `buf.gen.yaml`:

```yaml
version: v2
inputs:
  - directory: third_party/integrator-proto/proto
plugins:
  - remote: buf.build/protocolbuffers/go
    out: internal/integratorpb
    opt:
      - paths=source_relative
  - remote: buf.build/grpc/go
    out: internal/integratorpb
    opt:
      - paths=source_relative
      - require_unimplemented_servers=false
```

Update the submodule when the contract changes:

```bash
git submodule update --remote third_party/integrator-proto
make gen
```
