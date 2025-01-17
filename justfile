set dotenv-load
set dotenv-required

bootlin_url := "https://toolchains.bootlin.com/downloads/releases/toolchains"
local_toolchain_path := `pwd`
lib := "glibc"
release := "stable"
date := "2024.05-1"
postfix := "--" + lib + "--" + release + "-" + date

_download url:
  wget --no-clobber -P {{local_toolchain_path}} {{url}}
_unzip file:
  tar --skip-old-files -xvf {{file}} -C {{local_toolchain_path}}
_arch_get url dir:
  #!/usr/bin/env bash
  if [[ ! -d {{dir}} ]]; then
    just _download {{url}}
    just _unzip "{{dir}}.tar.xz"
  fi
_arch_clean dir:
  rm -rfv {{dir}} {{dir}}.tar.xz
_arch_env tool_path arch cross_compile:
  PATH="{{ tool_path }}/bin:$PATH" ARCH={{arch}} CROSS_COMPILE={{cross_compile}} zsh

# Download architecture [arch]
arch_wget arch:
  just _arch_get \
    {{bootlin_url}}/${{arch}}_name/tarballs/${{arch}}_name{{postfix}}.tar.xz \
    {{local_toolchain_path}}/${{arch}}_name{{postfix}}

# Remove architecture [arch]
arch_clean arch:
  just _arch_clean \
    {{local_toolchain_path}}/${{arch}}_name{{postfix}}

# Set env variable for architecture [arch]
arch_env arch:
  just _arch_env \
    {{local_toolchain_path}}/${{arch}}_name{{postfix}} \
    ${{arch}}_arch_name ${{arch}}_cross_compile

# List available architectures
arch_list:
  for arch in ${ALL_ARCH}; do \
    echo $arch; \
  done

# Download all architectures
arch_wget_all:
  for arch in ${ALL_ARCH}; do \
    just arch_wget $arch; \
  done

# Clean all the architectures
arch_clean_all:
  for arch in ${ALL_ARCH}; do \
    just arch_clean $arch; \
  done

