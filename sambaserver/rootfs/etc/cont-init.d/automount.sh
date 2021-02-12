#!/usr/bin/with-contenv bashio
# ==============================================================================
# Mounting drives and modify the smb.conf
# ==============================================================================
readonly CONF="/etc/samba/smb.conf"
declare drives

# Mount external drive
bashio::log.info "Protection Mode is $(bashio::addon.protected)"
if $(bashio::addon.protected) && bashio::config.has_value 'drives' ; then
     bashio::log.warning "Drives option ignored because add-on is in Protected Mode!"
     bashio::config.suggest "protected" "this option only works when Protection mode is disabled"
elif bashio::config.has_value 'drives'; then
     bashio::log.info "Drives option found!"

     DRIVES=$(bashio::config 'drives')
     mount /dev_drives && \
     bashio::log.info "Mounting drives.. ${DRIVES}" && \
     for disk in $DRIVES
     do
         bashio::log.info "Mounting ${disk}"
         mkdir -p /$disk && \
             mount -t auto /dev_drives/disk/by-label/$disk /$disk -o nosuid,relatime,noexec && \
             cat /tmp/drives.smb.conf >> "${CONF}" && \
             sed -i "s|%%DISKNAME%%|${disk}|g" "${CONF}" && \
             bashio::log.info "Success!"   
     done || \
     bashio::log.warning "Unable to mount drives!"
fi
