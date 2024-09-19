#!/bin/bash


#check version
#https://github.com/icp4a/cert-kubernetes
if [[ "$CP4BA_VERSION" == "" ]]; then
    echo "CP4BA_VERSION environment variable is missing"
    echo "See https://github.com/icp4a/cert-kubernetes"
    echo "and then, for example:"
    echo "export CP4BA_VERSION=24.0.0-IF001"
    exit 1
fi

echo "Cloning cert-kubernetes repository to dir $CP4BA_VERSION..."

mkdir $CP4BA_VERSION

cd  $CP4BA_VERSION
git clone -b $CP4BA_VERSION https://github.com/icp4a/cert-kubernetes
cd ..

echo "Cloning cert-kubernetes repository to dir $CP4BA_VERSION...done."
echo "Directory $CP4BA_VERSION/cert-kubernetes/scripts includes scripts to be used to install CP4BA"