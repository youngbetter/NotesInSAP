# awk 操作实例

[awk的官方手册](http://www.gnu.org/software/gawk/manual/gawk.html)

[TOC]

net.log

1 unix  3    STREAM     CONNECTED     136354   
2 unix  3    STREAM     CONNECTED     32901    /run/systemd/journal/stdout
3 unix  3    STREAM     CONNECTED     32824    /run/user/1000/bus
4 unix  3    STREAM     CONNECTED     26542    /run/user/1000/bus
5 unix  3    STREAM     CONNECTED     238200   
6 unix  3    STREAM     CONNECTED     31311    /run/systemd/journal/stdout
7 unix  2    DGRAM                    86494    
8 unix  3    STREAM     CONNECTED     31085    /run/user/1000/bus
9 unix  3    STREAM     CONNECTED     32194    

### 内建变量

| key      | description                                            |
| -------- | ------------------------------------------------------ |
| $0       | 当前记录（这个变量中存放着整个行的内容）               |
| $1~$n    | 当前记录的第n个字段，字段间由FS分隔                    |
| FS       | 输入字段分隔符 默认是空格或Tab                         |
| NF       | 当前记录中的字段个数，即列的数目                       |
| NR       | 已经处理的记录数，即行号，若多个文件，值不断累加       |
| FNR      | 当前记录数，与NR不同的是，这个值会是各个文件自己的行号 |
| RS       | 输入的记录分隔符， 默认为换行符                        |
| OFS      | 输出字段分隔符， 默认也是空格                          |
| ORS      | 输出的记录分隔符，默认为换行符                         |
| FILENAME | 当前输入文件的名字                                     |

### 打印

1. 打印指定列内容

   ```shell
   # 打印第1，2，3列内容
   awk '{print $1,$2,$3}' net.log
   ```

2. 以指定格式打印

   ```shell
   # 格式打印和c语言相似
   awk '{printf "%-4s,%-10s,%-10s\n",$1,$2,$3}' net.log
   ```

3. 打印行号

   ```shell
   # 将行号打印出来
   awk '{print NR,$1,$2,$3}' net.log
   ```

4. 指定分隔符

   ```shell
   # 默认分隔符是空格或者tab，指定分隔符为/
   awk 'BEGIN {FS="/"} {print NR,$1,$2}' net.log
   # or
   awk -F/ '{print NR,$1,$2}' net.log
   ```

5. 指定输出分隔符

   ```shell
   # 默认分隔符是空格
   awk '{print NR,$1,$2}' OFS="\t" net.log
   ```

### 筛选

1. 字符串匹配

   ```shell
   # 除第一行以外，对指定列内容进行匹配
   awk '$3 ~ /DGR.*/ || NR==1 {print NR,$1,$2}' net.log
   # or 像grep用法
   awk '/DGRAM/' net.log
   # 比较运算符 ==, >, <, >=, <=
   ```

2. 反匹配

   ```shell
   # 指定列内容进行反匹配即筛除
   awk '$3 !~ /DGR.*/{print NR,$1,$2}' net.log
   # or 像grep用法
   awk '!/DGRAM/' net.log
   # 比较运算符 ==, >, <, >=, <=
   ```

### 拆分

1. 文件拆分

   ```shell
   # 按指定列内容进行拆分，拆分结果以列内容为文件名保存在同目录下
   awk '{print > $3}' net.log
   # 将指定列内容重定向到按指定列内容进行拆分文件中
   awk '{print NR,$1,$2 > $3}' net.log
   # 使用if-else
   awk '{ if($3 ~ /DGRAM/) print > "D.txt";
   else print > "S.txt"}' net.log
   ```

### 统计

1. 统计文件大小总和

   ```shell
   ls -l  *.cpp *.c | awk '{sum+=$5} END {print sum}'
   ```

2. 统计用户进程占用内存情况

   ```shell
   ps aux | awk 'NR!=1{a[$1]+=$6;} END { for(i in a) print i ", " a[i]"KB";}'
   ```
