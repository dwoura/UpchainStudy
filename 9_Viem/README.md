# Viem 上手
## 初始化文件夹
npm init

## 依赖安装
npm install dotenv viem
npm install -D typescript ts-node @types/node

## 在项目中初始化typescript的配置文件
npx tsc --init

## 新建一个index.ts文件，在里面写代码

## 打开根目录中的package.json，在scripts中添加"start": "ts-node index.ts"。
"scripts": {
  "test": "echo \"Error: no test specified\" && exit 1",
  "start": "ts-node index.ts"
},

## 运行pnpm start，终端会显示目前的区块高度。
> viem-scripts@1.0.0 start /viem-playground/viem-scripts
> ts-node index.ts
