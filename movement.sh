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

# 查看常规版本节点日志
function check_service_status() {
    screen -r Movement
}

function get_node_status() {
	curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"info.isBootstrapped",
    "params": {
        "chain":"X"
    }
	}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/info
}

function get_node_id() {
	curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"info.getNodeID"
	}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/info
}

# 主菜单
function main_menu() {
	echo "请选择要执行的操作:"
    echo "1. 安装常规节点"
    echo "2. 查看常规版本节点日志"
    echo "3. 获取节点ID"
    echo "4. 获取节点状态"
    read -p "请输入选项（1-2）: " OPTION

    case $OPTION in
    1) install ;;
	2) check_service_status;;
	3) get_node_id;;
	4) get_node_status;;
    *) echo "无效选项。" ;;
    esac
}

# 显示主菜单
main_menu