import matplotlib.pyplot as plt

# 从.out文件读取数据
file_path = '/home/zhengxd/blaze/analysis/iostat/bfs_rmat27&uran27.read_bw.log'  # 替换成你的文件路径
with open(file_path, 'r') as file:
    data = [float(line.strip()) for line in file]

# 绘制折线图
plt.plot(data, marker='o', linestyle='-')
plt.xlabel('time/s')
plt.ylabel('bandwidth: MB/s')
plt.title('iostat for bfs(togather)')
plt.grid(True)
# plt.show()
plt.axhline(y=7500, color='red', linestyle='--', label='PCIe 4.0 2900X Bandwidth')
plt.text(len(data) -1, 7500, 'PCIe 4.0 2900X Bandwidth', color='red', va='bottom', ha='right')

plt.savefig('bfs_rmat27&uran27.read_bw.png')