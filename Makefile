

MODULE_DIR=$(shell pwd)
NGINX_BINARY=$(NGINXHOME)/objs/nginx
NGINX_MAKEFILE=$(NGINXHOME)/Makefile
NGINXHOME=$(MODULE_DIR)/../nginx-1.4.1
NGINX_BIN_INSTALL=$(NGINXHOME)/nginx


DEUBG_FLAGS=-DNDEBUG -g3 -O3
CFLAGS=$(DEUBG_FLAGS) -DH_ENABLE_QLOG -fPIC -pipe -c \
		-Wshadow -Wcast-align -Wwrite-strings -Wsign-compare \
		-Winvalid-pch -fms-extensions -Woverloaded-virtual -Wsign-promo \
		-fno-gnu-keywords -Wfloat-equal -Wextra -Wall -Werror -Wno-unused-parameter \
		-Wno-unused-function -Wunused-variable -Wunused-value \
		-I../include -I $(MODULE_DIR)/qmodule/include\
		-I $(NGINXHOME)/src/core -I $(NGINXHOME)/src/event -I $(NGINXHOME)/src/event/modules \
		-I $(NGINXHOME)/src/os/unix -I $(NGINXHOME)/objs -I $(NGINXHOME)/src/http \
		-I $(NGINXHOME)/src/http/modules -I $(NGINXHOME)/src/mail \
		-I$(NGINX_MODULE_IPDISADM)/qmodule  $(BUSINESS_CFLAGS) \
		-I /home/s/include \
		-I/usr/local/include -MMD 

CXXFLAGS=$(CFLAGS)
LDFLAGS=

CC=gcc
CXX=g++

all : $(NGINX_MAKEFILE) $(NGINX_BINARY)
	cp $(NGINX_BINARY) .

engine : $(TARGET_LIB) 

$(TARGET_LIB) : $(ENGINE_OBJS)
	$(CXX) $^ $(LIBNAME_LDFLAGS) -shared -Wl,-soname,$(TARGET_LIB_MAJOR_NAME) -o $(TARGET_LIB_FULL_NAME) 
	rm -rf $(TARGET_LIB_MAJOR_NAME) ; ln -s $(TARGET_LIB_FULL_NAME) $(TARGET_LIB_MAJOR_NAME)
	if test ! -f $(@);then ln -s $(TARGET_LIB_MAJOR_NAME) $(@);fi
	sudo -u cloud mkdir -p /home/s/apps/CloudSafeLine/service_processor/
	sudo -u cloud cp -rf $(TARGET_LIB_FULL_NAME) /home/s/apps/CloudSafeLine/service_processor/
	cd /home/s/apps/CloudSafeLine/service_processor/ && sudo -u cloud rm -rf $(TARGET_LIB_MAJOR_NAME) && sudo -u cloud ln -s $(TARGET_LIB_FULL_NAME) $(TARGET_LIB_MAJOR_NAME)  
	cd /home/s/apps/CloudSafeLine/service_processor/ && sudo -u cloud rm -rf $(TARGET_LIB) && sudo -u cloud ln -s $(TARGET_LIB_MAJOR_NAME) $(TARGET_LIB) 
	tar zcf $(TARGET_LIB_TAR) $(TARGET_LIB_FULL_NAME) $(TARGET_LIB_MAJOR_NAME) $(TARGET_LIB) 

$(NGINX_MAKEFILE) : config  
	cd $(NGINXHOME); ./configure --prefix=$(NGINX_BIN_INSTALL) --add-module=$(MODULE_DIR) --with-debug

$(NGINX_BINARY) : src/ngx_http_memc_module.c src/ngx_http_memc_request.c src/ngx_http_memc_response.c src/ngx_http_memc_util.c src/ngx_http_memc_handler.c
	$(MAKE) -j -C $(NGINXHOME)
	$(MAKE) install -C $(NGINXHOME)

-include $(DEPS)

clean :
	(cd $(NGINXHOME); $(MAKE) clean)				

.PHONY : clean distclean t sed engine


