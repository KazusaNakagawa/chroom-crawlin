FROM python:3.9


# install google chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'

RUN apt-get update && apt-get install -y \
    google-chrome-stable \
    unzip

# set display port to avoid crash
ENV DISPLAY=:99

# root権限意外でも扱えるようにする 共有サーバとか
WORKDIR /opt

# install chromedriver
RUN wget -O /tmp/chromedriver.zip http://chromedriver.storage.googleapis.com/`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE`/chromedriver_linux64.zip && \
    unzip /tmp/chromedriver.zip chromedriver -d /usr/local/bin/

COPY ./requirements.txt ./
RUN pip3 install --upgrade pip && \
    pip3 install -r requirements.txt

COPY . .

WORKDIR /work
CMD ["/bin/bash"]
