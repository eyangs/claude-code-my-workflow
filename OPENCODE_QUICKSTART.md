# OpenCode 复现快速启动（本机版）

## 1) 先安装系统依赖（需要 sudo）

```bash
sudo apt update
sudo apt install -y texlive-xetex texlive-latex-extra texlive-fonts-recommended texlive-bibtex-extra biber \
  r-base quarto pdf2svg gh
```

> 若 `quarto` 在 apt 源不可用，请改用官方安装：
> https://quarto.org/docs/get-started/

## 2) 验证依赖

```bash
for c in opencode xelatex quarto Rscript pdf2svg gh; do
  printf "%-10s" "$c:"; command -v $c >/dev/null && echo "OK" || echo "MISSING";
done
```

## 3) 在项目目录启动 OpenCode

```bash
cd /home/yang/.openclaw/workspace/claude-code-my-workflow
opencode
```

## 4) 首次粘贴这段启动指令给 OpenCode

```text
我正在这个仓库里复现 claude-code-my-workflow，请你：
1) 先通读 README.md、CLAUDE.md、.claude/ 下的 agents/skills/rules/hooks；
2) 将配置从 Claude Code 工作流适配为 OpenCode 可执行流程（保留科研 workflow 核心能力）；
3) 输出一份“最小可跑路径”：从一个 Slides/*.tex 到 Quarto/*.qmd，再到 docs/ 的端到端步骤；
4) 生成一个 demo 任务并执行（含编译/渲染/验证），失败时自动修复并复跑；
5) 最后给我结果摘要、改动文件清单、以及下一步建议。
```

## 5) 推荐先跑一个最小验收任务

```text
请用 /compile-latex 对任意一份 Slides/*.tex 编译；
再执行一次 Beamer -> Quarto 的最小转换；
最后给出质量评分和问题列表。
```
