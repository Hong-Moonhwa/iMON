export LD_LIBRARY_PATH=/root/lib
rdate -s time.bora.net
./fleet-provisioning --endpoint a1diue5dwjnn4d-ats.iot.ap-northeast-2.amazonaws.com --ca_file ./AmazonRootCA1.pem --cert ./claim_certificate.pem.crt --key ./claim_private.pem.key --template_name test-provisioning-template --template_parameters '{"SerialNumber":"iMON","ThingName":"iMON"}'
sync
