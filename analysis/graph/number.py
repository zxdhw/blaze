import pandas as pd

# 读取没有列名的数据，假设数据存储在一个CSV文件中，文件名为 'data.csv'
data = pd.read_csv('data.txt', header=None, names=['numbers'])

# 创建一个包含数字范围 1~32 的 DataFrame
numbers_range = pd.DataFrame({'numbers': range(1, 33)})

# 统计每个数字出现的次数
counts = data['numbers'].value_counts().reset_index()
counts.columns = ['numbers', 'count']

# 将统计结果与数字范围合并，以确保所有数字都包含在结果中
result = numbers_range.merge(counts, on='numbers', how='left').fillna(0)
result['count'] = result['count'].astype(int)
# 输出结果
# print(result)

# 将结果保存到CSV文件中
result.to_csv('number_counts.csv', index=False)
