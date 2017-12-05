install_snort:
    file.recurse:
      - name: /opt/snort_install
      - source: salt://snort
      - user: root 
      - file_mode: 644
      - dir_mode: 755
      - mkdir: True
      - clean: True
    pkg.installed:
      - pkgs:
        - gcc
        - flex
        - bison
        - zlib
        - zlib-devel
        - libpcap
        - libpcap-devel
        - pcre
        - pcre-devel
        - libdnet
        - libdnet-devel
        - tcpdump
    cmd.script:
      - source: salt://snort/snort_env.sh
      - user: root
