#!/bin/bash
# Создание пользователей для Minikube (демо через сертификаты)

# Создаём сертификаты пользователей
mkdir -p ~/k8s-users
cd ~/k8s-users

# Пример 1: пользователь для группы dev-viewers
USER1="viewer1"
openssl genrsa -out ${USER1}.key 2048
openssl req -new -key ${USER1}.key -out ${USER1}.csr -subj "/CN=${USER1}/O=dev-viewers"
sudo openssl x509 -req -in ${USER1}.csr -CA ~/.minikube/ca.crt -CAkey ~/.minikube/ca.key -CAcreateserial -out ${USER1}.crt -days 365

# Пример 2: пользователь для группы dev-operators
USER2="operator1"
openssl genrsa -out ${USER2}.key 2048
openssl req -new -key ${USER2}.key -out ${USER2}.csr -subj "/CN=${USER2}/O=dev-operators"
sudo openssl x509 -req -in ${USER2}.csr -CA ~/.minikube/ca.crt -CAkey ~/.minikube/ca.key -CAcreateserial -out ${USER2}.crt -days 365

# Настраиваем kubeconfig для пользователей
kubectl config set-credentials ${USER1} --client-certificate=${USER1}.crt --client-key=${USER1}.key
kubectl config set-credentials ${USER2} --client-certificate=${USER2}.crt --client-key=${USER2}.key

echo " Пользователи ${USER1} и ${USER2} созданы и добавлены в kubeconfig"
