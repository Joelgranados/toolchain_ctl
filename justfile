bootlin_url := "https://toolchains.bootlin.com/downloads/releases/toolchains"
local_toolchain_path := `pwd`

download url:
  wget --no-clobber -P {{local_toolchain_path}} {{url}}
unzip file:
  tar --skip-old-files -xvf {{file}} -C {{local_toolchain_path}}
arch url dir:
  #!/usr/bin/env bash
  if [[ ! -d {{dir}} ]]; then
    just download {{url}}
    just unzip "{{dir}}.tar.xz"
  fi
arch_clean dir:
  rm -rfv {{dir}} {{dir}}.tar.xz
arch_env tool_path arch cross_compile:
  PATH="{{ tool_path }}/bin:$PATH" ARCH={{arch}} CROSS_COMPILE={{cross_compile}} zsh

x86_32_name := "x86-i686--glibc--stable-2024.05-1"
x86_32_glib_url := bootlin_url / "x86-i686/tarballs" / x86_32_name + ".tar.xz"
x86_32_glib_local := local_toolchain_path / x86_32_name

x86_32:
  just arch {{x86_32_glib_url}} {{x86_32_glib_local}}
x86_32_clean:
  just arch_clean {{x86_32_glib_local}}

sparc_name := "sparc64--glibc--stable-2024.05-1"
sparc_glib_url := bootlin_url / "sparc64/tarballs" / sparc_name + ".tar.xz"
sparc_glib_local := local_toolchain_path / sparc_name

sparc:
  just arch {{sparc_glib_url}} {{sparc_glib_local}}
sparc_clean:
  just arch_clean {{sparc_glib_local}}
sparc_env:
  just arch_env {{ sparc_glib_local }} sparc "sparc64-linux-"

s390_name := "s390x-z13--glibc--stable-2024.05-1"
s390_glib_url := bootlin_url / "s390x-z13/tarballs" / s390_name + ".tar.xz"
s390_glib_local := local_toolchain_path / s390_name

s390:
  just arch {{s390_glib_url}} {{s390_glib_local}}
s390_clean:
  just arch_clean {{s390_glib_local}}
s390_env:
  just arch_env {{ s390_glib_local }} s390 "s390x-linux-"

all: sparc x86_32 s390
clean: sparc_clean x86_32_clean



