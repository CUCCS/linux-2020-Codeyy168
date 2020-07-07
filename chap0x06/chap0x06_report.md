第六章实验报告
=

实验准备
-
Ubuntu server 18.04(64bit)

实验过程
-

#### 工作主机免密登录目标主机

##### 1.生成并导入SSH-KEY至目标主机

使用指令```ssh-keygen -f foo```在 工作主机 生成ssh-key，key的名称叫做foo

使用指令```sudo vim/etc/ssh/sshd_config```修改 目标主机 配置文件，修改内容如下：
```
PasswordAuthentication yes
PermitRootLogin yes
```
使用指令```sudo systemctl restart ssh```重启 目标主机 的SSH服务

使用指令```ssh-copy-id -i ~/foo root@000.000.00.000```从 工作主机 导入SSH-KEY

##### 2.设置免密登录
使用指令```sudo passwd -l root```取消root口令，并使用指令```vim etc/ssh/sshd_config```修改 目标主机 的配置文件，修改以下内容：
```
PasswordAuthentication no
PermitRootLogin without-password
```
并使用指令```sudo systemctl restart ssh```重启ssh服务

##### 配置文件
[sshd_config](https://github.com/CUCCS/linux-2020-Codeyy168/blob/chap0x06/chap0x06/config/sshd_config)

#### FTP配置
##### 1.配置文件
[vsftpd.sh](https://github.com/CUCCS/linux-2020-Codeyy168/blob/chap0x06/chap0x06/sh/vsftpd.sh)

[vsftpd.conf](https://github.com/CUCCS/linux-2020-Codeyy168/blob/chap0x06/chap0x06/config/vsftpd.conf)

##### 2.远程配置vsftp
将```vsftpd.sh```拷贝到 目标主机

在 工作主机 运行```vsftpd.sh```脚本

配置一个提供匿名访问的FTP服务器，匿名访问者可以访问1个目录且仅拥有该目录及其所有子目录的只读访问权限, 匿名用户拥有且只拥有一个目录,匿名用户对该目录只有只读权限。

配置一个支持用户名和密码方式访问的账号，该账号继承匿名访问者所有权限，且拥有对另1个独立目录及其子目录完整读写（包括创建目录、修改文件、删除文件等）权限

#### NFS配置
##### 1.配置文件
[nfs_c.sh](https://github.com/CUCCS/linux-2020-Codeyy168/blob/chap0x06/chap0x06/sh/nfs_c.sh)

[nfs_s.sh](https://github.com/CUCCS/linux-2020-Codeyy168/blob/chap0x06/chap0x06/sh/nfs_s.sh)

[exports](https://github.com/CUCCS/linux-2020-Codeyy168/blob/chap0x06/chap0x06/config/exports)

##### 2.创建共享目录
在通过 工作主机 运行脚本在 目标主机 安装```vsftpd```并完成相关配置 将```nfs_s.sh```拷贝到 目标主机 ，工作主机 运行```nfs_s.sh```脚本

在 工作主机 运行```nfs_c.sh```脚本

在1台Linux上配置NFS服务，另1台电脑上配置NFS客户端挂载2个权限不同的共享目录，分别对应只读访问和读写访问权限,创建的两个目录分别为:只读```/nfs/gen_r```和读写```/nfs/gen_rw```

#### DHCP配置
##### 1.配置文件
[dhcp.sh](https://github.com/CUCCS/linux-2020-Codeyy168/blob/chap0x06/chap0x06/sh/dhcp.sh)

[dhcpd.conf](https://github.com/CUCCS/linux-2020-Codeyy168/blob/chap0x06/chap0x06/config/dhcpd.conf)

[isc-dhcp-server](https://github.com/CUCCS/linux-2020-Codeyy168/blob/chap0x06/chap0x06/config/isc-dhcp-server)

##### 2.配置过程
配置网卡
client的Internet网卡：
```
 network:
   version: 2
   renderer: networkd
   ethernets:
       enp0s3:
           dhcp4: yes
       enp0s8:
           dhcp4: yes
       enp0s9:
           dhcp4: yes
```

server的Internet网卡：
```
    network:
    version: 2
    renderer: networkd
    ethernets:
        enp0s3:
            dhcp4: yes
        enp0s8:
            dhcp4: yes
        enp0s9:
            dhcp4: no
            addresses: [192.168.57.1/24]
```

配置server：运行脚本

配置client：在/etc/01-netcfg.yaml文件中添加enp0s9,设置dhcp4: yes sudo netplan apply使配置生效

#### 配置DNS
##### 1.配置文件
[head](https://github.com/CUCCS/linux-2020-Codeyy168/blob/chap0x06/chap0x06/config/head)

[server-named.conf.options](https://github.com/CUCCS/linux-2020-Codeyy168/blob/chap0x06/chap0x06/config/server-named.conf.options)

[server-named.conf.local](https://github.com/CUCCS/linux-2020-Codeyy168/blob/chap0x06/chap0x06/config/named.conf.local)

[server-db.cuc.edu.cn](https://github.com/CUCCS/linux-2020-Codeyy168/blob/chap0x06/chap0x06/config/db.cuc.edu.cn)

##### 2.配置过程
使用指令```sudo apt-get install bind9```安装Bind

修改```options```配置文件：
```
    sudo vim /etc/bind/named.conf.options

    listen-on { 192.168.57.1; };
    allow-transfer { none; };
    forwarders {
        8.8.8.8;
        8.8.4.4;
    };
```

编辑配置文件```named.conf.local```:
```
    sudo vim /etc/bind/named.conf.local

    zone "cuc.edu.cn" {
        type master;
        file "/etc/bind/db.cuc.edu.cn";
    };
```

使用指令```sudo cp /etc/bind/db.local /etc/bind/db.cuc.edu.cn```生成配置文件```db.cuc.edu.cn```

编辑配置文件：
```
    ;
    ; BIND data file for local loopback interface
    ;
    $TTL    604800
    ;@      IN      SOA     localhost. root.localhost.(

    @       IN      SOA     cuc.edu.cn. admin.cuc.edu.cn. (
                                2         ; Serial
                            604800         ; Refresh
                            86400         ; Retry
                            2419200         ; Expire
                            604800 )       ; Negative Cache TTL
    ;
    ;@      IN      NS      localhost.
            IN      NS      ns.cuc.edu.cn.
    ns      IN      A       192.168.57.1
    wp.sec.cuc.edu.cn.      IN      A       192.168.57.1
    dvwa.sec.cuc.edu.cn.    IN      CNAME   wp.sec.cuc.edu.cn.
    @       IN      AAAA    ::1
```

使用指令```sudo apt-get update && sudo apt-get install resolvconf```安装```resolvconf```

修改配置文件:
```
    sudo vim /etc/resolvconf/resolv.conf.d/head

    search cuc.edu.cn
    nameserver 192.168.57.1
```