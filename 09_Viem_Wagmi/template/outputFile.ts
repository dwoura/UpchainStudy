//@ts-nocheck

/**
 *  写普通文件
 */
const fs = require('fs');

// 创建一个写入流，将监听到的日志写入 logs.txt
const logStream = fs.createWriteStream('logs.txt', { flags: 'a' }); // 'a' 表示追加模式

const unwatch = contract.watchEvent.Transfer(
    {
        from: '0xd8da6bf26964af9d7eed9e03e53415d37aa96045',
        to: '0xa5cc3c03994db5b0d9a5eedd10cabab0813678ac'
    },
    {
        onLogs: logs => {
            const logData = JSON.stringify(logs) + '\n';  // 转成字符串并换行
            logStream.write(logData);
        }
    }
);

// 在不再需要监听时，调用 unwatch 并关闭文件流
process.on('exit', () => {
    unwatch();
    logStream.end(); // 关闭写入流
});




/**
 * 写 csv 文件
 */
import { createPublicClient, contract } from 'viem';
import { createObjectCsvWriter } from 'csv-writer';
import dotenv from 'dotenv';

dotenv.config();

// 创建CSV writer
const csvWriter = createObjectCsvWriter({
  path: 'event_logs.csv',
  header: [
    { id: 'from', title: 'From' },
    { id: 'to', title: 'To' },
    { id: 'value', title: 'Value' },
    { id: 'timestamp', title: 'Timestamp' }
  ]
});

// 实例化合约
const myContract = contract({
  address: '0xYourContractAddress',
  abi: [ /* Your ABI here */ ]
});

// 监听事件
const unwatch = myContract.watchEvent.Transfer(
  { from: '0xSourceAddress', to: '0xTargetAddress' },
  {
    onLogs: async logs => {
      // 将每个日志格式化为CSV行
      const rows = logs.map(log => ({
        from: log.args.from,
        to: log.args.to,
        value: log.args.value.toString(),
        timestamp: new Date().toISOString()
      }));

      // 写入到CSV文件
      await csvWriter.writeRecords(rows);
      console.log('写入CSV成功', rows);
    },
    onError: err => {
      console.error('监听错误:', err);
    }
  }
);

// 停止监听的调用方法
// unwatch();

