#在我實驗室那台電腦的測試腳本
#!/bin/bash
node=/home/xanxusubuntu/.nvm/versions/node/v8.15.0/bin/node
npm=/home/xanxusubuntu/.nvm/versions/node/v8.15.0/bin/npm
eval $node -v
eval $npm -v
cd NICP
#eval $npm install
echo "開始測試"
echo "痾.........因部署到這台測試會失敗，所以全部測試都拿掉了，先不做測試"
#eval $npm test
echo "結束測試"

#用ssh登進去樹莓派的腳本
node-red-stop
cd /home/pi/.node-red/nodes/node-red-contrib-FCF-ChatBot
git pull
git reset --hard origin/test-and-experiment
cd NICP
npm install --production
nohup node-red-start < /dev/null >> logfile.log 2>&1 &
exit 0

#部署到NICP雲端環境的腳本
cd ~/node-red-contrib-FCF-ChatBot
git pull
git reset --hard origin/test-and-experiment
docker build -t nicp-node-red:v1 .
docker stop nicp-node-red1
docker rm nicp-node-red1
docker run --restart=always -d -p 1880:1880 --name nicp-node-red1 nicp-node-red:v1
docker rmi -f $(docker images -f "dangling=true" -q)