#!/bin/bash

while true; do
    clear

    echo -e "\033[96m██████╗ ███████╗ ██████╗ ██████╗ ████████╗███████╗"
    echo -e "\033[96m██╔══██╗██╔════╝██╔════╝██╔═══██╗╚══██╔══╝██╔════╝"
    echo -e "\033[96m██████╔╝█████╗  ██║     ██║   ██║   ██║   ███████╗"
    echo -e "\033[96m██╔══██╗██╔══╝  ██║     ██║   ██║   ██║   ╚════██║"
    echo -e "\033[96m██████╔╝███████╗╚██████╗╚██████╔╝   ██║   ███████║"
    echo -e "\033[96m╚═════╝ ╚══════╝ ╚═════╝ ╚═════╝    ╚═╝   ╚══════╝"
    echo -e "\033[0m"
    echo -e "\033[1mHY一键脚本工具 v0.4\033[0m"
    echo -e "（支持Ubuntu，Debian，Centos系统）\n"
    echo -e "\033[4mGitHub项目地址：\033[0m\033[96mhttps://github.com/d24f1/HY-shell-script\033[0m"
    echo -e "\033[4mTG官方交流群：\033[0m\033[96mhttps://t.me/hosting_global\033[0m\n"
    echo -e "\033[1m------------------------\033[0m"
    echo -e "\033[32m1. 系统信息查询"
    echo "2. 系统更新"
    echo "3. 系统清理"
    echo "4. BBR内核管理"
    echo "5. 各种测试脚本合集 ▶"
    echo "6. 安装WARP解锁ChatGPT Netflix Disney+"
    echo "7. Docker管理 ▶"
    echo "8. 一键搭建幻兽帕鲁服务端管理 ▶"
    echo "9. 甲骨文云脚本合集 ▶"
    echo "10. Linux系统重装 ▶"
    echo -e "\033[1m------------------------\033[0m"
    echo "0. 退出脚本"
    echo -e "\033[1m------------------------\033[0m\n"
    read -p "请输入你的选择: " choice  

    case $choice in
  1)
clear

