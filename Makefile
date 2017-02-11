#
# Copyright (C) 2006-2015 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk

PKG_NAME:=suricata
PKG_VERSION:=3.2

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=http://www.openinfosecfoundation.org/download/
PKG_MD5SUM:=05854b3390ea86fabe73bdb5a90db36c

PKG_FIXUP:=autoreconf
PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/nls.mk

define Package/suricata
    SUBMENU:=Firewall
    SECTION:=net
    CATEGORY:=Network
    DEPENDS:=+libyaml +libpcap +libpcre +libgeoip +jansson +libnetfilter-queue +libmagic +libnfnetlink +libpthread +zlib $(ICONV_DEPENDS)
    TITLE:=OISF Suricata IDS
    URL:=https://www.openinfosecfoundation.org/
endef

CONFIGURE_ARGS = \
	--prefix="/usr" \
    --sysconfdir="/etc" \
	--enable-nfqueue \
	--enable-gccprotect \
	--enable-debug \
	--enable-geoip \
	--enable-pie \

define Package/suricata/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/suricata $(1)/usr/bin/suricata

	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/*.so* $(1)/usr/lib

	$(INSTALL_DIR) $(1)/etc/suricata
	$(CP) \
        $(PKG_BUILD_DIR)/suricata.yaml \
        $(PKG_BUILD_DIR)/classification.config \
        $(PKG_BUILD_DIR)/threshold.config \
        $(PKG_BUILD_DIR)/reference.config \
        $(1)/etc/suricata/
	$(INSTALL_DIR) $(1)/etc/suricata/rules
	$(CP) $(PKG_BUILD_DIR)/rules/*.rules $(1)/etc/suricata/rules/
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/suricata.init $(1)/etc/init.d/suricata
	$(INSTALL_DIR) $(1)/etc/suricata
	$(CP) ./files/suricata.yaml $(1)/etc/suricata/
endef

$(eval $(call BuildPackage,suricata))
