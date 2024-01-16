import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import pandas as pd


file_path = '/home/zhengxd/blaze/test_bandwidth/cpu/data/mutli/X2900P/data.csv'  # filename
df = pd.read_csv(file_path, delimiter=',')

fig, ax1 = plt.subplots(figsize=(8, 4))


ax1.set_xlabel('Runtime')
ax1.set_ylabel('CPU %Util', color='black')
line1=ax1.plot(df['Runtime'], df['CPU'], linewidth=2, color='black', label='CPU')
ax1.tick_params(axis='y', labelcolor='black')
# ax1.set_ylim(0, 120) 
# 设置 y 轴范围，保留一定长度的空间在最大刻度线上
buffer_space = 0.2  # 调整这个值来保留的空间大小
y1_max = max(df['CPU']) * (1 + buffer_space)
ax1.set_ylim(0, y1_max)

ax2 = ax1.twinx()
ax2.set_ylabel('Bandwidth MB/s', color='red')
line2=ax2.plot(df['Runtime'], df['Bandwidth'], linewidth=2, color='red', label='Bandwidth')
ax2.tick_params(axis='y', labelcolor='red')
# 设置 y 轴范围，保留一定长度的空间在最大刻度线上
buffer_space = 0.2  # 调整这个值来保留的空间大小
y2_max = max(df['Bandwidth']) * (1 + buffer_space)
ax2.set_ylim(0, y2_max)

border_width = 2.0  # 调整这个值来设置绘图区边框线条的宽度

# 调整左侧轴的边框
ax1.spines['top'].set_linewidth(border_width)
ax1.spines['right'].set_linewidth(border_width)
ax1.spines['bottom'].set_linewidth(border_width)
ax1.spines['left'].set_linewidth(border_width)

plt.title('cpu-bandwidth')
fig.tight_layout()
lines = line1 + line2
labels = [line.get_label() for line in lines]
plt.legend(lines, labels, loc='lower right')


ax2.axhline(y=7200, color='red',linewidth=4, linestyle='--')
ax2.text(len(df)+1, 7900, 'X2900P Max Bandwidth', color='red', va='top', ha='right',fontsize=12,
          bbox=dict(facecolor='white', edgecolor='white', boxstyle='round,pad=0.3'))

# plt.show()

plt.savefig('/home/zhengxd/blaze/test_bandwidth/cpu/bfs_read_bw_cpu.png')