# Linux Skills

### Common

1. 查看硬盘空间使用情况

   ` df -h`

2. 查看内存使用情况

   ` free -m`

3. 查看cpu型号

   `dmesg |grep -i xeon`

4. 列出文件的最后几行

   ` tail -n <numbers> <file-name>`

5. ip vs net-tools

   ![linux ip](https://www.linuxidc.com/upload/2014_06/14060411029186.png)

6. 查看linux类型

   ` cat /proc/version`

   ` uname -a`

   ` cat /etc/issue`

7. 查看文件大小

   ` du -h <file>`

8. rpm安装/卸载

   `rpm -i <package.rpm>`

   ``` shell
   rpm -qa|grep -i <target>
   rpm -e target
   ```

9. [sed](./sed.md)

10. [awk](./awk.md)

11. 创建ssh免密登录

    client-ip---------->>server-ip

    1. 在client上生成密钥` ssh-keygen`
    2. 将生成的公钥复制到server的~/.ssh/authorized_keys中
    3. 测试` ssh root@server-ip`

### SUSE

1. 移除repo

   `zypper rr <repo-id>`
