                这是saltstack自动部署snort的sls文件
1. 将insnort.sls文件  snort目录 复制到/srv/salt目录下（yum 安装salt-master）
2. 修改top.sls文件，添加insnort
3. snort的内部网络默认是eth0的IP地址，需要修改的请修改snort目录下的snort_env.sh文件内的IP_ADDR变量值
4. local.rules和ddos.rules为自己添加的一些检测web入侵的规矩，已经自动覆盖原来的规则文件（原规则文件为空）
执行模块：salt '*'  state.sls insnort
                关于snort
1.默认已经与后台运行。
2.如需管理，请使用脚本snort.sh
./snort.sh snort start|stop|status|restart