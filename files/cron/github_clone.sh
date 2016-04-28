#!/bin/bash
# cronjob script voor sync op sjefkeschelm ks files
# 28-04-2016 mhj initail setup
puppet_source=https://github.com/relybv/beng-rely.git
role=site
if [ -d "/etc/puppet.orig" ]; then
  rm -rf /etc/puppet.orig
fi

if [ -d "/etc/puppet" ]; then
  mv /etc/puppet /etc/puppet.orig
fi

echo "Cloning $puppet_source" 
env GIT_SSL_NO_VERIFY=true git clone $puppet_source /etc/puppet
while [ $? -ne 0 ]; do
  echo "Git failed, trying.."
  if [ -d "/etc/puppet" ]; then
    rm -rf /etc/puppet
  fi
  env GIT_SSL_NO_VERIFY=true git clone $puppet_source /etc/puppet
done

