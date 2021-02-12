#!/usr/bin/with-contenv bashio
# ==============================================================================
# Umount all drives.
# ==============================================================================
bashio::log.info "Unmount drives."
umount -a
bashio::log.info "Done."
