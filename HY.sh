#!/bin/bash

while true; do
    clear

    echo -e "\033[96m___________________ "
    echo "|__|       \_/  "
    echo "|  |        |   "
    echo -e "\033[96m                                   "
    echo "HY一键脚本工具 v0.1（支持Ubuntu，Debian，Centos系统）"
    echo "GitHub项目地址：https://github.com/d24f1/HY-shell-script"
    echo "------------------------"
    echo "1. 系统信息查询"
    echo "2. 系统更新"
    echo "3. 系统清理"
    echo "4. BBR内核管理"
    echo "5. 各种测试脚本合集"
    echo "6. 安装WARP解锁ChatGPT Netflix Disney+"
    echo "7. Docker安装"
    echo "8. 一键搭建幻兽帕鲁服务端管理"
    echo "------------------------"
    echo "0. 退出脚本"
    echo "------------------------"
    read -p "请输入你的选择: " choice


 case $choice in
  1)
    clear
    # 函数: 获取IPv4和IPv6地址
    ip_address

    if [ "$(uname -m)" == "x86_64" ]; then
      cpu_info=$(cat /proc/cpuinfo | grep 'model name' | uniq | sed -e 's/model name[[:space:]]*: //')
    else
      cpu_info=$(lscpu | grep 'BIOS Model name' | awk -F': ' '{print $2}' | sed 's/^[ \t]*//')
    fi

    if [ -f /etc/alpine-release ]; then
        # Alpine Linux 使用以下命令获取 CPU 使用率
        cpu_usage_percent=$(top -bn1 | grep '^CPU' | awk '{print " "$4}' | cut -c 1-2)
    else
        # 其他系统使用以下命令获取 CPU 使用率
        cpu_usage_percent=$(top -bn1 | grep "Cpu(s)" | awk '{print " "$2}')
    fi


    cpu_cores=$(nproc)

    mem_info=$(free -b | awk 'NR==2{printf "%.2f/%.2f MB (%.2f%%)", $3/1024/1024, $2/1024/1024, $3*100/$2}')

    disk_info=$(df -h | awk '$NF=="/"{printf "%s/%s (%s)", $3, $2, $5}')

    country=$(curl -s ipinfo.io/country)
    city=$(curl -s ipinfo.io/city)

    isp_info=$(curl -s ipinfo.io/org)

    cpu_arch=$(uname -m)

    hostname=$(hostname)

    kernel_version=$(uname -r)

    congestion_algorithm=$(sysctl -n net.ipv4.tcp_congestion_control)
    queue_algorithm=$(sysctl -n net.core.default_qdisc)

    # 尝试使用 lsb_release 获取系统信息
    os_info=$(lsb_release -ds 2>/dev/null)

    # 如果 lsb_release 命令失败，则尝试其他方法
    if [ -z "$os_info" ]; then
      # 检查常见的发行文件
      if [ -f "/etc/os-release" ]; then
        os_info=$(source /etc/os-release && echo "$PRETTY_NAME")
      elif [ -f "/etc/debian_version" ]; then
        os_info="Debian $(cat /etc/debian_version)"
      elif [ -f "/etc/redhat-release" ]; then
        os_info=$(cat /etc/redhat-release)
      else
        os_info="Unknown"
      fi
    fi

    output=$(awk 'BEGIN { rx_total = 0; tx_total = 0 }
        NR > 2 { rx_total += $2; tx_total += $10 }
        END {
            rx_units = "Bytes";
            tx_units = "Bytes";
            if (rx_total > 1024) { rx_total /= 1024; rx_units = "KB"; }
            if (rx_total > 1024) { rx_total /= 1024; rx_units = "MB"; }
            if (rx_total > 1024) { rx_total /= 1024; rx_units = "GB"; }

            if (tx_total > 1024) { tx_total /= 1024; tx_units = "KB"; }
            if (tx_total > 1024) { tx_total /= 1024; tx_units = "MB"; }
            if (tx_total > 1024) { tx_total /= 1024; tx_units = "GB"; }

            printf("总接收: %.2f %s\n总发送: %.2f %s\n", rx_total, rx_units, tx_total, tx_units);
        }' /proc/net/dev)


    current_time=$(date "+%Y-%m-%d %I:%M %p")


    swap_used=$(free -m | awk 'NR==3{print $3}')
    swap_total=$(free -m | awk 'NR==3{print $2}')

    if [ "$swap_total" -eq 0 ]; then
        swap_percentage=0
    else
        swap_percentage=$((swap_used * 100 / swap_total))
    fi

    swap_info="${swap_used}MB/${swap_total}MB (${swap_percentage}%)"

    runtime=$(cat /proc/uptime | awk -F. '{run_days=int($1 / 86400);run_hours=int(($1 % 86400) / 3600);run_minutes=int(($1 % 3600) / 60); if (run_days > 0) printf("%d天 ", run_days); if (run_hours > 0) printf("%d时 ", run_hours); printf("%d分\n", run_minutes)}')

    echo ""
    echo "系统信息查询"
    echo "------------------------"
    echo "主机名: $hostname"
    echo "运营商: $isp_info"
    echo "------------------------"
    echo "系统版本: $os_info"
    echo "Linux版本: $kernel_version"
    echo "------------------------"
    echo "CPU架构: $cpu_arch"
    echo "CPU型号: $cpu_info"
    echo "CPU核心数: $cpu_cores"
    echo "------------------------"
    echo "CPU占用: $cpu_usage_percent%"
    echo "物理内存: $mem_info"
    echo "虚拟内存: $swap_info"
    echo "硬盘占用: $disk_info"
    echo "------------------------"
    echo "$output"
    echo "------------------------"
    echo "网络拥堵算法: $congestion_algorithm $queue_algorithm"
    echo "------------------------"
    echo "公网IPv4地址: $ipv4_address"
    echo "公网IPv6地址: $ipv6_address"
    echo "------------------------"
    echo "地理位置: $country $city"
    echo "系统时间: $current_time"
    echo "------------------------"
    echo "系统运行时长: $runtime"
    echo

    ;;

  2)
    clear

    # Update system on Debian-based systems
    if [ -f "/etc/debian_version" ]; then
        apt update -y && DEBIAN_FRONTEND=noninteractive apt full-upgrade -y
    fi

    # Update system on Red Hat-based systems
    if [ -f "/etc/redhat-release" ]; then
        yum -y update
    fi

    # Update system on Alpine Linux
    if [ -f "/etc/alpine-release" ]; then
        apk update && apk upgrade
    fi


    ;;

  3)
    clear
    clean_debian() {
        apt autoremove --purge -y
        apt clean -y
        apt autoclean -y
        apt remove --purge $(dpkg -l | awk '/^rc/ {print $2}') -y
        journalctl --rotate
        journalctl --vacuum-time=1s
        journalctl --vacuum-size=50M
        apt remove --purge $(dpkg -l | awk '/^ii linux-(image|headers)-[^ ]+/{print $2}' | grep -v $(uname -r | sed 's/-.*//') | xargs) -y
    }

    clean_redhat() {
        yum autoremove -y
        yum clean all
        journalctl --rotate
        journalctl --vacuum-time=1s
        journalctl --vacuum-size=50M
        yum remove $(rpm -q kernel | grep -v $(uname -r)) -y
    }

    clean_alpine() {
        apk del --purge $(apk info --installed | awk '{print $1}' | grep -v $(apk info --available | awk '{print $1}'))
        apk autoremove
        apk cache clean
        rm -rf /var/log/*
        rm -rf /var/cache/apk/*

    }

    # Main script
    if [ -f "/etc/debian_version" ]; then
        # Debian-based systems
        clean_debian
    elif [ -f "/etc/redhat-release" ]; then
        # Red Hat-based systems
        clean_redhat
    elif [ -f "/etc/alpine-release" ]; then
        # Alpine Linux
        clean_alpine
    fi

    ;;   
        4)
            clear
            # 安装 wget（如果需要）
            if ! command -v wget &>/dev/null; then
                if command -v apt &>/dev/null; then
                    apt update -y && apt install -y wget
                elif command -v yum &>/dev/null; then
                    yum -y update && yum -y install wget
                else
                    echo "未知的包管理器!"
                    exit 1
                fi
            fi
            wget --no-check-certificate -O tcpx.sh https://raw.githubusercontent.com/ylx2016/Linux-NetSpeed/master/tcpx.sh
            chmod +x tcpx.sh
            ./tcpx.sh
            ;;
        5)
            while true; do
                echo " ▼ "
                echo "测试脚本合集"
                echo "------------------------"
                echo "1. ChatGPT解锁状态检测"
                echo "2. 流媒体解锁测试"
                echo "3. TikTok状态检测"
                echo "4. 三网回程延迟路由测试"
                echo "5. 三网回程线路测试"
                echo "6. 三网专项测速"
                echo "7. VPS性能专项测试"
                echo "8. VPS性能全局测试"
                echo "------------------------"
                echo "0. 返回主菜单"
                echo "------------------------"
                read -p "请输入你的选择: " sub_choice

                case $sub_choice in
                    1)
                        clear
                        bash <(curl -Ls https://cdn.jsdelivr.net/gh/missuo/OpenAI-Checker/openai.sh)
                        ;;
                    2)
                        clear
                        bash <(curl -L -s media.ispvps.com)
                        ;;
                    3)
                        clear
                        wget -qO- https://github.com/yeahwu/check/raw/main/check.sh | bash
                        ;;
                    4)
                        clear
                        wget -qO- git.io/besttrace | bash
                        ;;
                    5)
                        clear
                        curl https://raw.githubusercontent.com/zhanghanyun/backtrace/main/install.sh -sSf | sh
                        ;;
                    6)
                        clear
                        bash <(curl -Lso- https://bench.im/hyperspeed)
                        ;;
                    7)
                        clear
                        curl -sL yabs.sh | bash -s -- -i -5
                        ;;
                    8)
                        clear
                        wget -qO- bench.sh | bash
                        ;;
                    0)
                        break
                        ;;
                    *)
                        echo "无效的输入!"
                        ;;
                esac
                echo -e "\033[0;32m操作完成\033[0m"
                echo "按任意键继续..."
                read -n 1 -s -r -p ""
                echo ""
                clear
            done
            ;;
        6)
            clear
            # 安装 wget（如果需要）
            if ! command -v wget &>/dev/null; then
                if command -v apt &>/dev/null; then
                    apt update -y && apt install -y wget
                elif command -v yum &>/dev/null; then
                    yum -y update && yum -y install wget
                else
                    echo "未知的包管理器!"
                    exit 1
                fi
            fi
            wget -N https://gitlab.com/fscarmen/warp/-/raw/main/menu.sh && bash menu.sh [option] [lisence/url/token]
            ;;
        7) 
            clear
            if command -v docker &>/dev/null; then
                echo "Docker已安装。"
            else
                # 在Debian/Ubuntu上安装Docker
                if command -v apt &>/dev/null; then
                    apt update -y
                    apt install -y docker.io
                    systemctl start docker
                    systemctl enable docker
                # 在CentOS上安装Docker
                elif command -v yum &>/dev/null; then
                    yum install -y yum-utils
                    yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
                    yum install -y docker-ce
                    systemctl start docker
                    systemctl enable docker
                else
                    echo "未知的包管理器!"
                    exit 1
                fi
                echo "Docker已成功安装。"
            fi
            ;;
        8)
            while true; do
                echo " ▼ "
                echo "不支持Arm架构，推荐Debian11 12 Ubuntu20.04 22.04系统"
                echo "------------------------"
                echo "1. 境外机运行一键脚本"
                echo "2. 国内机运行一键脚本"
                echo "------------------------"
                echo "0. 返回主菜单"
                echo "------------------------"
                read -p "请输入你的选择: " sub_choice

                case $sub_choice in
                    1)
                        clear
                        curl -o palinstall.sh https://raw.githubusercontent.com/miaowmint/palworld/main/install.sh && chmod +x palinstall.sh && bash palinstall.sh
                        ;;
                    2)
                        clear
                        curl -o palinstall.sh https://blog.iloli.love/install.sh && chmod +x palinstall.sh && bash palinstall.sh
                        ;;
                    0)
                        break
                        ;;
                    *)
                        echo "无效的输入!"
                        ;;
                esac
                echo -e "\033[0;32m操作完成\033[0m"
                echo "按任意键继续..."
                read -n 1 -s -r -p ""
                echo ""
                clear
            done
            ;;
        0)
            clear
            echo "感谢您使用我们的脚本。再见!"
            exit 0
            ;;
        *)
            clear
            echo "错误: 无效的选项，请重新输入."
            ;;
    esac
done
