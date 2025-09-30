include $(TOPDIR)/rules.mk

PKG_NAME:=minivtun
PKG_VERSION:=1.0.20230708
PKG_RELEASE:=2023-07-08

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/rssnsj/minivtun.git
PKG_SOURCE_VERSION:=d7007bd
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_SOURCE_VERSION)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_SOURCE_VERSION).tar.xz

PKG_LICENSE:=GPLv3
PKG_LICENSE_FILES:=COPYING
PKG_MAINTAINER:=lixingcong<lixingcong@live.com>

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)/$(BUILD_VARIANT)/$(PKG_NAME)-$(PKG_VERSION)-$(PKG_SOURCE_VERSION)

PKG_USE_MIPS16:=0
PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk

define Package/minivtun
	SECTION:=net
	CATEGORY:=Network
	TITLE:=A simple tun based on openssl
	URL:=https://github.com/rssnsj/minivtun
	DEPENDS:=+ip +libopenssl
endef

define Package/minivtun/description
A simple tun based on openssl
endef

MAKE_PATH:=src

define Package/minivtun/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/minivtun $(1)/usr/sbin/
endef


$(eval $(call BuildPackage,minivtun))