# 函数: 获取IPv4地址
get_ipv4_address() {
    ipv4_address=$(curl -s https://ipinfo.io/ip)
}

# 函数: 获取IPv6地址
get_ipv6_address() {
    ipv6_address=$(curl -s https://ifconfig.co/)
}

# 函数: 获取系统信息
get_system_info() {
    # 尝试使用 lsb_release 获取系统信息
    if command -v lsb_release >/dev/null 2>&1; then
        os_info=$(lsb_release -ds 2>/dev/null)
    else
        # 如果 lsb_release 命令失败，则尝试其他方法
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
}

# 函数: 获取CPU型号
get_cpu_model() {
    cpu_info=$(cat /proc/cpuinfo | grep "model name" | uniq | awk -F': ' '{print $2}' | sed 's/^[ \t]*//')
    if [ -z "$cpu_info" ]; then
        cpu_info="Unknown"
    fi
}

# 函数: 获取CPU占用率
get_cpu_usage() {
    if [ -f /proc/stat ]; then
        cpu_info=(`cat /proc/stat | grep '^cpu '`)
        total_cpu_usage=0
        for (( i=1; i<${#cpu_info[@]}; i++ )); do
            total_cpu_usage=$((total_cpu_usage + ${cpu_info[$i]}))
        done
        idle_cpu_usage=${cpu_info[4]}
        cpu_usage_percent=$((100 - ((100 * idle_cpu_usage) / total_cpu_usage)))
    else
        cpu_usage_percent="Unknown"
    fi
}

# 获取IPv4地址
get_ipv4_address

# 获取IPv6地址
get_ipv6_address

# 获取系统信息
get_system_info

# 获取CPU型号
get_cpu_model

# 获取CPU占用率
get_cpu_usage

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
echo "公网IPv6地址: $ipv6_address"  # 显示IPv6地址
echo "------------------------"
echo "地理位置: $country $city"
echo "系统时间: $current_time"
echo "------------------------"
echo "系统运行时长: $runtime"
echo

# 添加等待用户输入以确认是否退出
read -p "按任意键退出..."
    ;;

  2)
clear

clear

# 函数: 更新Debian系系统
update_debian() {
    if [ -f "/etc/debian_version" ]; then
        apt update -y && DEBIAN_FRONTEND=noninteractive apt full-upgrade -y
    fi
}

# 函数: 更新CentOS系系统
update_centos() {
    if [ -f "/etc/redhat-release" ]; then
        yum -y update
    fi
}

# 函数: 更新Ubuntu系统
update_ubuntu() {
    if [ -f "/etc/os-release" ]; then
        source /etc/os-release
        if [[ $ID == "ubuntu" ]]; then
            apt update -y && DEBIAN_FRONTEND=noninteractive apt full-upgrade -y
        fi
    fi
}

# 更新系统
update_debian
update_centos
update_ubuntu

# 退出前等待用户按下任意键
read -n 1 -s -r -p "更新已完成。按任意键返回菜单..."
    ;;

  3)
    clear
# 函数: 清理Debian系统
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

# 函数: 清理CentOS系统
clean_centos() {
    yum autoremove -y
    yum clean all
    journalctl --rotate
    journalctl --vacuum-time=1s
    journalctl --vacuum-size=50M
    yum remove $(rpm -q kernel | grep -v $(uname -r)) -y
}

# 函数: 清理Ubuntu系统
clean_ubuntu() {
    apt autoremove --purge -y
    apt clean -y
    apt autoclean -y
    apt remove --purge $(dpkg -l | awk '/^rc/ {print $2}') -y
    journalctl --rotate
    journalctl --vacuum-time=1s
    journalctl --vacuum-size=50M
    apt remove --purge $(dpkg -l | awk '/^ii linux-(image|headers)-[^ ]+/{print $2}' | grep -v $(uname -r | sed 's/-.*//') | xargs) -y
}

# 清理系统
if [ -f "/etc/debian_version" ]; then
    # Debian系统
    clean_debian
elif [ -f "/etc/redhat-release" ]; then
    # CentOS系统
    clean_centos
elif [ -f "/etc/os-release" ]; then
    source /etc/os-release
    if [[ $ID == "ubuntu" ]]; then
        # Ubuntu系统
        clean_ubuntu
    fi
fi

# 退出前等待用户按下任意键
read -n 1 -s -r -p "清理已完成。按任意键返回菜单..."
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
                echo "7. 全球测速"
                echo "8. 亚洲测速"
                echo "9. VPS性能专项测试"
                echo "10. VPS性能全局测试"
                echo "11. 融合怪测评脚本"
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
                        curl -sL network-speed.xyz | bash
                        ;;
                    8)
                        clear
                        curl -sL network-speed.xyz | bash -s -- -r asia
                        ;;
                    9)
                        clear
                        curl -sL yabs.sh | bash -s -- -i -5
                        ;;
                    10)
                        clear
                        wget -qO- bench.sh | bash
                        ;;
                    11)
                        clear
                        curl -L https://gitlab.com/spiritysdx/za/-/raw/main/ecs.sh -o ecs.sh && chmod +x ecs.sh && bash ecs.sh
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
    while true; do
      clear
      echo "▶ Docker管理器"
      echo "------------------------"
      echo "1. 安装更新Docker环境"
      echo "------------------------"
      echo "2. 查看Dcoker全局状态"
      echo "------------------------"
      echo "3. Dcoker容器管理 ▶"
      echo "4. Dcoker镜像管理 ▶"
      echo "5. Dcoker网络管理 ▶"
      echo "6. Dcoker卷管理 ▶"
      echo "------------------------"
      echo "7. 清理无用的docker容器和镜像网络数据卷"
      echo "------------------------"
      echo "8. 卸载Dcoker环境"
      echo "------------------------"
      echo "0. 返回主菜单"
      echo "------------------------"
      read -p "请输入你的选择: " sub_choice

      case $sub_choice in
          1)
            clear
            install_add_docker

              ;;
          2)
              clear
              echo "Dcoker版本"
              docker --version
              docker-compose --version
              echo ""
              echo "Dcoker镜像列表"
              docker image ls
              echo ""
              echo "Dcoker容器列表"
              docker ps -a
              echo ""
              echo "Dcoker卷列表"
              docker volume ls
              echo ""
              echo "Dcoker网络列表"
              docker network ls
              echo ""

              ;;
          3)
              while true; do
                  clear
                  echo "Docker容器列表"
                  docker ps -a
                  echo ""
                  echo "容器操作"
                  echo "------------------------"
                  echo "1. 创建新的容器"
                  echo "------------------------"
                  echo "2. 启动指定容器             6. 启动所有容器"
                  echo "3. 停止指定容器             7. 暂停所有容器"
                  echo "4. 删除指定容器             8. 删除所有容器"
                  echo "5. 重启指定容器             9. 重启所有容器"
                  echo "------------------------"
                  echo "11. 进入指定容器           12. 查看容器日志           13. 查看容器网络"
                  echo "------------------------"
                  echo "0. 返回上一级选单"
                  echo "------------------------"
                  read -p "请输入你的选择: " sub_choice

                  case $sub_choice in
                      1)
                          read -p "请输入创建命令: " dockername
                          $dockername
                          ;;

                      2)
                          read -p "请输入容器名: " dockername
                          docker start $dockername
                          ;;
                      3)
                          read -p "请输入容器名: " dockername
                          docker stop $dockername
                          ;;
                      4)
                          read -p "请输入容器名: " dockername
                          docker rm -f $dockername
                          ;;
                      5)
                          read -p "请输入容器名: " dockername
                          docker restart $dockername
                          ;;
                      6)
                          docker start $(docker ps -a -q)
                          ;;
                      7)
                          docker stop $(docker ps -q)
                          ;;
                      8)
                          read -p "确定删除所有容器吗？(Y/N): " choice
                          case "$choice" in
                            [Yy])
                              docker rm -f $(docker ps -a -q)
                              ;;
                            [Nn])
                              ;;
                            *)
                              echo "无效的选择，请输入 Y 或 N。"
                              ;;
                          esac
                          ;;
                      9)
                          docker restart $(docker ps -q)
                          ;;
                      11)
                          read -p "请输入容器名: " dockername
                          docker exec -it $dockername /bin/bash
                          break_end
                          ;;
                      12)
                          read -p "请输入容器名: " dockername
                          docker logs $dockername
                          break_end
                          ;;
                      13)
                          echo ""
                          container_ids=$(docker ps -q)

                          echo "------------------------------------------------------------"
                          printf "%-25s %-25s %-25s\n" "容器名称" "网络名称" "IP地址"

                          for container_id in $container_ids; do
                              container_info=$(docker inspect --format '{{ .Name }}{{ range $network, $config := .NetworkSettings.Networks }} {{ $network }} {{ $config.IPAddress }}{{ end }}' "$container_id")

                              container_name=$(echo "$container_info" | awk '{print $1}')
                              network_info=$(echo "$container_info" | cut -d' ' -f2-)

                              while IFS= read -r line; do
                                  network_name=$(echo "$line" | awk '{print $1}')
                                  ip_address=$(echo "$line" | awk '{print $2}')

                                  printf "%-20s %-20s %-15s\n" "$container_name" "$network_name" "$ip_address"
                              done <<< "$network_info"
                          done

                          break_end
                          ;;

                      0)
                          break  # 跳出循环，退出菜单
                          ;;

                      *)
                          break  # 跳出循环，退出菜单
                          ;;
                  esac
              done
              ;;
          4)
              while true; do
                  clear
                  echo "Docker镜像列表"
                  docker image ls
                  echo ""
                  echo "镜像操作"
                  echo "------------------------"
                  echo "1. 获取指定镜像             3. 删除指定镜像"
                  echo "2. 更新指定镜像             4. 删除所有镜像"
                  echo "------------------------"
                  echo "0. 返回上一级选单"
                  echo "------------------------"
                  read -p "请输入你的选择: " sub_choice

                  case $sub_choice in
                      1)
                          read -p "请输入镜像名: " dockername
                          docker pull $dockername
                          ;;
                      2)
                          read -p "请输入镜像名: " dockername
                          docker pull $dockername
                          ;;
                      3)
                          read -p "请输入镜像名: " dockername
                          docker rmi -f $dockername
                          ;;
                      4)
                          read -p "确定删除所有镜像吗？(Y/N): " choice
                          case "$choice" in
                            [Yy])
                              docker rmi -f $(docker images -q)
                              ;;
                            [Nn])

                              ;;
                            *)
                              echo "无效的选择，请输入 Y 或 N。"
                              ;;
                          esac
                          ;;
                      0)
                          break  # 跳出循环，退出菜单
                          ;;

                      *)
                          break  # 跳出循环，退出菜单
                          ;;
                  esac
              done
              ;;

          5)
              while true; do
                  clear
                  echo "Docker网络列表"
                  echo "------------------------------------------------------------"
                  docker network ls
                  echo ""

                  echo "------------------------------------------------------------"
                  container_ids=$(docker ps -q)
                  printf "%-25s %-25s %-25s\n" "容器名称" "网络名称" "IP地址"

                  for container_id in $container_ids; do
                      container_info=$(docker inspect --format '{{ .Name }}{{ range $network, $config := .NetworkSettings.Networks }} {{ $network }} {{ $config.IPAddress }}{{ end }}' "$container_id")

                      container_name=$(echo "$container_info" | awk '{print $1}')
                      network_info=$(echo "$container_info" | cut -d' ' -f2-)

                      while IFS= read -r line; do
                          network_name=$(echo "$line" | awk '{print $1}')
                          ip_address=$(echo "$line" | awk '{print $2}')

                          printf "%-20s %-20s %-15s\n" "$container_name" "$network_name" "$ip_address"
                      done <<< "$network_info"
                  done

                  echo ""
                  echo "网络操作"
                  echo "------------------------"
                  echo "1. 创建网络"
                  echo "2. 加入网络"
                  echo "3. 退出网络"
                  echo "4. 删除网络"
                  echo "------------------------"
                  echo "0. 返回上一级选单"
                  echo "------------------------"
                  read -p "请输入你的选择: " sub_choice

                  case $sub_choice in
                      1)
                          read -p "设置新网络名: " dockernetwork
                          docker network create $dockernetwork
                          ;;
                      2)
                          read -p "加入网络名: " dockernetwork
                          read -p "那些容器加入该网络: " dockername
                          docker network connect $dockernetwork $dockername
                          echo ""
                          ;;
                      3)
                          read -p "退出网络名: " dockernetwork
                          read -p "那些容器退出该网络: " dockername
                          docker network disconnect $dockernetwork $dockername
                          echo ""
                          ;;

                      4)
                          read -p "请输入要删除的网络名: " dockernetwork
                          docker network rm $dockernetwork
                          ;;
                      0)
                          break  # 跳出循环，退出菜单
                          ;;

                      *)
                          break  # 跳出循环，退出菜单
                          ;;
                  esac
              done
              ;;

          6)
              while true; do
                  clear
                  echo "Docker卷列表"
                  docker volume ls
                  echo ""
                  echo "卷操作"
                  echo "------------------------"
                  echo "1. 创建新卷"
                  echo "2. 删除卷"
                  echo "------------------------"
                  echo "0. 返回上一级选单"
                  echo "------------------------"
                  read -p "请输入你的选择: " sub_choice

                  case $sub_choice in
                      1)
                          read -p "设置新卷名: " dockerjuan
                          docker volume create $dockerjuan

                          ;;
                      2)
                          read -p "输入删除卷名: " dockerjuan
                          docker volume rm $dockerjuan

                          ;;
                      0)
                          break  # 跳出循环，退出菜单
                          ;;

                      *)
                          break  # 跳出循环，退出菜单
                          ;;
                  esac
              done
              ;;
          7)
              clear
              read -p "确定清理无用的镜像容器网络吗？(Y/N): " choice
              case "$choice" in
                [Yy])
                  docker system prune -af --volumes
                  ;;
                [Nn])
                  ;;
                *)
                  echo "无效的选择，请输入 Y 或 N。"
                  ;;
              esac
              ;;
          8)
              clear
              read -p "确定卸载docker环境吗？(Y/N): " choice
              case "$choice" in
                [Yy])
                  docker rm $(docker ps -a -q) && docker rmi $(docker images -q) && docker network prune
                  remove docker docker-ce docker-compose > /dev/null 2>&1
                  ;;
                [Nn])
                  ;;
                *)
                  echo "无效的选择，请输入 Y 或 N。"
                  ;;
              esac
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

  9)
     while true; do
      clear
      echo "▶ 甲骨文云脚本合集"
      echo "------------------------"
      echo "1. 安装闲置机器活跃脚本"
      echo "2. 卸载闲置机器活跃脚本"
      echo "------------------------"
      echo "3. DD重装系统脚本"
      echo "4. R探长开机脚本"
      echo "------------------------"
      echo "5. 开启ROOT密码登录模式"
      echo "------------------------"
      echo "0. 返回主菜单"
      echo "------------------------"
      read -p "请输入你的选择: " sub_choice

      case $sub_choice in
          1)
              clear
              echo "活跃脚本: CPU占用10-20% 内存占用15% "
              read -p "确定安装吗？(Y/N): " choice
              case "$choice" in
                [Yy])

                  install_docker

                  docker run -itd --name=lookbusy --restart=always \
                          -e TZ=Asia/Shanghai \
                          -e CPU_UTIL=10-20 \
                          -e CPU_CORE=1 \
                          -e MEM_UTIL=15 \
                          -e SPEEDTEST_INTERVAL=120 \
                          fogforest/lookbusy
                  ;;
                [Nn])

                  ;;
                *)
                  echo "无效的选择，请输入 Y 或 N。"
                  ;;
              esac
              ;;
          2)
              clear
              docker rm -f lookbusy
              docker rmi fogforest/lookbusy
              ;;

          3)
          clear
          echo "请备份数据，将为你重装系统，预计花费15分钟。"
          read -p "确定继续吗？(Y/N): " choice

          case "$choice" in
            [Yy])
              while true; do
                read -p "请选择要重装的系统:  1. Debian12 | 2. Ubuntu20.04 : " sys_choice

                case "$sys_choice" in
                  1)
                    xitong="-d 12"
                    break  # 结束循环
                    ;;
                  2)
                    xitong="-u 20.04"
                    break  # 结束循环
                    ;;
                  *)
                    echo "无效的选择，请重新输入。"
                    ;;
                esac
              done

              read -p "请输入你重装后的密码: " vpspasswd
              install wget
              bash <(wget --no-check-certificate -qO- 'https://raw.githubusercontent.com/MoeClub/Note/master/InstallNET.sh') $xitong -v 64 -p $vpspasswd -port 22
              ;;
            [Nn])
              echo "已取消"
              ;;
            *)
              echo "无效的选择，请输入 Y 或 N。"
              ;;
          esac
              ;;

          4)
              clear
              echo "该功能处于开发阶段，敬请期待！"
              ;;
          5)
              clear
              echo "设置你的ROOT密码"
              passwd
              sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config;
              sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config;
              service sshd restart
              echo "ROOT登录设置完毕！"
              read -p "需要重启服务器吗？(Y/N): " choice
          case "$choice" in
            [Yy])
              reboot
              ;;
            [Nn])
              echo "已取消"
              ;;
            *)
              echo "无效的选择，请输入 Y 或 N。"
              ;;
          esac
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

        10)
            while true; do
                echo " ▼ "
                echo "Linux系统重装"
                echo "------------------------"
                echo "1. KVM价架构机器重装"
                echo "2. OpenVZ/LXC架构机器重装"
                echo "------------------------"
                echo "0. 返回主菜单"
                echo "------------------------"
                read -p "请输入你的选择: " sub_choice

                case $sub_choice in
                    1)

                while true; do
                echo " ▼ "
                echo "KVM价架构机器重装"
                echo "------------------------"
                echo "1. 安装Debian 12"
                echo "2. 安装CentOS 9 stream"
                echo "3. 安装AlmaLinux 9"
                echo "4. 安装RockyLinux 9"
                echo "5. 安装Fedora 39"
                echo "6. Ubuntu 22.04"
                echo "------------------------"
                echo "0. 返回主菜单"
                echo "------------------------"
                read -p "请输入你的选择: " sub_choice

                case $sub_choice in
                    1)
                        clear
                        wget --no-check-certificate -qO InstallNET.sh 'https://raw.githubusercontent.com/leitbogioro/Tools/master/Linux_reinstall/InstallNET.sh' && chmod a+x InstallNET.sh
                        bash InstallNET.sh -debian
                        reboot
                        ;;
                    2)
                        clear
                        wget --no-check-certificate -qO InstallNET.sh 'https://raw.githubusercontent.com/leitbogioro/Tools/master/Linux_reinstall/InstallNET.sh' && chmod a+x InstallNET.sh
                        bash InstallNET.sh -centos
                        reboot
                        ;;
                    3)
                        clear
                        wget --no-check-certificate -qO InstallNET.sh 'https://raw.githubusercontent.com/leitbogioro/Tools/master/Linux_reinstall/InstallNET.sh' && chmod a+x InstallNET.sh
                        bash InstallNET.sh -almalinux
                        reboot
                        ;;
                    4)
                        clear
                        wget --no-check-certificate -qO InstallNET.sh 'https://raw.githubusercontent.com/leitbogioro/Tools/master/Linux_reinstall/InstallNET.sh' && chmod a+x InstallNET.sh
                        bash InstallNET.sh -rockylinux
                        reboot
                        ;;
                    5)
                        clear
                        wget --no-check-certificate -qO InstallNET.sh 'https://raw.githubusercontent.com/leitbogioro/Tools/master/Linux_reinstall/InstallNET.sh' && chmod a+x InstallNET.sh
                        bash InstallNET.sh -fedora
                        reboot
                        ;;
                    6)
                        clear
                        wget --no-check-certificate -qO InstallNET.sh 'https://raw.githubusercontent.com/leitbogioro/Tools/master/Linux_reinstall/InstallNET.sh' && chmod a+x InstallNET.sh
                        bash InstallNET.sh -ubuntu
                        reboot
                        ;;
                
                      0)
                          break  # 跳出循环，退出菜单
                          ;;

                      *)
                          break  # 跳出循环，退出菜单
                          ;;
                  esac
              done
              ;;
                    2)

                while true; do
                echo " ▼ "
                echo "OpenVZ/LXC架构机器重装"
                echo "------------------------"
                echo "1. 硬盘小于1G重装系统"
                echo "2. 硬盘大于1G重装系统"
                echo "------------------------"
                echo "0. 返回主菜单"
                echo "------------------------"
                read -p "请输入你的选择: " sub_choice

                case $sub_choice in
                    1)
                        clear
                        wget -qO OsMutation.sh https://raw.githubusercontent.com/LloydAsp/OsMutation/main/OsMutation.sh && chmod u+x OsMutation.sh && ./OsMutation.sh
                        ;;
                    2)
                        clear
                        wget -qO OsMutation.sh https://raw.githubusercontent.com/LloydAsp/OsMutation/main/OsMutationTight.sh && chmod u+x OsMutation.sh && ./OsMutation.sh
                        ;;

                      0)
                          break  # 跳出循环，退出菜单
                          ;;

                      *)
                          break  # 跳出循环，退出菜单
                          ;;
                  esac
              done
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
