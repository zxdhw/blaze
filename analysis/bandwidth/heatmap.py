import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np
import pandas as pd
from matplotlib.patches import Rectangle
from matplotlib import font_manager

# 加载本地 Times New Roman 字体文件
font_path = '/usr/share/fonts/truetype/msttcorefonts/Times_New_Roman.ttf'  # 替换为字体文件的实际路径
font_prop = font_manager.FontProperties(fname=font_path)
font_title = font_manager.FontProperties(fname=font_path, size=14)

# Example data in matrix form (replace this with your actual data)
data = np.array([[1.73, 1.74, 2.37, 2.26],
                 [2.28, 2.20, 2.29, 2.16],
                 [1.95, 1.82, 2.36, 2.41],
                 [1.66, 1.66, 2.34, 2.22],
                 [2.04,	1.80, 1.97, 2.17],
                 [2.38, 2.38, 2.49, 2.34]])

# Create a Pandas DataFrame for easier labeling
df = pd.DataFrame(data, 
                  index=["friendster","rmat27", "rmat30", "sk2005","twitter","uran27"], 
                  columns=["BFS", "BC", "WCC", "PR"])

df = df.T

# Initialize the matplotlib figure
plt.figure(figsize=(5, 3),dpi=200)

# Create a heatmap with annotations   Greens(1.5~3.5) GnBu
ax=sns.heatmap(df, annot=True, cmap="GnBu",vmin=1.5, vmax=4, linewidths=1, linecolor='white',cbar=False,
               annot_kws={"fontproperties": font_title})

ax.add_patch(Rectangle((0, 0), df.shape[1], df.shape[0], fill=False, edgecolor='black', linewidth=1))
# Add titles and labels
plt.title('hitchhike-aio v.s. libaio', fontsize=20,fontproperties=font_title)
plt.xlabel('Datasets', fontsize=12,fontproperties=font_prop)
plt.ylabel('Algorithms', fontsize=12,fontproperties=font_prop)
plt.xticks(fontproperties=font_prop)  # x轴刻度
plt.yticks(fontproperties=font_prop)  # y轴刻度
plt.tight_layout()

# Display the plot
# plt.show()
plt.savefig('blaze.pdf')
