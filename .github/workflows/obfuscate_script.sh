#!/bin/bash
# 代码混淆处理脚本

log() { echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"; }

log "开始代码混淆处理..."

# 安装混淆工具（示例使用 javascript-obfuscator，可根据实际语言调整）
if command -v npm &> /dev/null; then
    npm install -g javascript-obfuscator
fi

# 遍历文件进行混淆处理
find . -name "*.js" -type f | while read file; do
    log "处理文件: $file"
    
    # 方法1: 变量名混淆
    sed -i 's/var \([a-zA-Z][a-zA-Z0-9]*\)/var obf_\1/g' "$file"
    sed -i 's/let \([a-zA-Z][a-zA-Z0-9]*\)/let obf_\1/g' "$file"
    sed -i 's/const \([a-zA-Z][a-zA-Z0-9]*\)/const obf_\1/g' "$file"
    
    # 方法2: 字符串编码（简单base64）
    grep -o '".*"' "$file" | while read -r string; do
        if [ ${#string} -gt 10 ]; then
            encoded=$(echo "$string" | base64 | tr -d '\n')
            sed -i "s|$string|\"$(echo $encoded)\"|g" "$file"
        fi
    done
    
    # 方法3: 添加无用代码
    echo "// Obfuscated: $(date)" >> "$file"
done

log "代码混淆完成"
