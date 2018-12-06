# sed 操作实例

[sed 的官方手册](http://www.gnu.org/software/sed/manual/sed.html)

[TOC]

**sed 基于正则表达式**

```markdown
# lang.txt
1. my name is c++
2. born in 1983.
3. my name is java
4. born in 1995.
5. my name is python
6. born in 1991.
```

### s替换

1. 全文范围替换指定内容

   ```shell
   # my -> its
   sed "s/my/its/g" lang.txt
   # 上述命令只是将替换后的内容输出
   # g表示替换一整行
   # 如果想要修改源文件的内容，使用 -i 参数或者使用输出重定向
   sed -i "s/my/its/g" lang.txt
   sed "s/my/its/g" lang.txt > lang_new.txt
   ```

2. 指定行替换指定内容

   ```shell
   # 将第三行的name替换为NAME
   sed "3s/name/NAME/g" lang.txt
   # 将第1~3行的name替换为NAME
   sed "1,3s/name/NAME/g" lang.txt
   # 每行行首添加#
   sed "s/^/#/g" lang.txt
   # 每行行尾添加****
   sed "s/$/#/g" lang.txt
   ```

3. 指定行中的指定顺序替换内容

   ```shell
   # 替换每一行的第二个m为M
   sed "s/m/M/2" lang.txt
   ```

4. 匹配多个模式

   ```shell
   # my->its && born->developed
   sed "s/my/its/g; s/born/developed/g" lang.txt
   # 或者使用 -e 参数
   sed -e "s/my/its/g" -e "s/born/developed/g" lang.txt
   ```

5. N命令

   ```shell
    # N:把下一行的内容放进缓冲区与当前行一起做匹配
    # 将原文变成
    # my name is c++, born in 1983.
    # my name is java, born in 1995.
    # my name is python, born in 1991.
    sed "N;s/\n/, /g" lang.txt
   ```

6. 将匹配内容作为变量使用

   ```shell
   # 使用()获取正则匹配的组
   # 将上文变为
   # c++	1983
   # java	1995
   # python	1991
   sed "s/.* is \(.*\),.* in \([0-9]*\)./\1\t\2/g" lang.txt
   ```

### a添加 && i插入

a: append && i: insert 用于添加一行，a：行后追加 VS i：行前插入

1. 在指定行添加

   ```shell
   # 在第一行前插入
   sed "1 i my name is c." lang.txt
   # 在第一行后追加
   sed "1 a my name is c." lang.txt
   # 在每一行后追加
   sed "1,$ a ################" lang.txt
   ```

2. 在匹配行添加

   ```shell
   # 在匹配到java的那一行后面追加
   sed "/java/ a my name is oak." lang.txt
   ```

### d删除

```shell
# 删除指定行
sed "1 d" lang.txt
# 删除匹配行
sed "/j.*a/ d" lang.txt
```

### c替换

```shell
# 替换指定行
sed "1 c my name is c." lang.txt
# 替换匹配行
sed "/j.*a/ c my name is javaScript." lang.txt
```

### p打印

```shell
# 使用-n参数
# 打印指定行
sed -n "1 p" lang.txt
# 打印匹配的行
sed -n "/j.*a/ p" lang.txt
# 打印从起点行到匹配成功的行
sed -n "1,/j.*a/ p" lang.txt
```