# ~/.ipython/profile_default/startup/

import os
import sys
import time
import datetime as dt
from pathlib import Path
from itertools import product, islice
from functools import partial

# --- 核心科学计算 ---
import numpy as np
import pandas as pd
import scipy as sp
import networkx as nx
from tqdm.auto import tqdm  # 进度条神器

# --- 深度学习生态 (PyTorch + JAX/Keras3) ---
import torch
import torch.nn as nn
import torch.nn.functional as F

import jax
import jax.numpy as jnp
import equinox as eqx
import keras  # Keras 3 支持 multi-backend (jax, torch, tensorflow)

# --- 可视化 ---
import matplotlib as mpl
import matplotlib.pyplot as plt

# --- 配置设定 ---
pd.options.display.max_columns = 100
pd.options.display.max_rows = 100

plt.style.use('ggplot')
plt.rcParams.update({
    'font.sans-serif': ['SimHei', 'Arial Unicode MS'], # 兼容中文字体
    'axes.unicode_minus': False,
    'figure.figsize': (12, 8),
    'figure.dpi': 120
})

# --- 快捷函数 ---
def dt_now(): return dt.datetime.now().strftime("%Y-%m-%d %H:%M:%S")

def xuan_cal(ref_date=(1, 12, 22)):
    """玄历计算 (现代化重构)"""
    from datetime import datetime
    yF, mF, dF = ref_date
    now = datetime.now()
    delta_days = (now - datetime(yF, mF, dF)).days
    
    year, rem = divmod(delta_days, 365.242199)
    month, day = divmod(rem, 30)
    return int(year) + 1, int(month), int(day), delta_days

# --- 实用数学/数据函数 ---
def logis(x): return 1 / (1 + np.exp(-x))
def logit(p): return np.log(p) - np.log(1 - p)

def pca_simple(data, n_comp=3):
    """简易 PCA 实现"""
    from sklearn.decomposition import PCA
    model = PCA(n_components=n_comp)
    return model.fit_transform(data)

def quick_plot(formula, x_range=(-5, 5), points=500):
    """快速绘制 y = f(x)"""
    x = np.linspace(x_range[0], x_range[1], points)
    # 处理 formula 中的安全计算
    y = eval(formula.replace('=', ':').split(':')[-1], {"np": np, "x": x})
    plt.plot(x, y)
    plt.title(f"Plot: {formula}")
    plt.show()

# --- 初始化打印 ---
def _welcome():
    y, m, d, total = xuan_cal()
    print(f"🚀 Environment Loaded | {dt_now()}")
    print(f"📅 Xuan: Year {y}, Month {m}, Day {day} (Total: {total} days)")
    print(f"📦 Backends: PyTorch {torch.__version__} | JAX {jax.__version__} | Keras {keras.__version__}")

if __name__ == "__main__": _welcome()
