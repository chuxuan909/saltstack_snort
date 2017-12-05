                这是saltstack自动部署snort的sls文件
1. 将insnort.sls文件  snort目录 复制到/srv/salt目录下（yum 安装salt-master）
2. 修改top.sls文件，添加insnort

执行模块：salt '*'  state.sls insnort