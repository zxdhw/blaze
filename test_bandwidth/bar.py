# import matplotlib.pyplot as plt
# import pandas as pd
# # read file
# file_path = '/home/zhengxd/blaze/test/bandwidth/H5300.txt'
# df = pd.read_csv(file_path, sep='\t', index_col=0)
# # get chartname and x_label
# print(df)
# chart_names = df.index[0].split()
# x_labels = df.index[1].split()
# print(df)
# # delete chartname and x_lable
# df = df.iloc[2:]
# print(df)
# # ranspose data
# df = df.transpose()
# print(df)
# # plt
# for chart_name in chart_names:
#     ax = df[chart_name].plot(kind='bar', rot=0, figsize=(10, 6))
    
#     plt.title(chart_name)
#     plt.xlabel('dataset')
#     plt.ylabel('bandwidth')
               
#     ax.set_xticklabels(x_labels)

#     plt.legend(title=chart_name)
#     # plt.show()
#     # plt.axhline(y=7500, color='red', linestyle='--', label='PCIe 5.0 H5300 Bandwidth')
#     # plt.text(len(data) -1, 7500, 'PCIe 5.0 H5300 Bandwidth', color='red', va='bottom', ha='right')
#     # png = chart_name + '_read_bw.png'
#     plt.savefig(png)

import matplotlib.pyplot as plt
import pandas as pd
matplotlib.use('Agg')
# 提供的数据
data = {
    'Datasets': ['rmat27', 'rmat30', 'uran27', 'twitter', 'sk2005', 'friendster'],
    'BFS': [2406, 2443, 2501, 2365, 2365, 2331],
    'PR': [1843, 1717, 1841, 2104, 1816, 1774],
    'WCC': [2528, 2546, 2291, 2505, 2512, 2470],
    'SpMV': [1862, 1526, 1518, 2071, 1414, 1786],
    'BC': [2321, 2260, 2451, 2265, 2299, 2292]
}

# 将数据转换为DataFrame
df = pd.DataFrame(data)

# 设置图表样式
plt.figure(figsize=(10, 6))
bar_width = 0.15
bar_positions = [i for i in range(len(df['Datasets']))]

# 绘制柱状图
plt.bar(bar_positions, df['BFS'], width=bar_width, label='BFS')
plt.bar([pos + bar_width for pos in bar_positions], df['PR'], width=bar_width, label='PR')
plt.bar([pos + 2 * bar_width for pos in bar_positions], df['WCC'], width=bar_width, label='WCC')
plt.bar([pos + 3 * bar_width for pos in bar_positions], df['SpMV'], width=bar_width, label='SpMV')
plt.bar([pos + 4 * bar_width for pos in bar_positions], df['BC'], width=bar_width, label='BC')

# 设置图表标题和标签
plt.title('柱状图示例')
plt.xlabel('数据集')
plt.ylabel('数值')
plt.xticks([pos + 2 * bar_width for pos in bar_positions], df['Datasets'])
plt.legend(title='算法')

# 显示柱状图
# plt.show()
plt.savefig('data.png')