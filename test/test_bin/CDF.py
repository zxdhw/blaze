import numpy as np
import matplotlib.pyplot as plt


# 读取数据
data_file = '/home/zhengxd/blaze/sh/bin-count.txt'  # 替换为实际的数据文件路径

with open(data_file, 'r') as file:
    data_strings = file.readlines()

# 将字符串数据转换为浮点数
data_numbers = [float(value.strip()) for value in data_strings if value.strip()]

# 计算累积分布函数 (CDF)
sorted_data = np.sort(data_numbers)
cdf = np.arange(1, len(sorted_data) + 1) / len(sorted_data)

# 计算累积分布函数 (CDF)
sorted_data = np.sort(data_numbers)
cdf = np.arange(1, len(sorted_data) + 1) / len(sorted_data)

# 生成CDF图
plt.plot(sorted_data, cdf, label='CDF')
plt.title('Cumulative Distribution Function (CDF)')
plt.xlabel('Values')
plt.ylabel('Probability')
plt.legend()
plt.show()