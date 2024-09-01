import numpy as np
import matplotlib.pyplot as plt
from matplotlib import font_manager

# 加载本地 Times New Roman 字体文件
font_path = '/usr/share/fonts/truetype/msttcorefonts/Times_New_Roman.ttf'  # 替换为字体文件的实际路径
font_prop = font_manager.FontProperties(fname=font_path)
# 定义加速比计算函数
def speedup(K, beta, n):
    return 1 / ((1 - K) + (1-beta) * K + beta * K / n)

# 设定变量范围
K = np.linspace(0.1, 0.9, 100)  # 内核态占比
beta = np.linspace(0.1, 0.9, 100)  # 内核态不可并行部分比例
K, beta = np.meshgrid(K, beta)  # 创建网格

# 计算加速比
n = 64  # 并行度
S = speedup(K, beta, n)

# 绘制等高线图
plt.figure(figsize=(4.2, 3))
# viridis tab10 Oranges
contour = plt.contourf(K, beta, S, levels=10, cmap='YlGnBu',vmin=1, vmax=4)
# contour = plt.contour(K, beta, S, levels=30, cmap='Oranges')  # 使用简单线条绘制等高线

# 添加点和注释
x_point = 0.75
y_point = 0.80
plt.scatter(x_point, y_point, color='red', zorder=5)  # 绘制点
plt.text(x_point, y_point, 'Hitchhike in FIO (2.46x)', color='red', fontsize=12, ha='right', va='top', zorder=30,fontproperties=font_prop)  # 添加注释


plt.colorbar(contour, label='Speedup(α)')
plt.xlabel('Kernel Space Proportion (K)',fontsize=10,fontproperties=font_prop)
plt.ylabel('Batched Proportion (β)',fontsize=10,fontproperties=font_prop)
plt.title('Contour Plot of Speedup(α) vs. K and β (when n = 64)',fontsize=10,fontproperties=font_prop)
plt.tight_layout()

# Display the plot
plt.savefig('amdahl.pdf')
