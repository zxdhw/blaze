# 打开文件并读取内容
file_path = '/home/zhengxd/blaze/sh/bin.txt'  # 将 'your_file.txt' 替换为实际的文件路径
with open(file_path, 'r') as file:
    lines = file.readlines()

# 初始化数字计数字典
number_counts = {}

# 遍历每行并统计数字出现的次数
for line in lines:
    try:
        number = int(line.strip())
        # print(f"{number}")
        if 0 <= number <= 4096:
            number_counts[number] = number_counts.get(number, 0) + 1
            # number_counts[number] = number_counts[number] + 1
    except ValueError:
        pass  # 忽略无法转换为整数的行

# 打印数字及其出现次数
for number, count in sorted(number_counts.items()):
    print(f"{number}: {count} ")