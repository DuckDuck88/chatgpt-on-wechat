FROM python:3.9
WORKDIR /data/app/chatgpt-on-wechat

# 更新 vim ，如果要手动进入容器更改文件则使用下面的命令
# RUN apt-get update && apt-get install vim

# 修改指定 itchat登录文件，让微信登录二维码显示30s 后过期
RUN pip3 install itchat-uos==1.5.0.dev0 && pip3 install openai==0.25.0
RUN sed -i '/while not isLoggedIn:/i \        time.sleep(30)' $(pip3 show itchat-uos | grep Location | awk '{print $2}')/itchat/components/login.py

COPY . .

CMD ["python3", "app.py"]

# 构建
# docker build -t [name] .

# docker 运行 使用挂载方式修改 itchat
#docker run -d --name wechat-chatgpt -v $(pwd)/config.json:/data/app/chatgpt-on-wechat/config.json  -v /usr/local/lib/python3.6/site-packages/itchat/components/login.py:/usr/local/lib/python3.9/site-packages/itchat/components/login.py chatgpt-on-wechat
# docker 运行 使用自动修改脚本修改
#docker run -d --name wechat-chatgpt -v $(pwd)/config.json:/data/app/chatgpt-on-wechat/config.json   chatgpt-on-wechat

# 查看容器日志，会显示登录二维码
# docker logs -f [容器 ID]