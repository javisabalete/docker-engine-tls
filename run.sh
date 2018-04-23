#!/bin/bash

CA="/C=${CA_C:-US}/ST=${CA_ST:-CoolState}/L=${CA_L:-NiceCity}/O=${CA_O:-Docker}/OU=${CA_OU:-Docker}/CN=${CA_CN:-Docker}"
SERVER=${SERVER:-docker.example.com}
CLIENTS=${CLIENTS:-"Docker-Client"}
ALLOWED=${ALLOWED:-""}
OUTPUT="certs"

#mkdir -p "${OUTPUT}"
#cd "${OUTPUT}"

#CA
umask 177
env LC_CTYPE=C < /dev/urandom tr -dc "+=\-%*\!&#':;{}()[]|^~\$_0-9a-zA-Z" | head -c99 > ca.pass

openssl genrsa -aes256 -passout file:ca.pass -out ca-key.pem ${RSA:-4096}
openssl req -new -x509 -days ${CA_EXPIRE_DAYS:-"365"} -key ca-key.pem -sha256 -passin file:ca.pass -out ca.pem -subj "${CA}"

#SERVER
openssl genrsa -out server-key.pem ${RSA:-4096}
openssl req -subj "/CN=${SERVER}" -sha256 -new -key server-key.pem -out server.csr

EXTFILE="extendedKeyUsage = serverAuth"
[ ! -z "$ALLOWED" ] && EXTFILE="$EXTFILE\nsubjectAltName = ${ALLOWED}"
openssl x509 -req -days ${SERVER_EXPIRE_DAYS:-"365"} -sha256 -in server.csr -passin file:ca.pass -CA ca.pem -CAkey ca-key.pem \
  -CAcreateserial -out server-cert.pem -extfile <(echo -e "${EXTFILE}")

#CLIENT
openssl genrsa -out key.pem ${RSA:-4096}
openssl req -subj "/CN=${CLIENTS}" -new -key key.pem -out client.csr

EXTFILE="extendedKeyUsage = clientAuth"
openssl x509 -req -days ${CLIENT_EXPIRE_DAYS:-"365"} -sha256 -in client.csr -passin file:ca.pass -CA ca.pem -CAkey ca-key.pem \
  -CAcreateserial -out cert.pem -extfile <(echo -e "${EXTFILE}")

#PREPARE
rm -v client.csr server.csr ca.pass ca.srl
chmod -v 0400 ca-key.pem key.pem server-key.pem
chmod -v 0444 ca.pem server-cert.pem cert.pem

