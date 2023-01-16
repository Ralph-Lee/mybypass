#!/usr/bin/bash -e
#
# 50 */1 * * * update-bypass-domain.sh > log.update-bypass-domain.log

echo '-----------------------------------------'
if [[ $(id -u) -eq 0 ]]; then echo 'Please DONOT run as [root].'; exit 1; fi
echo '-----------------------------------------'

ORI_PATH="${PWD}"
MY_NG_PATH='/opt/www.vhosts.com/wiki.lantonet.com'
BYPASS_PATH='/home/bl/github/proxy-bypass'
CN_DOMAIN_FILENAME='china_domain.txt'
CN_CIDR4_FILENAME='china_cidr4.txt'
CN_CIDR6_FILENAME='china_cidr6.txt'

echo "CURRENT PATH: ${PWD}"
echo "cd to new path of git repo..."
cd $BYPASS_PATH/
echo "CURRENT PATH: ${PWD}"

if [[ ! -r "$CN_DOMAIN_FILENAME" ]]; then echo 'ERROR: $CN_DOMAIN_FILENAME file can not read!'; exit 1; fi

OLD_FILE_SHA1ID=$(/usr/bin/git rev-parse HEAD:${CN_DOMAIN_FILENAME})
/usr/bin/git pull --ff --ff-only
NEW_FILE_SHA1ID=$(/usr/bin/git rev-parse HEAD:${CN_DOMAIN_FILENAME})

if [ "$OLD_CRL_SHA1ID" == "$NEW_CRL_SHA1ID" ] ; then
    echo '-----------------------------------------'
    echo "- $CN_DOMAIN_FILENAME NOT CHANGE, EXIT. -"
    echo '-----------------------------------------'
    #exit 0
fi

if [[ ! -r "$CN_DOMAIN_FILENAME" ]]; then echo 'ERROR: $CN_DOMAIN_FILENAME file can not read!'; exit 1; fi
if [[ ! -r "$CN_CIDR4_FILENAME" ]]; then echo 'ERROR: $CN_CIDR4_FILENAME file can not read!'; exit 1; fi
if [[ ! -r "$CN_CIDR6_FILENAME" ]]; then echo 'ERROR: $CN_CIDR6_FILENAME file can not read!'; exit 1; fi

echo '-----------------------------------------'
echo "- $CN_DOMAIN_FILENAME CHANGED, UPDATE...."
echo '-----------------------------------------'
sudo cp -f $CN_DOMAIN_FILENAME $ORI_PATH/
sudo cp -f $CN_CIDR4_FILENAME $ORI_PATH/
sudo cp -f $CN_CIDR6_FILENAME $ORI_PATH/
cd $ORI_PATH && echo "CURRENT PATH: ${PWD}"
ITEMP=${PWD}/tmp.txt
cat $PWD/mydomain.txt | tee $ITEMP > /dev/null
cat ${PWD}/$CN_DOMAIN_FILENAME | tee -a $ITEMP > /dev/null
sudo cp -f $ITEMP $MY_NG_PATH/$CN_DOMAIN_FILENAME
cat $PWD/mycidr4.txt | tee $ITEMP > /dev/null
cat $PWD/$CN_CIDR4_FILENAME | tee -a $ITEMP > /dev/null
sudo cp -f $ITEMP $MY_NG_PATH/$CN_CIDR4_FILENAME
cat $PWD/mycidr6.txt | tee $ITEMP > /dev/null
cat $PWD/$CN_CIDR6_FILENAME | tee -a $ITEMP > /dev/null
sudo cp -f $ITEMP $MY_NG_PATH/$CN_CIDR6_FILENAME
echo '' | tee $ITEMP
echo '-----------------------------------------'
sudo chown -R vampire:vampire /opt/www.vhosts.com/
sudo chmod 755 -R /opt/www.vhosts.com/
exit 0
