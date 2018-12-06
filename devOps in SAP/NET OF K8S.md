# K8S 网络

[TOC]

### Docker

1. 命名空间

   1. namespace 是Linux内核为了支持网络协议栈的多个实例而引入的技术；Docker利用namespace的特性，实现了容器之间的网络隔离，彼此之间无法进行通信。

2. Veth 设备对

   1. Veth 设备对是为了在不同的namespace之间进行通信而引入的。
   2. Veth 成对出现。

3. 网桥

   1. 网桥是连接异种网络的一种二层虚拟网络设备，将不同的网络接口连接起来，使得网口之间的报文可以相互转发。
   2. Linux网桥和一般的网桥不同，最大差别在于该网桥具有IP地址。

4. Iptables / Netfilter

   1. Iptables / Netfilter 是Linux提供的用于解决用户自定义数据包处理的机制，通过挂接点函数钩子的形式，可在网络协议栈处理数据包的过程中对数据包进行过滤、修改、丢弃等操作。

   2. 可挂载规则点（蓝色）

      ![1543302327587](https://github.com/youngbetter/pichub/blob/master/notes/1543302327587.png)

   3. 查看系统中已有的规则表

      ```shell
      iptables-save
      iptables-vnL
      ```

5. 路由

   1. IP层依据路由表来决定数据转发或者发送的目的。
   2. 路由表条目内容
      1. 目的IP
      2. 下一跳IP
      3. 标志（提供诸如下一跳是路由器还是主机等重要信息）
      4. 网络接口规范
   3. Linux路由表至少包含LOCAL和MAIN两个表

6. Docker网络实现

   1. 标准docker支持下面4类网络模式：

      1. --net=host
      2. --net=container:NAME_OR_ID
      3. --net=none
      4. bridge模式下

   2. bridge模式下

      Docker Daemon首次启动时会创建一个虚拟的网桥（docker0），然后按照PRC1918模型，在私有网络空间给该网桥分配一个子网。由Docker创建出来的container，都会创建一个Veth设备对（一端关联到网桥上，另一端映射到容器内的eth0设备，然后从网桥地址段给eth0分配一个IP地址。

7. 局限

   1. 同一主机上的container可以相互通信，不同主机上的container不能互相通信
   2. 若要跨节点通信，则需要在主机地址上分配端口，然后通过这个端口路由或者代理到容器上，需要协调号端口的使用，做法较为麻烦且容易出错，也可使用动态端口技术，但其复杂性很大。

### K8S

1. 概述

   1. IP per Pod model

      每个Pod拥有一个独立的IP，所有Pod（不论是否在同一个Node上）都可以直接通过对方的IP进行访问。

      同一Pod内的容器共享同一网络协议栈，彼此可通过localhost+端口进行访问。

   2. k8s 对集群的网络要求

      1. 所有Pod都可以在不用NAT的方式下同其他Pod通信
      2. 所有Node都可以在不用NAT的方式下同其他Pod通信，反之亦然
      3. Pod内服务看到的地址和别人看到的地址是同一地址

2. 通信实现

   1. 容器到容器之间的通信

      由于在同一pod之中的container是共享同一个namespace的（这些container不会跨宿主机），所以这些container之间可以通过本地IPC进行通信，互相之间甚至可以使用localhost+port来进行访问

   2. Pod之间的通信

      1. 同一Node

         在同一Node上的pod都是通过Veth连接到docker0网桥的，其IP由docker0的网段分配，所以可以直接通信

      2. 不同Node

         由于docker0网段和宿主机的物理网卡是处于两个不同的网段，因此位于不同宿主机上的两个pod想要通信，必须是先通过这两个宿主机的物理网卡，然后由宿主机的网卡再将数据包转发给docker0。

         k8s的网络模型要求，pod之间是按私有IP来进行通信的，这些私有IP由k8s分配，并保证分配不存在冲突，这些分配的IP存储在etcd中；为pod分配了IP之后，还需要一种机制将这些pod IP和Node IP关联起来，为了达到这个目的，有不少开源应用用来增强k8s的网络，如flannel等网络插件。

         ![1543307978475](https://github.com/youngbetter/pichub/blob/master/notes/1543307978475.png)

   3. Pod和Service之间的通信

      k8s创建Service时，会为其分配一个虚拟的IP地址，即为ClusterIP，client通过访问ClusterIP来访问内部组件。实质上具体访问内部的工作都是kube-proxy来完成的。kube-proxy担负着透明代理和负载均衡的角色，其实就是将某个访问service的请求，通过一套算法和规则转发给后端的pod，这里说的算法就是Round Robin负载均衡算法和session粘连规则。可通过修改service里面的service.spec.sessionAffinity参数的值来实现会话保持特的定向转发。

      总之，不管是clusterIP+targetPort，还是NodeIP+NodePort，都会被Iptables规则重新定向到kube-proxy监听服务的代理端口。

      ![1543308192511](https://github.com/youngbetter/pichub/blob/master/notes/1543308192511.png)

   4. 集群外部与内部组件之间的通信

      1. NodeIP+NodePort

         这种方式就是直接在宿主机上打开一个端口，用来访问集群内部服务。

      2. loadBalance

         使用外部云服务提供商的负载均衡器。

      外部请求访问内部服务，Iptables为设置Nodeport规则，将对Service的访问转接到kube-proxy作为负载均衡器，然后经过负载均衡算法进入到pod中。
