# vpc

AWS VPC (Crossplane Helm chart)

![Version: 1.0.0](https://img.shields.io/badge/Version-1.0.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

## Prerequisites

- [Crossplane](https://crossplane.io) installed in the cluster
- `upbound-provider-family-aws` and `upbound-provider-aws-ec2` providers healthy
- A `ProviderConfig` named `devops-aws` (or override via `providerConfig`)

## Usage

Managed by ArgoCD via the `crossplane-devops-aws` ApplicationSet. Values files live at:
```
services/crossplane/aws/devops/{env}/vpc-values.yaml
```

To disable without removing the ArgoCD Application, set `enabled: false` in the values file.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| accountId | string | `""` | AWS account ID. Used in tags. |
| cidrBlock | string | `""` | VPC CIDR block. |
| enabled | bool | `true` | Deploy this chart. Set to false to skip all resources without removing the ArgoCD Application. |
| env | string | `""` | Environment name (dev, prod). Used in resource names and tags. |
| privateSubnets | list | `[]` | Private subnets. Each gets mapPublicIpOnLaunch=false and SubnetType=private tag. |
| providerConfig | string | `"devops-aws"` | Name of the Crossplane ProviderConfig to use for AWS authentication. |
| publicSubnets | list | `[]` | Public subnets. Each gets mapPublicIpOnLaunch=true and SubnetType=public tag. |
| region | string | `""` | AWS region where the VPC is created. |
| tags | object | `{"ManagedBy":"crossplane","Team":"devops"}` | AWS resource tags applied to the VPC and all subnets. |
| vpcPrefix | string | `""` | VPC name prefix. Combined with env: `{env}-{vpcPrefix}`. |

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Matija Burisa |  | <https://github.com/gek0> |

## Source Code

* <https://github.com/gek0/sample-k8s-gitops>
