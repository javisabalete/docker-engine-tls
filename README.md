# docker-engine-tls
This image generates ca, server and client certificates for Docker Engine

## Quick Start

```bash
mkdir certs
docker run --rm -v $PWD/certs:/certs -u $(id -u):$(id -g) javisabalete/docker-engine-tls
```

## Available Configuration Parameters

* `RSA`: The key size to use. Default is `4096`.
* `CA_EXPIRE_DAYS`: This specifies the number of days to certify the CA certificate for. Default is 365 days.
* `SERVER_EXPIRE_DAYS`: This specifies the number of days to certify the SERVER certificate for. Default is 365 days.
* `CLIENT_EXPIRE_DAYS`: This specifies the number of days to certify the CLIENT certificate for. Default is 365 days.
* `CA_C`: The Country for CA cert. Default is `US`.
* `CA_ST`: The State/Region for CA cert. Default is `CoolState`.
* `CA_L`: The City for CA cert. Default is `NiceCity`.
* `CA_O`: The Organization Name for CA cert. Default is `Docker`.
* `CA_OU`: The Organizational Unit Name for CA cert. Default is `Docker`.
* `CA_CN`: The Common Name for CA cert. Default is `Docker`.
* `SERVER`: The server Common Name. Default is `docker.example.com`.
* `CLIENTS`: The client Common Name. Default is `Docker-Client`.
* `ALLOWED`: Configure SAN. Default is `` (disabled).

## Examples

#### (1) Enable SAN

```bash
docker run --rm -v $PWD/certs:/certs -u $(id -u):$(id -g) -e ALLOWED="DNS:docker.example.com,IP:1.2.3.4,IP:5.6.7.8" javisabalete/docker-engine-tls
```

#### (2) Change RSA and CA_L

```bash
docker run --rm -v $PWD/certs:/certs -u $(id -u):$(id -g) -e RSA="8192" -e CA_L="Tarragona" javisabalete/docker-engine-tls
```
