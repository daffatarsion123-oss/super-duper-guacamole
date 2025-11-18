FROM alpine:3.20

ENV LANG=C.UTF-8
ENV RAILS_ENV=production 
ENV NODE_ENV=production

RUN apk update && \
    apk add --no-cache --no-progress \
    bash curl git wget \
    build-base openssl-dev readline-dev zlib-dev \
    libffi-dev yaml-dev sqlite-dev libxml2-dev libxslt-dev \
    postgresql-client postgresql-dev \
    autoconf bison patch rust \
    ncurses-dev gdbm-dev jemalloc-dev \
    linux-headers unzip \
    nodejs npm \
    openjdk17-jdk openjdk17-jre \
    ruby ruby-dev ruby-bundler \
    shared-mime-info \
    tzdata

ENV TZDIR=/usr/share/zoneinfo

RUN wget https://download.clojure.org/install/linux-install-1.11.4.1474.sh && \
    chmod +x linux-install-1.11.4.1474.sh && \
    ./linux-install-1.11.4.1474.sh && \
    rm linux-install-1.11.4.1474.sh

RUN gem install bundler:2.5.22 && \
    gem install benchmark -v 0.3.0

WORKDIR /leihs

COPY . .

WORKDIR /leihs/database
RUN bundle install

WORKDIR /leihs/admin
RUN bundle install
RUN npm install --include=dev || echo "No package.json"
WORKDIR /leihs/admin/ui
RUN npm install --include=dev && npm run build && \
    rm -rf ../resources/public/admin/ui && \
    cp -r dist ../resources/public/admin/ui
WORKDIR /leihs/admin
RUN npx shadow-cljs release leihs-admin-js || echo "No shadow-cljs"
RUN clojure -T:build uber || echo "Admin JAR build failed"

WORKDIR /leihs/borrow
RUN bundle install
RUN npm install --include=dev || echo "No package.json"
WORKDIR /leihs/borrow/ui
RUN npm install --include=dev && npm run build && \
    rm -rf ../resources/public/borrow/ui && \
    cp -r dist ../resources/public/borrow/ui
WORKDIR /leihs/borrow
RUN npx shadow-cljs release leihs-borrow-js || echo "No shadow-cljs"
RUN clojure -T:build uber || echo "Borrow JAR build failed"

WORKDIR /leihs/inventory
RUN bundle install
RUN npm install || echo "No package.json"
RUN npm run build || echo "Inventory build failed"
RUN clojure -T:build uber || echo "Inventory JAR build failed"

WORKDIR /leihs/my
RUN bundle install
RUN npm install --include=dev || echo "No package.json"
WORKDIR /leihs/my/ui
RUN npm install --include=dev && npm run build && \
    rm -rf ../resources/public/my/ui && \
    cp -r dist ../resources/public/my/ui
WORKDIR /leihs/my
RUN npx shadow-cljs release leihs-my-js || echo "No shadow-cljs"
RUN clojure -T:build uber || echo "My JAR build failed"

WORKDIR /leihs/procure/server
RUN bundle install
RUN npm install || echo "No package.json"
RUN clojure -T:build uber || echo "Procure JAR build failed"

WORKDIR /leihs/legacy
RUN bundle install

WORKDIR /leihs/mail
RUN bundle install
RUN clojure -T:build uber || echo "Mail JAR build failed"

WORKDIR /leihs

CMD ["bash"]