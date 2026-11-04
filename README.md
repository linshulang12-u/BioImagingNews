# BioImagingNews

生物光子学成像领域的社区周报网站：多光子、光片、超分辨、OCT、光声、相干拉曼 / SRS、定量相位、内窥、计算成像……只要是光学成像都收。形式与代码框架沿用 [VibraNews](https://github.com/ForestBin-Raman/VibraNews)（ForestBin-Raman），和姊妹站 [FemtoNews](https://linshulang12-u.github.io/FemtoNews/)、[LightFieldNews](https://linshulang12-u.github.io/LightFieldNews/) 共用同一套抓取与选稿流程：**每天自动抓取并发布新论文**，按周归为一期（每周一开新一期），编辑随时可以修改、删除、选特稿。

- 网站：纯静态页面（`index.html`），托管在 GitHub Pages，读取 `data/issues/*.json`
- 抓取：`scraper/news_scraper.py`，数据源为 OpenAlex、Crossref、Europe PMC、arXiv / bioRxiv（免费接口，不需要 API key）
- 自动化：GitHub Actions，每天新加坡时间 06:43 运行（`daily-update.yml`），抓过去 3 天的新论文，直接发布
- 第 1 期（2026-11-02 周）已预置 14 篇 Feature Articles，摘要和 “Why it matters” 由编辑撰写；其余论文由第一次抓取补齐

---

## 收录方向（分类体系）

侧栏 “Modalities & Topics” 按四组分类，点 “中文” 可切换为中文名称。规则全部在 `scraper/config.yaml` 的 `categories`。

| 组 | 分类 |
|---|---|
| 成像模态 Modalities | 多光子显微 · 谐波成像 (SHG/THG) · 相干拉曼与振动成像 · 光片与斜平面显微 · 超分辨与纳米显微 · 共聚焦与宽场荧光 · 荧光寿命与光谱成像 · OCT/OCM · 光声成像 · 漫射光学与近红外二区 · 内窥与光纤成像 · 无标记相位与全息成像 · 计算成像 · 自适应光学与深层组织 · 微型化与可穿戴 |
| 方法 Methods | AI、去噪与复原 · 探针与造影剂 · 仪器与光学设计 · 定量分析与建模 · 量子与新型衬度 |
| 生物应用 Applications | 神经科学 · 肿瘤与病理 · 细胞生物学 · 发育生物学与类器官 · 眼科 · 心血管与血流动力学 · 皮肤与外科 · 免疫与炎症 · 微生物与植物 · 临床转化 |
| 其他 | 新闻与亮点 · 综述 · 实验方案与资源 · 招聘与招生 · 学位论文 |

每篇论文最多 5 个标签（模态 2、方法 1、应用 1、其他 1，见 `category_limits`）。没有可用配图时，网站按第一个命中的模态画一个示意小图（激发锥、光片、拉曼谱峰、OCT 干涉信号、光声波前……，见 `glyphs`）。

## 网址与运行方式

- **网站**：https://linshulang12-u.github.io/BioImagingNews/
- **单文件版**：https://linshulang12-u.github.io/BioImagingNews/BioImagingNews.html 把全部数据嵌在一个 html 里，下载后双击即可离线浏览；缩略图从网站加载。
- **Windows 本地副本**：双击 `setup_windows.bat`，每天 08:37 自动下载最新的 `BioImagingNews.html`（不需要 Python）。
- **本机抓取（可选）**：`setup_local_crawl.bat`，和 GitHub 方式二选一。

## 日常流程

1. **每天 06:43（新加坡时间）**：自动抓取过去 3 天的新论文（OpenAlex 回看 30 天），加入当周这一期，直接发布。已出现过或被删除过的论文不会重复出现。
2. **随时修改**：在 GitHub 网页上编辑当期的 `data/issues/<日期>.json`，保存后网站自动更新：删文章并把 `id` 加进 `"removed"`；`"feature": true` 设为 Feature of the Week，`"pick": true` 设为 Feature Articles，在 `"why"` 写一句为什么重要。
3. **投稿 / 手动加文章**：把 DOI 一行一个写进 `data/inbox.txt` 并保存，会**立即**触发一次抓取（不受关键词过滤），顺便给手动加入的文章补缩略图，处理完自动从 inbox 删除。
4. **选稿助手**：`python scraper/curate.py apply <文件>`。每期最多 15 篇特稿，超出时替换入选最早的，Feature of the Week 不会被替换。

## 抓取范围与去杂

全部在 `scraper/config.yaml`：

- **收录**：各类光学成像模态及其方法学（探针、仪器、重建算法、AI 去噪），拉曼 / SRS、OCT 照收。Biomedical Optics Express、JBO、Neurophotonics、Photoacoustics、Journal of Biophotonics 五种核心期刊每篇都收（`core_journals`）。
- **排除**：非光学的影像（MRI、CT、PET、超声单独成像）、电镜 / AFM（除非结合光学）、遥感、食品检测、LED / 光伏；光热 / 光动力治疗、纳米酶这类 “治疗为主、成像为辅” 的论文只有标题里有成像方法时才收；常规临床 OCT 测量、队列统计类论文不收。
- **期刊质量**（`venues`）：主流出版社和 arXiv / bioRxiv 直接收；其他期刊 OpenAlex h-index ≥ 40 才收。

## 本地运行

```
pip install -r scraper/requirements.txt pytest
python -m pytest -q scraper/tests                 # 离线自测
python scraper/news_scraper.py --daily            # 每日模式
python scraper/build_standalone.py                # 重建 BioImagingNews.html
python -m http.server 8000                        # 浏览 http://localhost:8000
```

## 致谢

页面布局、抓取与选稿流程改编自 ForestBin-Raman 的 [VibraNews](https://github.com/ForestBin-Raman/VibraNews)。公开发布前建议和原作者打个招呼，并保留这条致谢。
