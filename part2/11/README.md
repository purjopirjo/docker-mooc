```
Skip exercise


Notes: 
# create nextjs project:
# windows
npx create-next-app@latest my-app --typescript --eslint --no-postcss --no-sass --no-less --no-styled-components --tailwind --brotli --no-src-dir --app --import-alias "@/*" && cd ./my-app && npx next telemetry disable && powershell -Command "(Get-Content .eslintrc.json -Raw) -replace '\"extends\": \"next/core-web-vitals\"', '\"extends\": [\"next/babel\", \"next/core-web-vitals\"]' | Set-Content .eslintrc.json" && cd ..
# unix
npx create-next-app@latest my-app --typescript --eslint --no-postcss --no-sass --no-less --no-styled-components --tailwind --brotli --no-src-dir --app --import-alias "@/*" && cd ./my-app && npx next telemetry disable && sed -i 's/"extends": "next\/core-web-vitals"/"extends": \["next\/babel", "next\/core-web-vitals"\]/' .eslintrc.json && cd ..
```