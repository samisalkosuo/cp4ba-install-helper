#!/bin/bash


#check version
#https://github.com/IBM/cloud-pak/blob/master/repo/case/ibm-cp-automation
if [[ "$CP4BA_CASE_VERSION" == "" ]]; then
    echo "CP4BA_CASE_VERSION environment variable is missing"
    echo "See https://github.com/IBM/cloud-pak/blob/master/repo/case/ibm-cp-automation"
    echo "and then:"
    echo "export CP4BA_CASE_VERSION=5.1.3"
    exit 1
fi

echo "Downloading and extracting CP4BA case version $CP4BA_CASE_VERSION..."

mkdir $CP4BA_CASE_VERSION

cd $CP4BA_CASE_VERSION

wget https://github.com/IBM/cloud-pak/raw/master/repo/case/ibm-cp-automation/${CP4BA_CASE_VERSION}/ibm-cp-automation-${CP4BA_CASE_VERSION}.tgz

tar -xf ibm-cp-automation-${CP4BA_CASE_VERSION}.tgz

cp ibm-cp-automation/inventory/cp4aOperatorSdk/files/deploy/crs/*.tar .
tar -xf *tar

cd ..

echo "Downloading and extracting CP4BA case version $CP4BA_CASE_VERSION...done."

echo "Directory $CP4BA_CASE_VERSION/cert-kubernetes/scripts includes scripts to be used to install CP4BA"