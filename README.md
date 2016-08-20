# phabricator-dockerfile
构建 Phabricator 容器的 DockerFile

# 启动容器后还需配置

1. 添加管理员用户
2. 添加认证类型
3. ./bin/diviner generate 生成内部手册
4. 通过 ./bin/config set phpmailer.xxx 系列变量配置 SMTP 服务器
