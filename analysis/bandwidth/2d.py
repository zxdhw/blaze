import numpy as np
import matplotlib.pyplot as plt

# 定义加速比计算函数
def amdahl_law(K, alpha, n):
    return 1 / ((1 - K) + alpha * K + (1 - alpha) * K / n)

# 参数设置
K = 0.7  # 内核态占比
alpha = 0.2  # 内核态不可并行部分比例
n_values = np.arange(1, 128)  # 并行度（批次大小）从 1 到 20

# 计算加速比
S_values = amdahl_law(K, alpha, n_values)

# 绘制二维曲线图
plt.figure(figsize=(10, 6))
plt.plot(n_values, S_values, marker='o')
plt.xlabel('p(n)')
plt.ylabel('(S(n))')
plt.title(f'amdahl')
plt.grid(True)

# Display the plot
plt.savefig('amdahl.pdf')
