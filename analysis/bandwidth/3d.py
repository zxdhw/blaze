import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

# 创建一个图形对象和3D坐标轴对象
fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')

# 定义变量范围
K = np.linspace(0.1, 0.9, 100)  # 内核态占比范围
alpha = np.linspace(0.1, 0.9, 100)  # 内核态中不可并行部分的比例范围
n = 10  # 固定并行度

K, alpha = np.meshgrid(K, alpha)
S = 1 / ((1 - K) + alpha * K + ((1 - alpha) * K) / n)  # 计算加速比

# 绘制表面图
surf = ax.plot_surface(K, alpha, S, cmap='tab10', edgecolor='none')

# 添加色条
fig.colorbar(surf, ax=ax, shrink=0.5, aspect=10)

# 设置标签
ax.set_xlabel('Kernel Space Proportion (K)')
ax.set_ylabel('Non-parallelizable Kernel Part (alpha)')
ax.set_zlabel('Speedup (S)')
# ax.set_title('3D Surface Plot of Speedup vs. Kernel Space Proportion and Non-parallelizable Kernel Part')

# Display the plot
plt.savefig('amdahl.pdf')
