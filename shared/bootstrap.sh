#!/usr/bin/env bash
# Create swap, since image only has 512 MB
echo 'Creating swap file.'
fallocate -l 512M /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo '/swapfile none swap defaults 0 0' >> /etc/fstab

echo "Adding vagrant user to users group"
usermod -a -G users vagrant

export LANG=C.UTF-8

# Upgrade Ubuntu
echo 'Upgrading Ubuntu'
apt-get update
apt-get upgrade -y

echo 'Ensuring desired locales are available.'
locale-gen ar_OM.UTF-8 ar_SY.UTF-8 id_ID.UTF-8 bs_BA.UTF-8 bg_BG.UTF-8 ca_ES.UTF-8 cs_CZ.UTF-8 zh_CN.UTF-8 zh_TW.UTF-8 da_DK.UTF-8 de_DE.UTF-8 en_US.UTF-8 en_GB.UTF-8 en_CA.UTF-8 es_ES.UTF-8 et_EE.UTF-8 eu_ES.UTF-8 fr_FR.UTF-8 gl_ES.UTF-8 el_GR.UTF-8 he_IL.UTF-8 hr_HR.UTF-8 is_IS.UTF-8 it_IT.UTF-8 ja_JP.UTF-8 ko_KR.UTF-8 lv_LV.UTF-8 lt_LT.UTF-8 mk_MK.UTF-8 hu_HU.UTF-8 nl_NL.UTF-8 nb_NO.UTF-8 nn_NO.UTF-8 pl_PL.UTF-8 pt_PT.UTF-8 pt_BR.UTF-8 ro_RO.UTF-8 ru_RU.UTF-8 sk_SK.UTF-8 sl_SI.UTF-8 fi_FI.UTF-8 sv_SE.UTF-8 th_TH.UTF-8 uk_UA.UTF-8

echo 'Installing expect.'
apt-get -y install expect

echo "Installing Apache"
apt-get -y install apache2 libcurl4-openssl-dev libpcre3-dev

echo "Insatlling Aspell"
apt-get -y install aspell

