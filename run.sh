# ====== 改这里 ======
GITHUB_USER="wanhongbo"
REPO_NAME="myTestSite"           # 例如 my-site
SITE_DIR="."                     # HTML所在目录；如果是 doc/legal 就改成 doc/legal
BRANCH="main"
# ====================

# 1) 初始化并提交
git init
git add .
git commit -m "chore: init static site for GitHub Pages"
git branch -M "$BRANCH"

# 2) 在 GitHub 创建同名仓库后，绑定远程并推送
git remote add origin "git@github.com:${GITHUB_USER}/${REPO_NAME}.git"
git push -u origin "$BRANCH"

# 3) 生成 Pages 配置（GitHub Actions 部署）
mkdir -p .github/workflows
cat > .github/workflows/pages.yml <<'YAML'
name: Deploy static site to GitHub Pages

on:
  push:
    branches: ["main"]
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: "pages"
  cancel-in-progress: true

jobs:
  deploy:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup Pages
        uses: actions/configure-pages@v5

      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: .

      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
YAML

# 4) 提交并触发部署
git add .github/workflows/pages.yml
git commit -m "ci: add github pages deployment workflow"
git push