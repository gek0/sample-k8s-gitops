# s3-bucket

AWS S3 bucket with security hardening (Crossplane Helm chart)

![Version: 1.0.0](https://img.shields.io/badge/Version-1.0.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

## Prerequisites

- [Crossplane](https://crossplane.io) installed in the cluster
- `upbound-provider-family-aws` and `upbound-provider-aws-s3` providers healthy
- A `ProviderConfig` named `devops-aws` (or override via `providerConfig`)

## Usage

Managed by ArgoCD via the `crossplane-devops-aws` ApplicationSet. Values files live at:
```
services/crossplane/aws/devops/{env}/s3-bucket-values.yaml
```

To disable without removing the ArgoCD Application, set `enabled: false` in the values file.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| accountId | string | `""` | AWS account ID. Used in the S3 bucket name and tags. |
| bucketPrefix | string | `""` | Bucket name prefix. Combined with env, region and accountId: `{env}-{bucketPrefix}-{region}-{accountId}`. |
| enabled | bool | `true` | Deploy this chart. Set to false to skip all resources without removing the ArgoCD Application. |
| env | string | `""` | Environment name (dev, prod). Used in resource names and tags. |
| providerConfig | string | `"devops-aws"` | Name of the Crossplane ProviderConfig to use for AWS authentication. |
| region | string | `""` | AWS region where the bucket is created. |
| tags | object | `{"ManagedBy":"crossplane","Team":"devops"}` | AWS resource tags applied to the bucket and all sub-resources. |

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Matija Burisa |  | <https://github.com/gek0> |

## Source Code

* <https://github.com/gek0/sample-k8s-gitops>
