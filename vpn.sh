#!/usr/bin/bash

cd
apt update & sudo apt upgrade -y

echo "wellcome choose work"
echo "install x-ui = 1"
echo "install tunnel = 2"
echo "install certificate = 3"
read var7

if [[ "$var7" == "1" ]]; then
    # Define default variables
    var1="y"
    var2="samir"
    var3="Mazandaran21@"
    var4="1400"
    # Pipe the variables to the second script
    echo -e "$var1\n$var2\n$var3\n$var4" | bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh)

elif [[ "$var7" == "2" ]]; then
    
    echo "127.0.0.1 $(hostname)" >> /etc/hosts
    
    # Disable IPv6 by updating sysctl configuration
    echo "Disabling IPv6..."

    # Add necessary settings to disable IPv6
    sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1
    sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1
    sudo sysctl -w net.ipv6.conf.lo.disable_ipv6=1

    # Make changes permanent by adding to /etc/sysctl.conf
    echo "Making IPv6 disable permanent..."

    # Check if the lines already exist, if not, add them
    grep -qxF 'net.ipv6.conf.all.disable_ipv6 = 1' /etc/sysctl.conf || echo 'net.ipv6.conf.all.disable_ipv6 = 1' | sudo tee -a /etc/sysctl.conf
    grep -qxF 'net.ipv6.conf.default.disable_ipv6 = 1' /etc/sysctl.conf || echo 'net.ipv6.conf.default.disable_ipv6 = 1' | sudo tee -a /etc/sysctl.conf
    grep -qxF 'net.ipv6.conf.lo.disable_ipv6 = 1' /etc/sysctl.conf || echo 'net.ipv6.conf.lo.disable_ipv6 = 1' | sudo tee -a /etc/sysctl.conf

    # Reload sysctl to apply the changes
    sudo sysctl -p

    echo "IPv6 has been disabled."

    # Check and ensure IPv4 is enabled
    echo "Ensuring IPv4 is enabled..."

    ipv4_status=$(sysctl net.ipv4.ip_forward | awk '{print $3}')

    if [ "$ipv4_status" -eq 1 ]; then
        echo "IPv4 is already enabled."
    else
        # Enable IPv4 forwarding (optional, depending on your needs)
        sudo sysctl -w net.ipv4.ip_forward=1
        echo "IPv4 has been enabled."
    fi

    # Final verification
    echo "Verifying the status of IPv4 and IPv6..."
    sysctl net.ipv4.ip_forward
    sysctl net.ipv6.conf.all.disable_ipv6

    echo "IPv4 is enabled, and IPv6 is disabled."

    # BBR
    sudo modprobe tcp_bbr
    lsmod | grep bbr
    echo "net.core.default_qdisc=fq" | sudo tee -a /etc/sysctl.conf
    echo "net.ipv4.tcp_congestion_control=bbr" | sudo tee -a /etc/sysctl.conf
    sudo sysctl -p
    sysctl net.ipv4.tcp_congestion_control
    sysctl net.ipv4.tcp_available_congestion_control
    
    # Ask the user a Yes/No question
    echo "choose server : iran=1 , kharej=2"
    read var6
    
    # Check the user's response
    if [[ "$var6" == "1" ]]; then
        rm /etc/resolv.conf
        touch /etc/resolv.conf
        echo "nameserver 8.8.8.8" >> /etc/resolv.conf
        echo "nameserver 4.2.2.4" >> /etc/resolv.conf
        var11="2"
        var12="1"
        var13="no"
        var14="5.4"
        var16="qwer"
        var17="no"
        echo "SNI Domain = "
        read var15
        echo -e "$var11" | bash <(curl -Ls https://raw.githubusercontent.com/radkesvat/ReverseTlsTunnel/master/scripts/RtTunnel.sh)
        echo -e "$var12\n$var13\n$var14\n$var6\n$var15\n$var16\n$var17" | bash <(curl -Ls https://raw.githubusercontent.com/radkesvat/ReverseTlsTunnel/master/scripts/RtTunnel.sh)

    elif [[ "$var6" == "2" ]]; then
        rm /etc/resolv.conf
        touch /etc/resolv.conf
        echo "nameserver 1.1.1.1" >> /etc/resolv.conf
        echo "nameserver 1.0.0.1" >> /etc/resolv.conf
        var11="2"
        var12="1"
        var13="no"
        var14="5.4"
        var16="qwer"
        var17="no"
        echo "SNI Domain = "
        read var15
        echo "IP Iran = "
        read var18
        echo -e "$var11" | bash <(curl -Ls https://raw.githubusercontent.com/radkesvat/ReverseTlsTunnel/master/scripts/RtTunnel.sh)
        echo -e "$var12\n$var13\n$var14\n$var6\n$var15\n$var18\n$var16" | bash <(curl -Ls https://raw.githubusercontent.com/radkesvat/ReverseTlsTunnel/master/scripts/RtTunnel.sh)

    else
        echo "Invalid response. Please enter 1 or 2."
    fi

elif [[ "$var7" == "3" ]]; then
    echo "subdomain = "
    read var8
    sudo apt install certbot python3-certbot-nginx
    sudo certbot --nginx -d "$var8"
    sudo certbot renew --dry-run
else
    echo "Invalid response. Please enter 1 or 2 or 3"
fi