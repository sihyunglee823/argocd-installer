function (
    CUSTOM_DOMAIN_NAME="domain_name",
    HYPERAUTH_DOMAIN="hyerpauth_domain"
)


[
{
  "apiVersion": "rbac.authorization.k8s.io/v1",
  "kind": "ClusterRole",
  "metadata": {
    "name": "kiali",
    "labels": {
      "app": "kiali",
      "release": "istio"
    }
  },
  "rules": [
    {
      "apiGroups": [
        ""
      ],
      "resources": [
        "configmaps",
        "endpoints",
        "namespaces",
        "nodes",
        "pods",
        "pods/log",
        "replicationcontrollers",
        "services"
      ],
      "verbs": [
        "get",
        "list",
        "watch"
      ]
    },
    {
      "apiGroups": [
        "extensions",
        "apps"
      ],
      "resources": [
        "deployments",
        "replicasets",
        "statefulsets"
      ],
      "verbs": [
        "get",
        "list",
        "watch"
      ]
    },
    {
      "apiGroups": [
        "autoscaling"
      ],
      "resources": [
        "horizontalpodautoscalers"
      ],
      "verbs": [
        "get",
        "list",
        "watch"
      ]
    },
    {
      "apiGroups": [
        "batch"
      ],
      "resources": [
        "cronjobs",
        "jobs"
      ],
      "verbs": [
        "get",
        "list",
        "watch"
      ]
    },
    {
      "apiGroups": [
        "config.istio.io",
        "networking.istio.io",
        "authentication.istio.io",
        "rbac.istio.io",
        "security.istio.io"
      ],
      "resources": [
        "*"
      ],
      "verbs": [
        "create",
        "delete",
        "get",
        "list",
        "patch",
        "watch"
      ]
    },
    {
      "apiGroups": [
        "monitoring.kiali.io"
      ],
      "resources": [
        "monitoringdashboards"
      ],
      "verbs": [
        "get",
        "list"
      ]
    }
  ]
},
  {
    "apiVersion": "rbac.authorization.k8s.io/v1",
    "kind": "ClusterRole",
    "metadata": {
      "name": "kiali-viewer",
      "labels": {
        "app": "kiali",
        "release": "istio"
      }
    },
    "rules": [
      {
        "apiGroups": [
          ""
        ],
        "resources": [
          "configmaps",
          "endpoints",
          "namespaces",
          "nodes",
          "pods",
          "pods/log",
          "replicationcontrollers",
          "services"
        ],
        "verbs": [
          "get",
          "list",
          "watch"
        ]
      },
      {
        "apiGroups": [
          "extensions",
          "apps"
        ],
        "resources": [
          "deployments",
          "replicasets",
          "statefulsets"
        ],
        "verbs": [
          "get",
          "list",
          "watch"
        ]
      },
      {
        "apiGroups": [
          "autoscaling"
        ],
        "resources": [
          "horizontalpodautoscalers"
        ],
        "verbs": [
          "get",
          "list",
          "watch"
        ]
      },
      {
        "apiGroups": [
          "batch"
        ],
        "resources": [
          "cronjobs",
          "jobs"
        ],
        "verbs": [
          "get",
          "list",
          "watch"
        ]
      },
      {
        "apiGroups": [
          "config.istio.io",
          "networking.istio.io",
          "authentication.istio.io",
          "rbac.istio.io",
          "security.istio.io"
        ],
        "resources": [
          "*"
        ],
        "verbs": [
          "get",
          "list",
          "watch"
        ]
      },
      {
        "apiGroups": [
          "monitoring.kiali.io"
        ],
        "resources": [
          "monitoringdashboards"
        ],
        "verbs": [
          "get",
          "list"
        ]
      }
    ]
  },
  {
    "apiVersion": "v1",
    "kind": "ServiceAccount",
    "metadata": {
      "name": "kiali-service-account",
      "namespace": "istio-system",
      "labels": {
        "app": "kiali",
        "release": "istio"
      }
    }
  },
  {
    "apiVersion": "rbac.authorization.k8s.io/v1",
    "kind": "ClusterRoleBinding",
    "metadata": {
      "name": "kiali",
      "labels": {
        "app": "kiali",
        "release": "istio"
      }
    },
    "roleRef": {
      "apiGroup": "rbac.authorization.k8s.io",
      "kind": "ClusterRole",
      "name": "kiali"
    },
    "subjects": [
      {
        "kind": "ServiceAccount",
        "name": "kiali-service-account",
        "namespace": "istio-system"
      }
    ]
  },
  {
    "apiVersion": "v1",
    "kind": "Secret",
    "metadata": {
      "name": "kiali",
      "namespace": "istio-system",
      "labels": {
        "app": "kiali",
        "release": "istio"
      }
    },
    "type": "Opaque",
    "data": {
      "username": "YWRtaW4=",
      "passphrase": "YWRtaW4="
    }
  },
  {
    apiVersion: 'v1',
    kind: 'ConfigMap',
    metadata: {
      name: 'kiali',
      namespace: 'istio-system',
      labels: {
        app: 'kiali',
        release: 'istio',
      },
    },
    data: {
      'config.yaml': "istio_component_namespaces:\n  grafana: monitoring\n  tracing: istio-system\n  pilot: istio-system\n  prometheus: monitoring\nistio_namespace: istio-system\nauth:\n  strategy: \"openid\"\n  openid:\n    client_id: \"kiali\"\n    issuer_url: \"https://HYPERAUTH_DOMAIN/auth/realms/tmax\"\n    authorization_endpoint: \"https://HYPERAUTH_DOMAIN/auth/realms/tmax/protocol/openid-connect/auth\"\ndeployment:\n  accessible_namespaces: ['**']\nlogin_token:\n  signing_key: \"wl5oStULbP\"\nserver:\n  port: 20001\n  web_root: /api/kiali\nexternal_services:\n  istio:\n    url_service_version: http://istio-pilot.istio-system:8080/version\n  tracing:\n    url:\n    in_cluster_url: http://tracing/api/jaeger\n  grafana:\n    url:\n    in_cluster_url: http://grafana.monitoring:3000\n  prometheus:\n    url: http://prometheus-k8s.monitoring:9090\n",
    },
  },
  {
    "apiVersion": "apps/v1",
    "kind": "Deployment",
    "metadata": {
      "labels": {
        "app": "kiali",
        "release": "istio"
      },
      "name": "kiali",
      "namespace": "istio-system"
    },
    "spec": {
      "replicas": 1,
      "selector": {
        "matchLabels": {
          "app": "kiali"
        }
      },
      "template": {
        "metadata": {
          "annotations": {
            "kiali.io/runtimes": "go,kiali",
            "prometheus.io/port": "9090",
            "prometheus.io/scrape": "true",
            "scheduler.alpha.kubernetes.io/critical-pod": "",
            "sidecar.istio.io/inject": "false"
          },
          "labels": {
            "app": "kiali",
            "release": "istio"
          },
          "name": "kiali"
        },
        "spec": {
          "affinity": {
            "nodeAffinity": {
              "preferredDuringSchedulingIgnoredDuringExecution": [
                {
                  "preference": {
                    "matchExpressions": [
                      {
                        "key": "beta.kubernetes.io/arch",
                        "operator": "In",
                        "values": [
                          "amd64"
                        ]
                      }
                    ]
                  },
                  "weight": 2
                },
                {
                  "preference": {
                    "matchExpressions": [
                      {
                        "key": "beta.kubernetes.io/arch",
                        "operator": "In",
                        "values": [
                          "ppc64le"
                        ]
                      }
                    ]
                  },
                  "weight": 2
                },
                {
                  "preference": {
                    "matchExpressions": [
                      {
                        "key": "beta.kubernetes.io/arch",
                        "operator": "In",
                        "values": [
                          "s390x"
                        ]
                      }
                    ]
                  },
                  "weight": 2
                }
              ],
              "requiredDuringSchedulingIgnoredDuringExecution": {
                "nodeSelectorTerms": [
                  {
                    "matchExpressions": [
                      {
                        "key": "beta.kubernetes.io/arch",
                        "operator": "In",
                        "values": [
                          "amd64",
                          "ppc64le",
                          "s390x"
                        ]
                      }
                    ]
                  }
                ]
              }
            }
          },
          "containers": [
            {
              "command": [
                "/opt/kiali/kiali",
                "-config",
                "/kiali-configuration/config.yaml",
                "-v",
                "3"
              ],
              "env": [
                {
                  "name": "ACTIVE_NAMESPACE",
                  "valueFrom": {
                    "fieldRef": {
                      "fieldPath": "metadata.namespace"
                    }
                  }
                }
              ],
              "image": "quay.io/kiali/kiali:v1.21",
              "imagePullPolicy": "IfNotPresent",
              "livenessProbe": {
                "httpGet": {
                  "path": "/api/kiali/healthz",
                  "port": 20001,
                  "scheme": "HTTP"
                },
                "initialDelaySeconds": 5,
                "periodSeconds": 30
              },
              "name": "kiali",
              "readinessProbe": {
                "httpGet": {
                  "path": "/api/kiali/healthz",
                  "port": 20001,
                  "scheme": "HTTP"
                },
                "initialDelaySeconds": 5,
                "periodSeconds": 30
              },
              "resources": {
                "requests": {
                  "cpu": "10m",
                  "memory": "50Mi"
                },
                "limits": {
                  "cpu": "50m",
                  "memory": "100Mi"
                }
              },
              "volumeMounts": [
                {
                  "mountPath": "/kiali-configuration",
                  "name": "kiali-configuration"
                },
                {
                  "mountPath": "/kiali-cert",
                  "name": "kiali-cert"
                },
                {
                  "mountPath": "/kiali-secret",
                  "name": "kiali-secret"
                }
              ]
            }
          ],
          "serviceAccountName": "kiali-service-account",
          "volumes": [
            {
              "configMap": {
                "name": "kiali"
              },
              "name": "kiali-configuration"
            },
            {
              "name": "kiali-cert",
              "secret": {
                "optional": true,
                "secretName": "istio.kiali-service-account"
              }
            },
            {
              "name": "kiali-secret",
              "secret": {
                "optional": true,
                "secretName": "kiali"
              }
            }
          ]
        }
      }
    }
  },
  {
    "apiVersion": "v1",
    "kind": "Service",
    "metadata": {
      "name": "kiali",
      "namespace": "istio-system",
      "labels": {
        "app": "kiali",
        "release": "istio"
      }
    },
    "spec": {
      "ports": [
        {
          "name": "http-kiali",
          "protocol": "TCP",
          "port": 20001
        }
      ],
      "selector": {
        "app": "kiali"
      }
    }
  },
  {
    "apiVersion": "networking.k8s.io/v1",
    "kind": "Ingress",
    "metadata": {
      "name": "kiali-ingress",
      "namespace": "istio-system",
      "annotations": {
        "traefik.ingress.kubernetes.io/router.entrypoints": "websecure"
      },
      "labels": {
        "ingress.tmaxcloud.org/name": "kiali"
      }
    },
    "spec": {
      "ingressClassName": "tmax-cloud",
      "tls": [
        {
          "hosts": [
            std.join("", ["kiali.", CUSTOM_DOMAIN_NAME]),
          ]
        }
      ],
      "rules": [
        {
          "host": std.join("", ["kiali.", CUSTOM_DOMAIN_NAME]),
          "http": {
            "paths": [
              {
                "path": "/",
                "pathType": "Prefix",
                "backend": {
                  "service": {
                    "name": "kiali",
                    "port": {
                      "number": 20001
                    }
                  }
                }
              },
              {
                "path": "/api/kiali",
                "pathType": "Prefix",
                "backend": {
                  "service": {
                    "name": "kiali",
                    "port": {
                      "number": 20001
                    }
                  }
                }
              }
            ]
          }
        }
      ]
    }
  }
]
