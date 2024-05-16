#!/bin/bash

function install() {
	# 检查 go 是否已安装
    if ! command -v go &> /dev/null
    then
            echo 'go未安装，新增开始执行安装......'
            # Download the Go installer
            wget https://go.dev/dl/go1.22.0.linux-amd64.tar.gz
            # Extract the archive
            sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.22.0.linux-amd64.tar.gz
            # Add /usr/local/go/bin to the PATH environment variable by adding the following line to your ~/.profile.
            export PATH=$PATH:/usr/local/go/bin
    fi
	bash <(curl -fsSL https://raw.githubusercontent.com/movemntdev/M1/main/scripts/install.sh) --latest
	source .bashrc
	movement manage install m1 testnet
	screen -dmS Movement bash -c 'movement ctl start m1 testnet'
}

function install_docker() {


	# 检查 Docker 是否已安装
	if ! command -v docker &> /dev/null
	then
	    # 如果 Docker 未安装，则进行安装
	    echo "未检测到 Docker，正在安装..."
	    sudo apt-get install ca-certificates curl gnupg lsb-release

	    # 添加 Docker 官方 GPG 密钥
	    sudo mkdir -p /etc/apt/keyrings
	    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

	    # 设置 Docker 仓库
	    echo \
	      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
	      $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

	    # 授权 Docker 文件
	    sudo chmod a+r /etc/apt/keyrings/docker.gpg
	    sudo apt-get update

	    # 安装 Docker 最新版本
	    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
	else
	    echo "Docker 已安装。"
	fi

	# 检查 Docker Compose 是否已安装
	if ! command -v docker-compose &> /dev/null
	then
	    echo "未检测到 Docker Compose，正在安装..."
	    sudo apt install docker-compose -y
	else
	    echo "Docker Compose 已安装。"
	fi

	bash <(curl -fsSL https://raw.githubusercontent.com/movemntdev/M1/main/scripts/install.sh) --latest
	source .bashrc

	docker pull mvlbs/m1-testnet:latest

	movement ctl start m1 testnet
}

# 查看常规版本节点日志
function check_service_status() {
    screen -r Movement

}

# 主菜单
function main_menu() {
	echo "请选择要执行的操作:"
    echo "1. 安装常规节点"
    echo "2. 查看常规版本节点日志"
    read -p "请输入选项（1-2）: " OPTION

    case $OPTION in
    1) install ;;
	2) check_service_status;;
    *) echo "无效选项。" ;;
    esac
}

# 显示主菜单
main_menu